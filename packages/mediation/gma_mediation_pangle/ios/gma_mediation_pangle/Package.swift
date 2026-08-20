// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_pangle",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-pangle",
      targets: ["gma_mediation_pangle"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-pangle.git",
      from: "8.2.00900"),
  ],
  targets: [
    .target(
      name: "gma_mediation_pangle",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "PangleAdapterTarget",
          package: "googleads-mobile-ios-mediation-pangle"),
      ],
      path: "Sources/gma_mediation_pangle"
    )
  ]
)
