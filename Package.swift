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
        .package(url: "https://github.com/p-x9/SwiftUIColor.git", exact: "0.0.4")
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
