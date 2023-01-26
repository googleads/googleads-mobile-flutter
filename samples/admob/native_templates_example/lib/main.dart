import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MaterialApp(
    home: NativeExample(),
  ));
}

/// A simple app that loads a native ad.
class NativeExample extends StatefulWidget {
  const NativeExample({super.key});

  @override
  NativeExampleState createState() => NativeExampleState();
}

class NativeExampleState extends State<NativeExample> {
  NativeAd? _nativeAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Example',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Native Example'),
          ),
          body: Stack(
            children: const [],
          )),
    );
  }

  /// Loads a native ad.
  void _loadAd() {}

  @override
  void dispose() {
    super.dispose();
  }
}
