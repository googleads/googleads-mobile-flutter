# Google Mobile Ads API Demo

A comprehensive Flutter demo application that showcases all primary Google Mobile Ads (AdMob) formats in a single unified project with a landing screen menu.

## Included Ad Formats

1. **App Open Ad** (`AppOpenPage`) - Full-screen ads designed for app open and foreground transition events.
2. **Banner Ad** (`BannerPage`) - Anchored adaptive banners that adjust dynamically to device width and orientation changes.
3. **Interstitial Ad** (`InterstitialPage`) - Full-screen interstitial ads shown at game over / natural transition breakpoints.
4. **Native Platform Ad** (`NativePlatformPage`) - Custom native ad layout rendered via platform-specific code (Android XML layout and iOS XIB layout) with `NativeAdFactory`.
5. **Native Template Ad** (`NativeTemplatePage`) - Native ads styled and rendered directly in Flutter using `NativeTemplateStyle`.
6. **Rewarded Ad** (`RewardedPage`) - Rewarded video ads rewarding users with in-app currency upon completion.
7. **Rewarded Interstitial Ad** (`RewardedInterstitialPage`) - Rewarded ads with a pre-roll countdown prompt before ad display.

## Features

- **Centralized Consent Management**: Uses Google's User Messaging Platform (UMP) via `ConsentManager` singleton.
- **Ad Inspector**: Built-in support for launching the GMA Ad Inspector from the app bar menu.
- **Privacy Settings**: User privacy options form support from the app bar menu.
- **State & Lifecycle Management**: Safe ad resource disposal on screen exit to prevent memory leaks.

## Getting Started

1. Run `flutter pub get` to install dependencies.
2. Run `flutter run` on an iOS or Android device/emulator.
