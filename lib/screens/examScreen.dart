import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:testudy/configs/appTheme.dart';
import 'package:testudy/screens/examAdd.dart';
import 'package:testudy/services/examSchedule.dart';
import 'package:testudy/screens/examEdit.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({Key? key}) : super(key: key);

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Exam> _selectedExams = [];
  List<Exam> _exams = [];
  LinkedHashMap<DateTime, List<Exam>> _examsMap = LinkedHashMap();

  @override
  void initState() {
    super.initState();
    _updateExams(DateTime(_focusedDay.year, _focusedDay.month, 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: TableCalendar(
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) {
                        return Container();
                      }
                      return Positioned(
                        top: 8,
                        right: 10,
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 231, 150, 150),
                            shape: BoxShape.circle,
                          ),
                          width: 10,
                          height: 10,
                        ),
                      );
                    },
                  ),
                  onPageChanged: (focusedDay) {
                    _updateExams(focusedDay);
                  },
                  eventLoader: (day) {
                    day = DateTime(day.year, day.month, day.day);
                    return _examsMap[day] ?? [];
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: appTheme.colorScheme.primary,
                      fontSize: 20,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: appTheme.colorScheme.primary,
                    ),
                    weekendStyle: TextStyle(
                      color: appTheme.colorScheme.primary,
                    ),
                  ),
                  daysOfWeekHeight: MediaQuery.of(context).size.height * 0.03,
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: appTheme.colorScheme.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: appTheme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(color: Colors.white),
                    outsideDaysVisible: false,
                    weekendTextStyle:
                        TextStyle(color: appTheme.colorScheme.primary),
                  ),
                  rowHeight: MediaQuery.of(context).size.height * 0.05,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2040, 1, 1),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _updateSelectedExams();
                  },
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  locale: 'ja_JP',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${_selectedDay.month}月${_selectedDay.day}日',
                  style: const TextStyle(
                    fontSize: 17,
                    height: 2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListView.builder(
                  itemCount: _selectedExams.length,
                  //ここのshrinkwrapは検討の余地あり
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      title: Text(_selectedExams[index].title),
                      subtitle: Text(_selectedExams[index].description),
                      onTap: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ExamEdit(exam: _selectedExams[index]),
                          ),
                        );
                        if (result == true) {
                          await _updateExams(_focusedDay);
                          _updateSelectedExams();
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExamAdd(initialDate: _selectedDay),  // 選択された日付を渡す
              ),
            );
            if (result == true) {
              await _updateExams(_focusedDay);
              _updateSelectedExams();
              setState(() {});
            }
          },
          child: Icon(Icons.add),
        ));
  }

  Future<void> _updateExams(DateTime startAt) async {
    final exams =
        await ExamAPI().getExams(startAt, startAt.add(Duration(days: 32)));
    _exams = exams;
    _examsMap = LinkedHashMap();
    for (final exam in _exams) {
      final date =
          DateTime(exam.dateTime.year, exam.dateTime.month, exam.dateTime.day);
      if (_examsMap[date] == null) {
        _examsMap[date] = [];
      }
      _examsMap[date]!.add(exam);
    }
  }

  void _updateSelectedExams() {
    _selectedExams = _examsMap[DateTime(
            _selectedDay.year, _selectedDay.month, _selectedDay.day)] ??
        [];
    print("selectedExams: $_selectedExams");
    setState(() {});
  }
}
