// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "ShortcutExtractor",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(path: "../ShortcutScraping")
    ],
    targets: [
        .executableTarget(
            name: "ShortcutExtractor",
            dependencies: [
                .product(name: "ShortcutScraping", package: "ShortcutScraping")
            ]
        )
    ]
)
