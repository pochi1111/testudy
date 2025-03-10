import 'package:flutter/material.dart';
import 'package:testudy/services/studyTime.dart';
import 'package:testudy/configs/appTheme.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';

class StudyTimeEdit extends StatefulWidget {
  final StudyTimeRecord record;

  const StudyTimeEdit({super.key, required this.record});

  @override
  _StudyTimeEditState createState() => _StudyTimeEditState();
}

class _StudyTimeEditState extends State<StudyTimeEdit> {
  late TextEditingController _subjectController;
  late TextEditingController _studyTimeController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  int _studyTimeHour = 0;
  int _studyTimeMinute = 0;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: widget.record.subject);
    _studyTimeController =
        TextEditingController(text: widget.record.studyTime.toString());
    _descriptionController =
        TextEditingController(text: widget.record.description);
    _selectedDate = widget.record.date;
    // 勉強時間を時間と分に分解
    _studyTimeHour = widget.record.studyTime ~/ 60;
    _studyTimeMinute = widget.record.studyTime % 60;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _studyTimeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _changeStudyTime() {
    final beforeStudyTimeHour = _studyTimeHour;
    final beforeStudyTimeMinute = _studyTimeMinute;
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
                    value: _studyTimeHour,
                    selectedTextStyle: const TextStyle(fontSize: 30),
                    minValue: 0,
                    maxValue: 23,
                    step: 1,
                    itemWidth: 50,
                    itemHeight: 50,
                    axis: Axis.vertical,
                    onChanged: (value) =>
                        setState(() => _studyTimeHour = value),
                  ),
                  const Text(
                    "時間",  // "h" から "時間" に変更
                    style: TextStyle(fontSize: 20),
                  ),
                  NumberPicker(
                    value: _studyTimeMinute,
                    selectedTextStyle: const TextStyle(fontSize: 30),
                    minValue: 0,
                    maxValue: 59,
                    step: 1,
                    itemWidth: 50,
                    itemHeight: 50,
                    axis: Axis.vertical,
                    onChanged: (value) =>
                        setState(() => _studyTimeMinute = value),
                  ),
                  const Text(
                    "分",  // "m" から "分" に変更
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
                  _studyTimeHour = beforeStudyTimeHour;
                  _studyTimeMinute = beforeStudyTimeMinute;
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

  Future<void> _updateRecord() async {
    if (_studyTimeHour == 0 && _studyTimeMinute == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("勉強時間を入力してください"),
          duration: Duration(milliseconds: 1500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(5),
            ),
          ),
        ),
      );
      return;
    }
    
    if (_subjectController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("教科を入力してください"),
          duration: Duration(milliseconds: 1500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(5),
            ),
          ),
        ),
      );
      return;
    }

    try {
      final updatedRecord = StudyTimeRecord(
        id: widget.record.id,
        date: _selectedDate,
        studyTime: _studyTimeHour * 60 + _studyTimeMinute,
        subject: _subjectController.text,
        description: _descriptionController.text,
      );

      await StudyTimeAPI().updateStudyTimeRecord(updatedRecord);
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('更新しました'),
            duration: Duration(milliseconds: 1500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(5),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('更新に失敗しました')),
      );
    }
  }

  void _checkDeleteRecord() {
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
                if (mounted) {
                  Navigator.of(context).pop();
                  _deleteRecord();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRecord() async {
    try {
      await StudyTimeAPI().deleteStudyTimeRecord(widget.record.id);
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('削除しました'),
            duration: Duration(milliseconds: 1500),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
              top: Radius.circular(5),
            )),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('削除に失敗しました'),
          backgroundColor: Color.fromARGB(255, 255, 85, 85),
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDate.hour,
          _selectedDate.minute,
        );
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _selectedDate.hour,
        minute: _selectedDate.minute,
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
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
                "勉強記録の編集",
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
                                const SizedBox(width: 10),
                                const Icon(Icons.calendar_today, size: 25),
                                const SizedBox(width: 15),
                                Text(
                                  DateFormat("yyyy-MM-dd")
                                      .format(_selectedDate),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: _selectTime,
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
                                const SizedBox(width: 10),
                                const Icon(Icons.access_time, size: 25),
                                const SizedBox(width: 15),
                                Text(
                                  DateFormat("H:mm").format(_selectedDate),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                      onPressed: _changeStudyTime,
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
                            const SizedBox(width: 10),
                            const Icon(Icons.timer, size: 25),
                            const SizedBox(width: 15),
                            Text(
                              "${_studyTimeHour}時間 ${_studyTimeMinute}分",  // "h m" から "時間 分" に変更
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _subjectController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.book, size: 25),
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
                    const SizedBox(height: 20),
                    const Text("説明", style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _descriptionController,
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
                  onPressed: _updateRecord,
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
        onPressed: () => {
          _checkDeleteRecord()
        },
        child: const Icon(
          Icons.delete,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
