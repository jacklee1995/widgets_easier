// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "widgets_easier_privacy_guard",
    platforms: [
        .macOS("12.0")
    ],
    products: [
        .library(name: "widgets-easier-privacy-guard", targets: ["widgets_easier_privacy_guard"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "widgets_easier_privacy_guard",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
