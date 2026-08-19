// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_mytarget",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-mytarget",
      targets: ["gma_mediation_mytarget"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-mytarget.git",
      from: "5.45.000"),
  ],
  targets: [
    .target(
      name: "gma_mediation_mytarget",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "MyTargetAdapterTarget",
          package: "googleads-mobile-ios-mediation-mytarget"),
      ],
      path: "Sources/gma_mediation_mytarget"
    )
  ]
)
