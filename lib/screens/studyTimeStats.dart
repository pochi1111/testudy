import 'package:flutter/material.dart';
import 'package:testudy/configs/appTheme.dart';
import 'package:testudy/services/studyTime.dart';
import 'package:testudy/screens/elements/weekTimeGraph.dart';

class StudyTimeStats extends StatefulWidget {
  const StudyTimeStats({super.key});

  @override
  _StudyTimeStatsState createState() => _StudyTimeStatsState();
}

class _StudyTimeStatsState extends State<StudyTimeStats> {
  List<int> studyRecordsWeek = [];
  String totalStudyTime = '';
  String totalRecordNum = '';
  @override
  void initState() {
    super.initState();
    _loadStudyRecords();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 0,
      ),
      body: studyRecordsWeek.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStudyRecords,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: screenWidth * 0.4,
                                child: Column(
                                  children: [
                                    const Text(
                                      "総勉強時間",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: totalStudyTime,
                                        style: const TextStyle(fontSize: 30),
                                        children: const [
                                          TextSpan(
                                            text: '時間',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: screenWidth * 0.4,
                                child: Column(
                                  children: [
                                    const Text(
                                      "総レコード数",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: totalRecordNum,
                                        style: const TextStyle(fontSize: 30),
                                        children: const [
                                          TextSpan(
                                            text: '回',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 10, right: 10),
                          color: appTheme.colorScheme.onPrimary,
                          child: const Text(
                            "一週間の勉強時間",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                            child: studyRecordsWeek.every((time) => time == 0)
                              ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                "一週間勉強記録がありません",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                ),
                              )
                              : WeekTimeGraph(
                                studyTimesInt: studyRecordsWeek),
                        ),
                      ]),
                ),
              ),
            ),
    );
  }

  Future<void> _loadStudyRecords() async {
    try {
      final now = DateTime.now();
      final weekstart = now.subtract(const Duration(days: 7));
      final weekend = now;
      final totalRecordNum = await StudyTimeAPI().getTotalRecordNum();
      final studyTimeWeek =
          await StudyTimeAPI().getRangeEachStudyTime(weekstart, weekend);
      final int totalStudyTime = (await StudyTimeAPI().getTotalStudyTime()/60).floor();
      setState(() {
        this.totalStudyTime = totalStudyTime.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (Match match) => ','
        );
        this.totalRecordNum = totalRecordNum.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (Match match) => ','
        );
        studyRecordsWeek = studyTimeWeek;
      });
    } catch (e) {
      print('Error loading study records: $e');
    }
  }
}
