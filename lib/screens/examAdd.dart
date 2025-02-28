import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testudy/Configs/appTheme.dart';
import 'package:testudy/services/examSchedule.dart';

class ExamAdd extends StatefulWidget {
  final DateTime initialDate;  // 初期日付を追加

  const ExamAdd({
    Key? key,
    required this.initialDate,
  }) : super(key: key);

  @override
  State<ExamAdd> createState() => _ExamAddState();
}

class _ExamAddState extends State<ExamAdd> {
  late DateTime examDate;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    examDate = widget.initialDate;  // 初期値を渡された日付に設定
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
                "テストを追加",
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
                            _selectDateTime();
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size.zero),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                          ),
                          child: Container(
                            width: 220, // 180から220に変更
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: appTheme.colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                const Icon(Icons.calendar_today, size: 25),
                                const SizedBox(width: 15),
                                Text(
                                  DateFormat("yyyy年MM月dd日").format(examDate),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          iconSize: 30,
                          onPressed: () {
                            setState(() {
                              examDate = DateTime.now();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.title, size: 25),
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
                          hintStyle: TextStyle(
                            color: appTheme.colorScheme.primary.withOpacity(0.5),
                          ),
                          hintText: "テスト名",
                        ),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("メモ", style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 15),
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
                  onPressed: _addExam,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: appTheme.colorScheme.primary,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
    );
  }

  Future<void> _selectDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: examDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        examDate = DateTime(date.year, date.month, date.day);
      });
    }
  }

  void _addExam() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("テスト名を入力してください"),
          duration: Duration(milliseconds: 1500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
          ),
        ),
      );
      return;
    }

    ExamAPI().addExam(
      Exam(
        title: titleController.text,
        description: descriptionController.text,
        dateTime: examDate,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("テストを追加しました"),
        duration: Duration(milliseconds: 1500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
        ),
      ),
    );
    
    Navigator.of(context).pop(true);
  }
}