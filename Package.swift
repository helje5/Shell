// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Shell",
    products: [
        .library(name: "Shell", targets: ["Shell"]),
    ],
    dependencies: [],
    targets: [
        .target    (name: "Shell",      dependencies: []),
        .testTarget(name: "ShellTests", dependencies: ["Shell"])
    ]
)
