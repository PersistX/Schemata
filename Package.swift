// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Schemata",
    products: [
        .library(
            name: "Schemata",
            targets: ["Schemata"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/antitypical/Result.git", from: "3.2.1"),
    ],
    targets: [
        .target(
            name: "Schemata",
            dependencies: [
                "Result",
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "SchemataTests",
            dependencies: [
                "Schemata",
            ],
            path: "Tests"
        ),
    ]
)
