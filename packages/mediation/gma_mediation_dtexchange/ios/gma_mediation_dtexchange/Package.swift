// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_dtexchange",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-dtexchange",
      targets: ["gma_mediation_dtexchange"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-dtexchange.git",
      from: "8.4.1000"),
  ],
  targets: [
    .target(
      name: "gma_mediation_dtexchange",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "DTExchangeAdapterTarget",
          package: "googleads-mobile-ios-mediation-dtexchange"),
      ],
      path: "Sources/gma_mediation_dtexchange"
    )
  ]
)
