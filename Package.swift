// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ImpressionVisibility",
    products: [.library(name: "ImpressionVisibility", targets: ["ImpressionVisibility"])],
    targets: [
        .target(name: "ImpressionVisibility", path: "resources/ios", exclude: ["ImpressionRenderer.swift", "ImpressionsFunctions.swift"]),
        .testTarget(name: "ImpressionVisibilityTests", dependencies: ["ImpressionVisibility"], path: "tests/ios"),
    ]
)
