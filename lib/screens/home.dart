import 'package:flutter/material.dart';
import 'package:testudy/services/examSchedule.dart';
import 'package:testudy/screens/examEdit.dart';
import 'package:testudy/services/studyTime.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Exam? nextExam;
  Duration? timeUntilExam;
  int todayStudyTime = 0;
  int weeklyAverageTime = 0;
  List<StudyTimeRecord> studyRecords = [];

  @override
  void initState() {
    super.initState();
    _loadNextExam();
    _loadStudyTimes();
    _loadRecentStudyRecords();
  }

  Future<void> _loadNextExam() async {
    final exams = await ExamAPI().getAfterExams(1);
    if (exams.isNotEmpty) {
      setState(() {
        nextExam = exams.first;
        timeUntilExam = nextExam!.dateTime.difference(DateTime.now());
      });
    } else {
      setState(() {
        nextExam = null;
        timeUntilExam = null;
      });
    }
  }

  Future<void> _loadStudyTimes() async {
    final studyTimeAPI = StudyTimeAPI();
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: 7));
    
    // 今日の勉強時間を取得
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    todayStudyTime = await studyTimeAPI.getRangeStudyTime(todayStart, todayEnd);

    // 過去7日間の勉強時間を取得して平均を計算
    final weeklyTimes = await studyTimeAPI.getRangeEachStudyTime(weekStart, now);
    if (weeklyTimes.isNotEmpty) {
      weeklyAverageTime = weeklyTimes.reduce((a, b) => a + b) ~/ weeklyTimes.length;
    }

    setState(() {});
  }

  Future<void> _loadRecentStudyRecords() async {
    final studyTimeAPI = StudyTimeAPI();
    final records = await studyTimeAPI.getStudyTimeRecords(5);
    setState(() {
      studyRecords = records;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(  // 全体をスクロール可能に
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (nextExam == null)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      '予定されているテストはありません',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,  // 灰色を追加
                      ),
                    ),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '次のテストまで',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        '${timeUntilExam?.inDays ?? 0}日',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,  // 横幅いっぱいに広げる
                      child: Card(
                        child: InkWell(  // InkWellを追加
                          onTap: () async {
                            if (nextExam != null) {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ExamEdit(exam: nextExam!),
                                ),
                              );
                              if (result == true) {
                                // 編集後に最新の試験情報を再読み込み
                                await _loadNextExam();
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nextExam?.title ?? '',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  DateFormat('yyyy年MM月dd日').format(nextExam?.dateTime ?? DateTime.now()),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                if (nextExam?.description?.isNotEmpty ?? false) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    nextExam?.description ?? '',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 30),
              const Text(
                '今日の勉強時間',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,  // 親Columnを左寄せ
                children: [
                  // 週平均を表示
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,  // 週平均を左寄せ
                    children: [
                      Text(
                        weeklyAverageTime ~/ 60 > 0
                          ? '${weeklyAverageTime ~/ 60}時間${weeklyAverageTime % 60}分'
                          : '${weeklyAverageTime % 60}分',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('週平均', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 今日の勉強時間と差分を横並びに
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,  // spaceEvenlyからstartに変更
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,  // 今日の時間を左寄せ
                        children: [
                          Text(
                            todayStudyTime ~/ 60 > 0 
                              ? '${todayStudyTime ~/ 60}時間${todayStudyTime % 60}分'
                              : '${todayStudyTime % 60}分',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('今日', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(width: 40),  // 固定幅のスペースを追加
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,  // 差分を左寄せ
                        children: [
                          Row(
                            children: [
                              Text(
                                (todayStudyTime - weeklyAverageTime).abs() ~/ 60 > 0
                                  ? '${(todayStudyTime - weeklyAverageTime).abs() ~/ 60}時間'
                                    '${(todayStudyTime - weeklyAverageTime).abs() % 60}分'
                                  : '${(todayStudyTime - weeklyAverageTime).abs() % 60}分',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: todayStudyTime == weeklyAverageTime 
                                    ? Colors.black
                                    : todayStudyTime > weeklyAverageTime 
                                      ? Colors.green 
                                      : Colors.red,
                                ),
                              ),
                              Icon(
                                todayStudyTime == weeklyAverageTime
                                  ? Icons.arrow_forward
                                  : todayStudyTime > weeklyAverageTime 
                                    ? Icons.arrow_upward 
                                    : Icons.arrow_downward,
                                color: todayStudyTime == weeklyAverageTime
                                  ? Colors.black
                                  : todayStudyTime > weeklyAverageTime 
                                    ? Colors.green 
                                    : Colors.red,
                              ),
                            ],
                          ),
                          const Text('差分', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                '最近の勉強記録',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (studyRecords.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      '勉強記録がありません',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              else
                Column(  // ListView.builderをColumnに変更
                  children: [
                    for (var i = 0; i < studyRecords.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Card(
                          child: ListTile(
                            title: Text(
                              studyRecords[i].subject,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('yyyy年MM月dd日 HH:mm').format(studyRecords[i].date),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                if (studyRecords[i].description.isNotEmpty)
                                  Text(studyRecords[i].description),
                              ],
                            ),
                            trailing: Text(
                              studyRecords[i].studyTime ~/ 60 > 0
                                ? '${studyRecords[i].studyTime ~/ 60}時間'
                                  '${studyRecords[i].studyTime % 60}分'
                                : '${studyRecords[i].studyTime % 60}分',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}