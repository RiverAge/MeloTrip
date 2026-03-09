// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "desktop_lyrics",
    platforms: [
        .macOS("10.15")
    ],
    products: [
        .library(name: "desktop-lyrics", targets: ["desktop_lyrics"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "desktop_lyrics",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
