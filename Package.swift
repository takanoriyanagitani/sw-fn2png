// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "FuncToPng",
  products: [
    .library(name: "FuncToPng", targets: ["FuncToPng"])
  ],
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint", from: "0.58.2"),
    .package(url: "https://github.com/takanoriyanagitani/sw-img2png", from: "0.2.0"),
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.3"),
  ],
  targets: [
    .target(
      name: "FuncToPng",
      dependencies: [
        .product(name: "FpUtil", package: "sw-img2png"),
        .product(name: "ImageToPng", package: "sw-img2png"),
      ]
    ),
    .testTarget(
      name: "FuncToPngTests",
      dependencies: ["FuncToPng"]
    ),
  ]
)
