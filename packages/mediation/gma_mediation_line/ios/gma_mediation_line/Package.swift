// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_line",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-line",
      targets: ["gma_mediation_line"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-line.git",
      from: "3.0.102"),
  ],
  targets: [
    .target(
      name: "gma_mediation_line",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "LineAdapterTarget",
          package: "googleads-mobile-ios-mediation-line"),
      ],
      path: "Sources/gma_mediation_line"
    )
  ]
)
