import 'dart:async';
import 'package:flutter/material.dart';

enum CountdownState {
  notStarted,
  active,
  ended,
}

/// A simple class that keeps track of a decrementing timer.
class CountdownTimer extends ChangeNotifier {
  final int _countdownTime;
  late var timeLeft = _countdownTime;
  var _countdownState = CountdownState.notStarted;

  CountdownTimer(this._countdownTime);

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
