import 'dart:async';
import 'package:flutter/material.dart';

enum CountdownState { notStarted, active, paused, ended }

/// A simple class that keeps track of a decrementing timer.
class CountdownTimer extends ChangeNotifier {
  final int _countdownTime;
  late var timeLeft = _countdownTime;
  var _countdownState = CountdownState.notStarted;
  bool get isComplete => _countdownState == CountdownState.ended;
  Timer? _timer;

  CountdownTimer(this._countdownTime);

  void start() {
    timeLeft = _countdownTime;
    _startTimer();
    _countdownState = CountdownState.active;

    notifyListeners();
  }

  void resume() {
    if (_countdownState != CountdownState.paused) {
      return;
    }
    _startTimer();
    _countdownState = CountdownState.active;
  }

  void pause() {
    if (_countdownState != CountdownState.active) {
      return;
    }
    _timer?.cancel();
    _countdownState = CountdownState.paused;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeLeft--;

      if (timeLeft == 0) {
        _countdownState = CountdownState.ended;
        timer.cancel();
      }

      notifyListeners();
    });
  }
}
