// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_liftoffmonetize",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "gma-mediation-liftoffmonetize",
      targets: ["gma_mediation_liftoffmonetize"]
    )
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-liftoffmonetize.git",
      from: "7.7.600"),
  ],
  targets: [
    .target(
      name: "gma_mediation_liftoffmonetize",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(
          name: "LiftoffMonetizeAdapterTarget",
          package: "googleads-mobile-ios-mediation-liftoffmonetize"),
      ],
      path: "Sources/gma_mediation_liftoffmonetize"
    )
  ]
)
