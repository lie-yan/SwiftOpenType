// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftOpenType",
    products: [
        .library(
            name: "SwiftOpenType",
            targets: ["SwiftOpenType"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftOpenType",
            dependencies: []
        ),
        .testTarget(
            name: "SwiftOpenTypeTests",
            dependencies: ["SwiftOpenType"],
            resources: [
                .copy("fonts"),
            ]
        ),
    ]
)