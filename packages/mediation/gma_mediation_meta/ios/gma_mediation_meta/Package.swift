// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gma_mediation_meta",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(name: "gma-mediation-meta", targets: ["gma_mediation_meta"])
  ],
  dependencies: [
    // Google's Meta Audience Network mediation adapter, distributed as a Swift
    // Package (the SPM equivalent of the `GoogleMobileAdsMediationFacebook`
    // pod the podspec depends on). `branch: "main"` matches Google's documented
    // SPM integration for the adapter repos; the `MetaAdapterTarget` product
    // transitively brings in GoogleMobileAds + FBAudienceNetwork.
    .package(
      url: "https://github.com/googleads/googleads-mobile-ios-mediation-meta.git",
      branch: "main"),
  ],
  targets: [
    .target(
      name: "gma_mediation_meta",
      dependencies: [
        .product(name: "MetaAdapterTarget", package: "googleads-mobile-ios-mediation-meta"),
      ]
    )
  ]
)
