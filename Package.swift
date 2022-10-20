// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "EditValueView",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "EditValueView",
            targets: ["EditValueView"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EditValueView",
            dependencies: []
        ),
        .testTarget(
            name: "EditValueViewTests",
            dependencies: ["EditValueView"]
        )
    ]
)
