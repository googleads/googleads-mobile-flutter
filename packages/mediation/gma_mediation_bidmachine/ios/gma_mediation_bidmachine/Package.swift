// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_bidmachine",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-bidmachine",
      targets: ["gma_mediation_bidmachine"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-bidmachine.git",
      from: "3.7.100"),
  ],
  targets: [
    .target(
      name: "gma_mediation_bidmachine",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "BidMachineAdapterTarget",
          package: "googleads-mobile-ios-mediation-bidmachine"),
      ],
      path: "Sources/gma_mediation_bidmachine"
    )
  ]
)
