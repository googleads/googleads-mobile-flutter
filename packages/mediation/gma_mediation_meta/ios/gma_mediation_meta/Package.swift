// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_meta",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-meta",
      targets: ["gma_mediation_meta"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-meta.git",
      from: "6.21.101"),
  ],
  targets: [
    .target(
      name: "gma_mediation_meta",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "MetaAdapterTarget",
          package: "googleads-mobile-ios-mediation-meta"),
      ],
      path: "Sources/gma_mediation_meta"
    )
  ]
)
