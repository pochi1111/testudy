import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:testudy/configs/appTheme.dart';
import 'package:testudy/services/examSchedule.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({Key? key}) : super(key: key);

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
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
        body: Column(
          children: [
            //ここに次の最短のテストまで何日か、又その詳細を表示する
            TableCalendar(
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
              daysOfWeekHeight: MediaQuery.of(context).size.height * 0.02,
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
              },
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              locale: 'ja_JP',
            )
            //ここに選択された日付のテストの詳細を表示する
          ],
        ));
  }

  void _updateExams(DateTime startAt) async {
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
}
