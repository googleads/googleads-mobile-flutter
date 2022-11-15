import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rewarded_example/main.dart';

enum CountdownState {
  notStarted,
  active,
  ended,
}

class CountdownTimer extends ChangeNotifier {
  final _countdownTime = 10;
  late var timeLeft = _countdownTime;
  var _countdownState = CountdownState.notStarted;

  bool isComplete() {
    return _countdownState == CountdownState.ended;
  }

  void start() {
    timeLeft = _countdownTime;
    _resumeTimer();
    _countdownState = CountdownState.active;

    notifyListeners();
  }

  void _resumeTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      timeLeft--;

      if (timeLeft == 0) {
        _countdownState = CountdownState.ended;
        timer.cancel();
      }

      notifyListeners();
    });
  }
}
