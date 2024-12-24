import 'package:flutter/material.dart';
import 'package:testudy/screens/studyTimeAdd.dart';

class StudyTime extends StatefulWidget {
  const StudyTime({Key? key}) : super(key: key);

  @override
  _StudyTimeState createState() => _StudyTimeState();
}

class _StudyTimeState extends State<StudyTime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Study Time'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StudyTimeAdd()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}