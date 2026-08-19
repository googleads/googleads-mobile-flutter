// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_inmobi",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-inmobi",
      targets: ["gma_mediation_inmobi"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-inmobi.git",
      from: "11.4.100"),
  ],
  targets: [
    .target(
      name: "gma_mediation_inmobi",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "InMobiAdapterTarget",
          package: "googleads-mobile-ios-mediation-inmobi"),
      ],
      path: "Sources/gma_mediation_inmobi"
    )
  ]
)
