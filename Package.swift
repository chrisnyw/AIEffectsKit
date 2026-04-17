// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "AIEffectsKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "AIEffectsKit", targets: ["AIEffectsKit"])
    ],
    targets: [
        .target(
            name: "AIEffectsKit",
            path: "Sources/AIEffectsKit"
        ),
        .testTarget(
            name: "AIEffectsKitTests",
            dependencies: ["AIEffectsKit"],
            path: "Tests/AIEffectsKitTests"
        )
    ]
)
