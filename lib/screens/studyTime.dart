import 'package:flutter/material.dart';
import 'package:testudy/screens/studyTimeAdd.dart';
import 'package:testudy/services/studyTime.dart';
import 'package:testudy/screens/studyTimeEdit.dart';
import 'package:testudy/configs/appTheme.dart';

class StudyTime extends StatefulWidget {
  const StudyTime({super.key});

  @override
  _StudyTimeState createState() => _StudyTimeState();
}

class _StudyTimeState extends State<StudyTime> {
  List<StudyTimeRecord> studyRecords = [];

  @override
  void initState() {
    super.initState();
    _loadStudyRecords();
  }

  Future<void> _loadStudyRecords() async {
    try {
      final records = await StudyTimeAPI().getStudyTimeRecords(0);
      setState(() {
        studyRecords = records;
      });
    } catch (e) {
      print('Error loading study records: $e');
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final recordDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (recordDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    return '${dateTime.year}/${dateTime.month}/${dateTime.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: studyRecords.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStudyRecords,
              child: ListView.builder(
                itemCount: studyRecords.length,
                itemBuilder: (context, index) {
                  final record = studyRecords[index];
                  return ListTile(
                    title: Text(record.subject),
                    subtitle: Text(record.studyTime >= 60 
                      ? '${(record.studyTime / 60).floor()}時間${record.studyTime % 60}分'
                      : '${record.studyTime}分'),
                    trailing: Text(_formatDateTime(record.date)),
                    onTap: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              StudyTimeEdit(record: record),
                        ),
                      );
                      if (result == true) {
                        _loadStudyRecords();
                      }
                    },
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const StudyTimeAdd(),
            ),
          );
          if (result == true) {
            _loadStudyRecords();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
