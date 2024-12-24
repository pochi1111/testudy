import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';
import 'package:testudy/Configs/appTheme.dart';

class StudyTimeAdder extends StatefulWidget {
  const StudyTimeAdder({Key? key}) : super(key: key);

  @override
  _StudyTimeAdderState createState() => _StudyTimeAdderState();
}

class _StudyTimeAdderState extends State<StudyTimeAdder> {
  int nowHour = 0;
  int nowMinute = 0;
  int nowSecond = 0;
  late DateTime nowDate;
  String nowTime = "";
  late DateTime today;

  @override
  void initState() {
    super.initState();
    nowDate = DateTime.now();
    nowTime = DateFormat("yyyy-MM-dd").format(nowDate);
    today = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  changeDate();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  backgroundColor: appTheme.colorScheme.onPrimary,
                  //overlayColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(0),
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: appTheme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    nowTime,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                )),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      "Hour",
                      style: TextStyle(fontSize: 20),
                    ),
                    NumberPicker(
                      infiniteLoop: true,
                      value: nowHour,
                      minValue: 0,
                      maxValue: 23,
                      onChanged: (value) => setState(() => nowHour = value),
                      textStyle: const TextStyle(fontSize: 20),
                      selectedTextStyle: const TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      )
                    ),
                  ],
                ),
                const Column(
                  children: [
                    Text(
                      "",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      ":",
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      "Min",
                      style: TextStyle(fontSize: 20),
                    ),
                    NumberPicker(
                      infiniteLoop: true,
                      value: nowMinute,
                      minValue: 0,
                      maxValue: 59,
                      onChanged: (value) => setState(() => nowMinute = value),
                      textStyle: const TextStyle(fontSize: 20),
                      selectedTextStyle: const TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      )
                    ),
                  ],
                ),
                const Column(
                  children: [
                    Text(
                      "",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      ":",
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      "Sec",
                      style: TextStyle(fontSize: 20),
                    ),
                    NumberPicker(
                      infiniteLoop: true,
                      value: nowSecond,
                      minValue: 0,
                      maxValue: 59,
                      onChanged: (value) => setState(() => nowSecond = value),
                      textStyle: const TextStyle(fontSize: 20),
                      selectedTextStyle: const TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      )
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(
              flex: 8,
            ),
          ],
        ),
      ),
    );
  }

  void changeDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: nowDate,
      firstDate: DateTime.now().subtract(const Duration(days: 31)),
      lastDate: today,
    );

    if (picked != null && picked != nowDate) {
      setState(() {
        nowDate = picked;
        nowTime = DateFormat("yyyy-MM-dd").format(nowDate);
      });
    }
  }
}
