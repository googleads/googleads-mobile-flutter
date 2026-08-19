// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_pubmatic",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-pubmatic",
      targets: ["gma_mediation_pubmatic"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-pubmatic.git",
      from: "5.2.000"),
  ],
  targets: [
    .target(
      name: "gma_mediation_pubmatic",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "PubMaticAdapterTarget",
          package: "googleads-mobile-ios-mediation-pubmatic"),
      ],
      path: "Sources/gma_mediation_pubmatic"
    )
  ]
)
