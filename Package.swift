// swift-tools-version:6.1

import PackageDescription

let package = Package(
  name: "Shell",
  platforms: [ .macOS(.v15) ],
  products: [
    .library(name: "Shell", targets: [ "Shell" ]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/swiftlang/swift-subprocess.git",
      from: "0.1.0"
    ),
    .package(
      url: "https://github.com/apple/swift-system.git",
      from: "1.4.0"
    )
  ],
  targets: [
    .target(
      name: "Shell",
      dependencies: [
        .product(name: "Subprocess",
                 package: "swift-subprocess"),
        .product(name: "SystemPackage",
                 package: "swift-system")
      ]
    ),
    .testTarget(
      name: "ShellTests",
      dependencies: [ "Shell" ]
    )
  ]
)
