// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_applovin",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-applovin",
      targets: ["gma_mediation_applovin"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-applovin.git",
      from: "13.6.300"),
  ],
  targets: [
    .target(
      name: "gma_mediation_applovin",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "GoogleMobileAdsMediationAppLovin",
          package: "googleads-mobile-ios-mediation-applovin"),
      ],
      path: "Sources/gma_mediation_applovin"
    )
  ]
)
