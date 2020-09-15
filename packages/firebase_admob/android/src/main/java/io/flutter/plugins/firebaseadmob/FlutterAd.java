package io.flutter.plugins.firebaseadmob;

abstract class FlutterAd {
  interface FlutterAdWithoutView {
    void show();
  }

  abstract void load();
}
