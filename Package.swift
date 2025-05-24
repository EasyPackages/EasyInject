// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "EasyInject",
    products: [
        .library(name: "EasyInject", targets: ["EasyInject"]),
        .library(name: "EasyGlobalInject", targets: ["EasyGlobalInject"]),
    ],
    targets: [
        .target(name: "EasyInject"),
        
        .target(name: "EasyGlobalInject", dependencies: ["EasyInject"]),
        .testTarget(name: "EasyGlobalInjectTests", dependencies: ["EasyGlobalInject"]),
    ]
)
