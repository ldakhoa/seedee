// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Seedee",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(
            name: "seedee",
            targets: ["seedee"]),
        .library(
            name: "SeedeeKit",
            targets: ["SeedeeKit"]),

        // Testing for early stage, need to remove later
        .executable(name: "Example", targets: ["Example"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git",
                 .upToNextMinor(from: "1.2.1")),
        .package(url: "https://github.com/apple/swift-log.git",
                 .upToNextMinor(from: "1.4.2")),
        .package(url: "https://github.com/onevcat/Rainbow",
                 .upToNextMinor(from: "4.0.1")),
    ],
    targets: [
        .executableTarget(
            name: "seedee",
            dependencies: [
                .target(name: "SeedeeKit"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .target(
            name: "SeedeeKit",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Rainbow", package: "Rainbow"),
            ]),
        .testTarget(
            name: "SeedeeKitTests",
            dependencies: [
                .target(name: "SeedeeKit")
            ]),
        .executableTarget(name: "Example", dependencies: ["SeedeeKit"]),
    ]
)
