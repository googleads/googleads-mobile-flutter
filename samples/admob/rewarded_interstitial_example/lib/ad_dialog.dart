import 'countdown_timer.dart';
import 'package:flutter/material.dart';

/// A simple class that displays an alert prompt prior to showing an ad.
class AdDialog extends StatefulWidget {
  final VoidCallback showAd;

  const AdDialog({
    Key? key,
    required this.showAd,
  }) : super(key: key);

  @override
  AdDialogState createState() => AdDialogState();
}

class AdDialogState extends State<AdDialog> {
  final CountdownTimer _countdownTimer = CountdownTimer(5);

  @override
  void initState() {
    _countdownTimer.addListener(() => setState(() {
          if (_countdownTimer.isComplete) {
            Navigator.pop(context);
            widget.showAd();
          }
        }));
    _countdownTimer.start();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Watch an ad for 10 more coins'),
      content: Text('Video starting in ${_countdownTimer.timeLeft} seconds...',
          style: const TextStyle(color: Colors.grey)),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'No thanks',
              style: TextStyle(color: Colors.red),
            ))
      ],
    );
  }

  @override
  void dispose() {
    _countdownTimer.dispose();
    super.dispose();
  }
}
