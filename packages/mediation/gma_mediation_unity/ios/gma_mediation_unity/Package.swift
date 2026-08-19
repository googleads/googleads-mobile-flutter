// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_unity",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-unity",
      targets: ["gma_mediation_unity"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-unity.git",
      from: "4.19.000"),
  ],
  targets: [
    .target(
      name: "gma_mediation_unity",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "UnityAdapterTarget",
          package: "googleads-mobile-ios-mediation-unity"),
      ],
      path: "Sources/gma_mediation_unity"
    )
  ]
)
