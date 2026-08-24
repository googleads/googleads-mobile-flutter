// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_maio",
  platforms: [
    .iOS("15.0")
  ],
  products: [
    .library(
      name: "gma-mediation-maio",
      targets: ["gma_mediation_maio"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-maio.git",
      from: "2.2.200"),
  ],
  targets: [
    .target(
      name: "gma_mediation_maio",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "MaioAdapterTarget",
          package: "googleads-mobile-ios-mediation-maio"),
      ],
      path: "Sources/gma_mediation_maio"
    )
  ]
)
