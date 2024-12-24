import 'package:flutter/material.dart';
import 'package:testudy/Configs/appTheme.dart';
import 'package:testudy/screens/studyTimeAdder.dart';
import 'package:testudy/screens/studyTimer.dart';
class StudyTimeAdd extends StatefulWidget {
  const StudyTimeAdd({Key? key}) : super(key: key);

  @override
  _StudyTimeAddState createState() => _StudyTimeAddState();
}

class _StudyTimeAddState extends State<StudyTimeAdd> {
  int currentIndex = 0;
  List<Widget> _children = [];
  static const List<Widget> _icons = [
    Icon(Icons.calculate),
    Icon(Icons.timer),
  ];
  void initState(){
    super.initState();
    _children = [
      StudyTimer(),
      StudyTimeAdder(),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: _children[currentIndex],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          currentIndex += 1;
          currentIndex = currentIndex % 2;
          setState(() {});
        },
        child: _icons[currentIndex],
      ),
    );
  }
}