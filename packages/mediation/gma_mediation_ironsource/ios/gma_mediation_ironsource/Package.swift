// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_ironsource",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-ironsource",
      targets: ["gma_mediation_ironsource"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-ironsource.git",
      from: "9.5.00000"),
  ],
  targets: [
    .target(
      name: "gma_mediation_ironsource",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "IronSourceAdapterTarget",
          package: "googleads-mobile-ios-mediation-ironsource"),
      ],
      path: "Sources/gma_mediation_ironsource"
    )
  ]
)
