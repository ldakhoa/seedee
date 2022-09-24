// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Seedee",
    products: [
        .library(
            name: "Seedee",
            targets: ["Seedee"]),
    ],
    targets: [
        .target(
            name: "Seedee",
            dependencies: []),
        .testTarget(
            name: "SeedeeTests",
            dependencies: ["Seedee"]),
    ]
)
