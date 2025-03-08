// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "MonoFill",
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint", from: "0.58.2"),
    .package(url: "https://github.com/takanoriyanagitani/sw-img2png", from: "0.2.0"),
    .package(path: "../.."),
  ],
  targets: [
    .executableTarget(
      name: "MonoFill",
      dependencies: [
        .product(name: "FuncToPng", package: "sw-fn2png"),
        .product(name: "ImageToPng", package: "sw-img2png"),
      ]
    )
  ]
)
