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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20), // 上部にパディングを追加
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
            child: const Text(
              '勉強時間一覧',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: studyRecords.isEmpty
              ? const Center(
                  child: Text('表示可能なデータがありません',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadStudyRecords,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: studyRecords.length,
                    itemBuilder: (context, index) {
                      final record = studyRecords[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Card(
                          elevation: 2,
                          child: InkWell(
                            onTap: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => StudyTimeEdit(record: record),
                                ),
                              );
                              if (result == true) {
                                _loadStudyRecords();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        record.subject,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _formatDateTime(record.date),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    record.studyTime >= 60 
                                      ? '${(record.studyTime / 60).floor()}時間${record.studyTime % 60}分'
                                      : '${record.studyTime}分',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  if (record.description.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      record.description,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ),
        ],
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
