flutter pub run reference_generator \
        --dart-out lib/src/ad_containers.g.dart \
        --java-package io.flutter.plugins.googlemobileads.adcontainers \
        --java-out android/src/main/java/io/flutter/plugins/googlemobileads/adcontainers/AdContainersChannelLibrary.java \
         lib/src/ad_containers.dart

flutter pub run reference_generator --no-build \
        --dart-out lib/src/mobile_ads.g.dart \
        --java-package io.flutter.plugins.googlemobileads.mobileads \
        --java-out android/src/main/java/io/flutter/plugins/googlemobileads/mobileads/MobileAdsChannelLibrary.java \
         lib/src/mobile_ads.dart
