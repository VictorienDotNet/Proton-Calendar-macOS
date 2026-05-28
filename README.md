# Proton Calendar macOS wrapper

Minimal macOS app that wraps Proton Calendar (`https://account.proton.me/calendar`) in a single-window `WKWebView`.

## Behavior

- **Single window** (no tabs, no multi-window popups)
- **No offline caching** (uses a non-persistent `WKWebsiteDataStore`)
- **External links open in your default browser**, not inside the webview

## Run

1. Open `Package.swift` in Xcode (Xcode can run Swift Packages directly).
2. Select the `ProtonCalendarWrapper` scheme and Run.

## Customize

- Initial URL: `Sources/CalendarRootView.swift`
- Allowed in-app domains: `Sources/ProtonWebView.swift` (`allowedHostSuffixes`)

