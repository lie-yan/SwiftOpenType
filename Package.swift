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

    ],
    targets: [
        .target(
            name: "SwiftOpenType",
            dependencies: []
        ),
        .testTarget(
            name: "SwiftOpenTypeTests",
            dependencies: ["SwiftOpenType"]
        ),
    ]
)