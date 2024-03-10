// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "swift-open-type",
    products: [
        .library(
            name: "SwiftOpenType",
            targets: ["SwiftOpenType"]
        ),
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
