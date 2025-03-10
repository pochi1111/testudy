import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testudy/configs/appTheme.dart';
import 'package:testudy/services/examSchedule.dart';

class ExamEdit extends StatefulWidget {
  final Exam exam;

  const ExamEdit({super.key, required this.exam});

  @override
  _ExamEditState createState() => _ExamEditState();
}

class _ExamEditState extends State<ExamEdit> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime examDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.exam.title);
    descriptionController = TextEditingController(text: widget.exam.description);
    examDate = widget.exam.dateTime;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: examDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && mounted) {
      setState(() {
        examDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  Future<void> _updateExam() async {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('テスト名を入力してください'),
          duration: Duration(milliseconds: 1500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
          ),
        ),
      );
      return;
    }

    try {
      final updatedExam = Exam(
        id: widget.exam.id,
        title: titleController.text,
        description: descriptionController.text,
        dateTime: examDate,
      );

      await ExamAPI().updateExam(updatedExam);
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('更新しました'),
            duration: Duration(milliseconds: 1500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('更新に失敗しました'),
          duration: Duration(milliseconds: 1500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
          ),
        ),
      );
    }
  }

  void _checkDeleteExam() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('テスト名を入力してください'),
          duration: Duration(milliseconds: 1500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
          ),
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('削除の確認'),
          content: const Text('本当に削除しますか？'),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('削除'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteExam();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteExam() async {
    try {
      await ExamAPI().deleteExam(widget.exam.id);
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('削除しました'),
            duration: Duration(milliseconds: 1500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('削除に失敗しました'),
          duration: Duration(milliseconds: 1500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
          ),
        ),
      );
    }
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
                "テストの編集",
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
                          onPressed: _selectDate,
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size.zero),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                          ),
                          child: Container(
                            width: 220,
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
                  onPressed: _updateExam,
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
                          Icons.save,
                          size: 28,
                          color: appTheme.colorScheme.onPrimary,
                        ),
                        Text(
                          " 更新 ",
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
        backgroundColor: const Color.fromARGB(255, 237, 91, 91),
        onPressed: _checkDeleteExam,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
    );
  }
}