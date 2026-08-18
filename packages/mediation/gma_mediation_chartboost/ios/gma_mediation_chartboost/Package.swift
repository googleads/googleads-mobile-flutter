// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_chartboost",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-chartboost",
      targets: ["gma_mediation_chartboost"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-chartboost.git",
      from: "9.13.000"),
  ],
  targets: [
    .target(
      name: "gma_mediation_chartboost",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "ChartboostAdapterTarget",
          package: "googleads-mobile-ios-mediation-chartboost"),
      ],
      path: "Sources/gma_mediation_chartboost"
    )
  ]
)
