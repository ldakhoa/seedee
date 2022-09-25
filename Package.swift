// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Seedee",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/Bouke/Glob", from: "1.0.5"),
        .package(url: "https://github.com/mtynior/ColorizeSwift.git", from: "1.5.0"),
    ],
    targets: [
        .executableTarget(
            name: "seedee",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Glob",
                "ColorizeSwift",
            ]),
        .testTarget(
            name: "SeedeeTests",
            dependencies: ["seedee"]),
    ]
)
