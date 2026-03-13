// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "PipocandoCore",
  platforms: [.iOS(.v15)],
  products: [
    .library(name: "PipocandoCore", targets: ["PipocandoCore"])
  ],
  targets: [
    .target(name: "PipocandoCore")
  ]
)
