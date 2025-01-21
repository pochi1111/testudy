import 'package:flutter/material.dart';
class StudyTimer extends StatefulWidget {
  const StudyTimer({super.key});

  @override
  _StudyTimerState createState() => _StudyTimerState();
}

class _StudyTimerState extends State<StudyTimer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: Text('Timer'),
      ),
    );
  }
}