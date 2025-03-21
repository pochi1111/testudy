import 'package:flutter/material.dart';
import 'package:testudy/screens/studyTimer.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';
import 'package:testudy/Configs/appTheme.dart';
import 'package:testudy/services/studyTime.dart';

class Time {
  int year;
  int month;
  int day;
  int hour;
  int minute;

  Time(
      {required this.year,
      required this.month,
      required this.day,
      required this.hour,
      required this.minute});
}

class StudyTimeAdd extends StatefulWidget {
  const StudyTimeAdd({super.key});

  @override
  _StudyTimeAddState createState() => _StudyTimeAddState();
}

class _StudyTimeAddState extends State<StudyTimeAdd> {
  int studyTimeHour = 0;
  int studyTimeMinute = 0;
  Time timeAt = Time(year: 0, month: 0, day: 0, hour: 0, minute: 0);
  late DateTime today;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    timeAt = Time(
        year: today.year,
        month: today.month,
        day: today.day,
        hour: today.hour,
        minute: today.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "勉強時間を追加",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: appTheme.colorScheme.primary,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 20.0, left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              changeDate();
                            },
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all(Size.zero),
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                            ),
                            child: Container(
                              width: 180,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: appTheme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, top: 0, bottom: 3),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 25,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    DateFormat("yyyy-MM-dd").format(DateTime(
                                        timeAt.year,
                                        timeAt.month,
                                        timeAt.day,
                                        timeAt.hour,
                                        timeAt.minute)),
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          iconSize: 30,
                          onPressed: () {
                            setState(() {
                              today = DateTime.now();
                              timeAt.year = today.year;
                              timeAt.month = today.month;
                              timeAt.day = today.day;
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        TextButton(
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all(Size.zero),
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                            ),
                            onPressed: () {
                              changeTime();
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, top: 0, bottom: 3),
                              width: 180,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: appTheme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    Icons.access_time,
                                    size: 25,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    DateFormat("H:mm").format(DateTime(
                                        timeAt.year,
                                        timeAt.month,
                                        timeAt.day,
                                        timeAt.hour,
                                        timeAt.minute)),
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          iconSize: 30,
                          onPressed: () {
                            setState(() {
                              today = DateTime.now();
                              timeAt.hour = today.hour;
                              timeAt.minute = today.minute;
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextButton(
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all(Size.zero),
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                        ),
                        onPressed: () {
                          changeStudyTime();
                        },
                        child: Container(
                          width: 180,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: appTheme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 0, bottom: 3),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.timer,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                "$studyTimeHour時間 $studyTimeMinute分",
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: subjectController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.book,
                            size: 25,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: appTheme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: appTheme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                            hintText: "教科",
                            hintStyle: const TextStyle(color: Colors.grey),
                        ),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("説明", style: TextStyle(fontSize: 20)),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: descriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: appTheme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: appTheme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    addStudyTime();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: appTheme.colorScheme.primary,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 28,
                          color: appTheme.colorScheme.onPrimary,
                        ),
                        Text(
                          " 追加 ",
                          style: TextStyle(
                            fontSize: 28,
                            color: appTheme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int studyTimeInMinutes = studyTimeHour * 60 + studyTimeMinute;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StudyTimer(initialMinutes: studyTimeInMinutes),
            ),
          ).then((result) {
            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("勉強時間を適用しました"),
                  duration: Duration(milliseconds: 1500),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                  ),
                ),
              );
              setState(() {
                studyTimeHour = result ~/ 60;
                studyTimeMinute = result % 60;
              });
            }
          });
        },
        child: const Icon(Icons.timer),
      ),
    );
  }

  void changeDate() async {
    final DateTime nowDate = DateTime(
        timeAt.year, timeAt.month, timeAt.day, timeAt.hour, timeAt.minute);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: nowDate,
      firstDate: DateTime.now().subtract(const Duration(days: 31)),
      lastDate: today,
    );

    if (picked != null && picked != nowDate) {
      setState(() {
        timeAt.year = picked.year;
        timeAt.month = picked.month;
        timeAt.day = picked.day;
      });
    }
  }

  void changeTime() async {
    final DateTime nowTime = DateTime(
        timeAt.year, timeAt.month, timeAt.day, timeAt.hour, timeAt.minute);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.dialOnly,
      initialTime: TimeOfDay(hour: nowTime.hour, minute: nowTime.minute),
      builder: (BuildContext ddcontext, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        timeAt.hour = picked.hour;
        timeAt.minute = picked.minute;
      });
    }
  }

  void changeStudyTime() {
    final beforeStudyTimeHour = studyTimeHour;
    final beforeStudyTimeMinute = studyTimeMinute;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text("勉強時間を選択"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NumberPicker(
                    value: studyTimeHour,
                    selectedTextStyle: const TextStyle(fontSize: 30),
                    minValue: 0,
                    maxValue: 23,
                    step: 1,
                    itemWidth: 50,
                    itemHeight: 50,
                    axis: Axis.vertical,
                    onChanged: (value) => setState(() => studyTimeHour = value),
                  ),
                  const Text(
                    "時間",
                    style: TextStyle(fontSize: 20),
                  ),
                  NumberPicker(
                    value: studyTimeMinute,
                    selectedTextStyle: const TextStyle(fontSize: 30),
                    minValue: 0,
                    maxValue: 59,
                    step: 1,
                    itemWidth: 50,
                    itemHeight: 50,
                    axis: Axis.vertical,
                    onChanged: (value) =>
                        setState(() => studyTimeMinute = value),
                  ),
                  const Text(
                    "分",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  studyTimeHour = beforeStudyTimeHour;
                  studyTimeMinute = beforeStudyTimeMinute;
                });
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void addStudyTime() {
    if (studyTimeHour == 0 && studyTimeMinute == 0) {
      const snackBar = SnackBar(
        content: Text("勉強時間を入力してください"),
        duration: Duration(milliseconds: 1500),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(5),
        )),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (subjectController.text.isEmpty) {
      const snackBar = SnackBar(
        content: Text("教科を入力してください"),
        duration: Duration(milliseconds: 1500),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(5),
        )),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    int studyTime = studyTimeHour * 60 + studyTimeMinute;
    DateTime date = DateTime(
        timeAt.year, timeAt.month, timeAt.day, timeAt.hour, timeAt.minute);
    StudyTimeAPI().addStudyTime(StudyTimeRecord(
      date: date,
      studyTime: studyTime,
      subject: subjectController.text,
      description: descriptionController.text,
    ));
    const snackBar = SnackBar(
      content: Text("勉強時間を追加しました"),
      duration: Duration(milliseconds: 1500),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(5),
      )),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.of(context).pop(true);
  }
}
