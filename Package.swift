// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EnergyUsageAnalyzer",
    platforms: [
        .macOS(.v12),
        .iOS(.v13)
    ],
    products: [
        .executable(
            name: "EnergyUsageAnalyzer",
            targets: ["EnergyUsageAnalyzer"]
        ),
        .plugin(
            name: "EnergyUsageAnalyzerPlugin",
            targets: ["EnergyUsageAnalyzerPlugin"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.1"),
    ],
    targets: [
        .executableTarget(
            name: "EnergyUsageAnalyzer",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .plugin(
            name: "EnergyUsageAnalyzerPlugin",
            capability: .buildTool(),
            dependencies: [
                .target(name: "EnergyUsageAnalyzer")
            ]
        )
    ]
)
