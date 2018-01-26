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
        .package(url: "https://github.com/thoughtbot/Curry.git", "3.0.0" ..< "5.0.0"),
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
                "Curry",
            ],
            path: "Tests"
        ),
    ]
)
