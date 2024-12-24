import 'package:flutter/material.dart';
class StudyTimer extends StatefulWidget {
  const StudyTimer({Key? key}) : super(key: key);

  @override
  _StudyTimerState createState() => _StudyTimerState();
}

class _StudyTimerState extends State<StudyTimer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Timer'),
      ),
    );
  }
}