import 'package:flutter/material.dart';
import 'dart:async';

class StudyTimer extends StatefulWidget {
  final int initialMinutes;
  
  const StudyTimer({
    super.key,
    required this.initialMinutes,
  });

  @override
  _StudyTimerState createState() => _StudyTimerState();
}

class _StudyTimerState extends State<StudyTimer> {
  Timer? timer;
  int donesec = 0;
  int doneminute = 0;
  int donehour = 0;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  bool isRunning = false;
  DateTime startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    doneminute = widget.initialMinutes%60;
    donehour = widget.initialMinutes~/60;
    minutes = doneminute;
    hours = donehour;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _stopTimer() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タイマー'),
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            iconSize: 30,
            onPressed: () {
              final totalMinutes = hours*60 + minutes;
              Navigator.pop(context, totalMinutes);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: RichText(
              text: TextSpan(
              style: const TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                text: '$hours',
                style: const TextStyle(fontSize: 45),
                ),
                const TextSpan(text: '時間 '),
                TextSpan(
                text: '$minutes',
                style: const TextStyle(fontSize: 45),
                ),
                const TextSpan(text: '分 '),
                TextSpan(
                text: '$seconds',
                style: const TextStyle(fontSize: 45),
                ),
                const TextSpan(text: '秒'),
              ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filled(
                onPressed: () {
                  if (isRunning) {
                    setState(() {
                      isRunning = false;
                      donesec = seconds;
                      doneminute = minutes;
                      donehour = hours;
                      _stopTimer();
                    });
                  } else {
                    setState(() {
                      isRunning = true;
                      startTime = DateTime.now();
                      _startTimer();
                    });
                  }
                },
                iconSize: 40,
                icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
              ),
              const SizedBox(width: 20),
              IconButton.filled(
                onPressed: () {
                  setState(() {
                    isRunning = false;
                    seconds = 0;
                    minutes = 0;
                    hours = 0;
                    donehour = 0;
                    doneminute = 0;
                    donesec = 0;
                    _stopTimer();
                  });
                },
                iconSize: 40,
                icon: const Icon(Icons.replay),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateTime() {
    if (!isRunning) return;
    final now = DateTime.now();
    Duration difference = now.difference(startTime);
    difference = Duration(seconds: difference.inSeconds + donesec + doneminute*60 + donehour*3600);
    setState(() {
      seconds = difference.inSeconds%60;
      minutes = difference.inSeconds%3600~/60;
      hours = difference.inSeconds~/3600;
    });
  }
}