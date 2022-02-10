// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftFoundation",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftFoundation",
            targets: ["SwiftFoundation"]),
        .library(
            name: "Testability",
            targets: ["Testability"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftFoundation",
            dependencies: []),
        .target(                            
            name: "Testability",
            dependencies: []),
        .testTarget(
            name: "SwiftFoundationTests",
            dependencies: ["SwiftFoundation"]),
    ]
)
