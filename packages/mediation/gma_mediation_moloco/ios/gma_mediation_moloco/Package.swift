// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_moloco",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-moloco",
      targets: ["gma_mediation_moloco"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-moloco.git",
      from: "4.9.000"),
  ],
  targets: [
    .target(
      name: "gma_mediation_moloco",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "MolocoAdapterTarget",
          package: "googleads-mobile-ios-mediation-moloco"),
      ],
      path: "Sources/gma_mediation_moloco"
    )
  ]
)
