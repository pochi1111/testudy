import 'package:flutter/material.dart';
import 'package:testudy/configs/appTheme.dart';
import 'package:testudy/services/studyTime.dart';
import 'package:testudy/screens/elements/weekTimeGraph.dart';

class StudyTimeStats extends StatefulWidget {
  const StudyTimeStats({Key? key}) : super(key: key);

  @override
  _StudyTimeStatsState createState() => _StudyTimeStatsState();
}

class _StudyTimeStatsState extends State<StudyTimeStats> {
  List<int> studyRecordsWeek = [];
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
      ),
      body: studyRecordsWeek.isEmpty
          ? const Center(child: const CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStudyRecords,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              padding: const EdgeInsets.only(
                                  left: 0, right: 20, top: 70, bottom: 10),
                              height: 340,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: WeekTimeGraph(
                                  studyTimesInt: studyRecordsWeek),
                            ),
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                color: appTheme.colorScheme.onPrimary,
                                child: const Text(
                                  "一週間の勉強時間",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
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
      final studyTimeWeek =
          await StudyTimeAPI().getRangeEachStudyTime(weekstart, weekend);
      setState(() {
        studyRecordsWeek = studyTimeWeek;
      });
      print("studyRecordsWeek: $studyRecordsWeek");
    } catch (e) {
      print('Error loading study records: $e');
    }
  }
}
