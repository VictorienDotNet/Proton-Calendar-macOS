#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="Proton Calendar"
EXECUTABLE_NAME="ProtonCalendarWrapper"

DIST_DIR="${ROOT_DIR}/dist"
APP_DIR="${DIST_DIR}/${APP_NAME}.app"
CONTENTS_DIR="${APP_DIR}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

ICON_PNG="${ROOT_DIR}/Sources/icon.png"
PLIST_IN="${ROOT_DIR}/packaging/Info.plist"

echo "==> Building (release)…"
cd "${ROOT_DIR}"
swift build -c release

BIN="${ROOT_DIR}/.build/release/${EXECUTABLE_NAME}"
if [[ ! -f "${BIN}" ]]; then
  echo "ERROR: expected binary at ${BIN}" >&2
  exit 1
fi

echo "==> Assembling .app bundle…"
rm -rf "${APP_DIR}"
mkdir -p "${MACOS_DIR}" "${RESOURCES_DIR}"

cp "${PLIST_IN}" "${CONTENTS_DIR}/Info.plist"
cp "${BIN}" "${MACOS_DIR}/${EXECUTABLE_NAME}"
chmod +x "${MACOS_DIR}/${EXECUTABLE_NAME}"

echo "==> Generating .icns from icon.png…"
if [[ ! -f "${ICON_PNG}" ]]; then
  echo "ERROR: missing icon at ${ICON_PNG}" >&2
  exit 1
fi

ICONSET_DIR="${DIST_DIR}/AppIcon.iconset"
rm -rf "${ICONSET_DIR}"
mkdir -p "${ICONSET_DIR}"

declare -a SIZES=(16 32 64 128 256 512)
for size in "${SIZES[@]}"; do
  sips -z "${size}" "${size}" "${ICON_PNG}" --out "${ICONSET_DIR}/icon_${size}x${size}.png" >/dev/null
  sips -z "$((size*2))" "$((size*2))" "${ICON_PNG}" --out "${ICONSET_DIR}/icon_${size}x${size}@2x.png" >/dev/null
done
sips -z 1024 1024 "${ICON_PNG}" --out "${ICONSET_DIR}/icon_512x512@2x.png" >/dev/null

iconutil -c icns "${ICONSET_DIR}" -o "${RESOURCES_DIR}/AppIcon.icns"
rm -rf "${ICONSET_DIR}"

echo "==> Done: ${APP_DIR}"
echo "Tip: You can move it to /Applications."

