// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_imobile",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-imobile",
      targets: ["gma_mediation_imobile"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-imobile.git",
      from: "2.3.407"),
  ],
  targets: [
    .target(
      name: "gma_mediation_imobile",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "IMobileAdapterTarget",
          package: "googleads-mobile-ios-mediation-imobile"),
      ],
      path: "Sources/gma_mediation_imobile"
    )
  ]
)
