// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "EditValueView",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "EditValueView",
            targets: ["EditValueView"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/p-x9/SwiftUIColor.git", .upToNextMajor(from: "0.3.0"))
    ],
    targets: [
        .target(
            name: "EditValueView",
            dependencies: [
                .product(name: "SwiftUIColor", package: "SwiftUIColor")
            ]
        ),
        .testTarget(
            name: "EditValueViewTests",
            dependencies: ["EditValueView"]
        )
    ]
)
