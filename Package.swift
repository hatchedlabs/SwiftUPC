// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUPC",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SwiftUPC",
            targets: ["SwiftUPC"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftUPC",
            dependencies: []),
        .testTarget(
            name: "SwiftUPCTests",
            dependencies: ["SwiftUPC"]),
    ]
)
