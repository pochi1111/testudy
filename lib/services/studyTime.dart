import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class StudyTimeRecord {
  final int id;
  final DateTime date;
  final int studyTime;
  final String subject;
  final String description;
  StudyTimeRecord(
      {required this.date,
      required this.studyTime,
      required this.subject,
      required this.description,
      this.id = 0});
}

String formatDateTime(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
}

DateTime parseDateTime(String dateTime) {
  return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
}

class StudyTimeAPI {
  late Database _database;
  Future<void> _initDatabase() async {
    _database = await openDatabase('studyTime.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE studyTime(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
          studyTime INTEGER,
          subject TEXT,
          description TEXT
        )
      ''');
    });
  }

  Future<void> addStudyTime(StudyTimeRecord record) async {
    await _initDatabase();
    try {
      await _database.insert('studyTime', {
        'date': formatDateTime(record.date),
        'studyTime': record.studyTime,
        'subject': record.subject,
        'description': record.description,
      });
    } catch (e) {
      print('データベースエラーが発生しました: $e');
      throw Exception('勉強時間の追加に失敗しました');
    }
  }

  Future<List<StudyTimeRecord>> getStudyTimeRecords(int amount) async {
    await _initDatabase();
    late List<Map<String, dynamic>> records;
    if (amount == 0) {
      records = await _database.query('studyTime', orderBy: 'date DESC');
    } else {
      records = await _database.query('studyTime',
          orderBy: 'date DESC', limit: amount);
    }
    return records
        .map((record) => StudyTimeRecord(
              date: parseDateTime(record['date']),
              studyTime: record['studyTime'],
              subject: record['subject'],
              description: record['description'],
              id: record['id'],
            ))
        .toList();
  }

  Future<int> getTotalStudyTime() async {
    await _initDatabase();
    List<Map<String, dynamic>> records = await _database.query('studyTime');
    int totalStudyTime = 0;
    for (Map<String, dynamic> record in records) {
      totalStudyTime += record['studyTime'] as int;
    }
    return totalStudyTime;
  }

  Future<int> getTotalRecordNum() async {
    await _initDatabase();
    List<Map<String, dynamic>> records = await _database.query('studyTime');
    return records.length;
  }

  //TODO 動作未実証
  Future<int> getRangeStudyTime(DateTime start, DateTime end) async {
    await _initDatabase();
    List<Map<String, dynamic>> records = await _database.query('studyTime',
      where: 'date >= ? AND date <= ?', 
      whereArgs: [formatDateTime(start), formatDateTime(end)]);
    int totalStudyTime = 0;
    for (Map<String, dynamic> record in records) {
      totalStudyTime += record['studyTime'] as int;
    }
    return totalStudyTime;
  }

  Future<List<int>> getRangeEachStudyTime(DateTime start, DateTime end) async {
    await _initDatabase();
    List<int> studyTimes = [];
    DateTime currentDate = start;

    while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
      DateTime nextDate = currentDate.add(const Duration(days: 1));
      List<Map<String, dynamic>> records = await _database.query(
        'studyTime',
        where: 'date >= ? AND date < ?',
        whereArgs: [
          formatDateTime(currentDate),
          formatDateTime(nextDate)
        ]
      );

      int dailyTotal = 0;
      for (var record in records) {
        dailyTotal += record['studyTime'] as int;
      }
      studyTimes.add(dailyTotal);
      currentDate = nextDate;
    }

    return studyTimes;
  }

  Future<void> deleteStudyTimeRecord(int id) async {
    await _initDatabase();
    await _database.delete('studyTime', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateStudyTimeRecord(StudyTimeRecord record) async {
    await _initDatabase();
    await _database.update(
        'studyTime',
        {
          'date': formatDateTime(record.date),
          'studyTime': record.studyTime,
          'subject': record.subject,
          'description': record.description,
        },
        where: 'id = ?',
        whereArgs: [record.id]);
  }

  Future<void> close() async {
    await _database.close();
  }
}
