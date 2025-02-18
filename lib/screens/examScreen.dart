import 'package:flutter/material.dart';
import 'package:testudy/configs/appTheme.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({Key? key}) : super(key: key);

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('テストのスケジュール'),
        centerTitle: true,
        backgroundColor: appTheme.colorScheme.primary,
      ),
      body: const Center(
        child: Text('placeholder'),
      ),
    );
  }
}