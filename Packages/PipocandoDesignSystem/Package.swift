// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "PipocandoDesignSystem",
  platforms: [.iOS(.v15)],
  products: [
    .library(name: "PipocandoDesignSystem", targets: ["PipocandoDesignSystem"])
  ],
  targets: [
    .target(name: "PipocandoDesignSystem")
  ]
)
