flutter pub run reference_generator --dart-out lib/src/ad_containers.g.dart lib/src/ad_containers.dart
flutter pub run reference_generator --no-build --dart-out lib/src/mobile_ads.g.dart --dart-imports 'request_configuration.dart' lib/src/mobile_ads.dart
flutter pub run reference_generator --no-build --dart-out lib/src/request_configuration.g.dart lib/src/request_configuration.dart
