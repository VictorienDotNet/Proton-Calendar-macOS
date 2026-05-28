// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ProtonCalendarWrapper",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "ProtonCalendarWrapper", targets: ["ProtonCalendarWrapper"])
    ],
    targets: [
        .executableTarget(
            name: "ProtonCalendarWrapper",
            path: "Sources"
        )
    ]
)

