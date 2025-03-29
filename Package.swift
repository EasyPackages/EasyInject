// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "EasyInject",
    products: [
        .library(name: "EasyInject", targets: ["EasyInject"]),
        .library(name: "EasyInjectProvider", targets: ["EasyInjectProvider"]),
    ],
    targets: [
        .target(name: "EasyInject"),
        
        .target(name: "EasyInjectProvider", dependencies: ["EasyInject"]),
        .testTarget(name: "EasyInjectProviderTests", dependencies: ["EasyInjectProvider"]),
    ]
)
