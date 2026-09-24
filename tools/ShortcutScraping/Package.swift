// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "ShortcutScraping",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "ShortcutScraping", targets: ["ShortcutScraping"])
    ],
    targets: [
        .target(name: "ShortcutScraping")
    ]
)
