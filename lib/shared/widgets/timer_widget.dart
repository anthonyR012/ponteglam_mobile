import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';

class TimerCustomWidget extends StatefulWidget {
  const TimerCustomWidget(
      {super.key,
      this.colorNumber = whiteColorTheme,
      this.reloadTimer = false,
      required this.secondsRemaining,
      required this.callbackTimer});
  final Color colorNumber;
  final bool reloadTimer;
  final void Function(Timer) callbackTimer;
  final int secondsRemaining;

  @override
  State<TimerCustomWidget> createState() => _TimerCustomWidgetState();
}

class _TimerCustomWidgetState extends State<TimerCustomWidget> {
  late Timer _timer;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), widget.callbackTimer);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _formatDuration(Duration(seconds: widget.secondsRemaining)),
        style: TextStyle(fontSize: bodySize, color: widget.colorNumber),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
