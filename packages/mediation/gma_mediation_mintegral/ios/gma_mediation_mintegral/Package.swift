// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_mintegral",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-mintegral",
      targets: ["gma_mediation_mintegral"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-mintegral.git",
      from: "8.1.600"),
  ],
  targets: [
    .target(
      name: "gma_mediation_mintegral",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "MintegralAdapterTarget",
          package: "googleads-mobile-ios-mediation-mintegral"),
      ],
      path: "Sources/gma_mediation_mintegral"
    )
  ]
)
