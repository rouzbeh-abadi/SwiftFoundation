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
        .package(name: "NotificationBannerSwift", url: "https://github.com/Daltron/NotificationBanner", from: "3.0.6")
    ],
    targets: [
        .target(
            name: "SwiftFoundation",
            dependencies: ["NotificationBannerSwift"]),
        .target(                            
            name: "Testability",
            dependencies: []),
        .testTarget(
            name: "SwiftFoundationTests",
            dependencies: ["SwiftFoundation"]),
    ]
)
