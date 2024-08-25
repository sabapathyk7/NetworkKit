// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NetworkKit",
            targets: ["NetworkKit"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NetworkKit",
            swiftSettings: [
            .enableUpcomingFeature("StrictConcurrency"),
            .enableUpcomingFeature("InternalImportsByDefault")
        ]),
        .testTarget(
            name: "NetworkKitTests",
            dependencies: ["NetworkKit"])
    ]
)
