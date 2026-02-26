// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "google_mobile_ads",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "google-mobile-ads", targets: ["google_mobile_ads"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", from: "12.14.0"),
        .package(name: "webview_flutter_wkwebview", path: "../webview_flutter_wkwebview"),
    ],
    targets: [
        .target(
            name: "google_mobile_ads",
            dependencies: [
              .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
              .product(name: "webview-flutter-wkwebview", package: "webview_flutter_wkwebview"),
            ],
            resources: [
              .process("Resources"),
            ],
            cSettings: [
                .headerSearchPath("include/google_mobile_ads")
            ]
        )
    ]
)
