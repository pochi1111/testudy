import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class Exam {
  final int id;
  final String title;
  final String description;
  final DateTime dateTime;

  Exam({
    required this.title, 
    required this.dateTime, 
    this.description = '', 
    this.id = 0
  });
}

String formatDateTime(DateTime dateTime) {
  dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
}

DateTime parseDateTime(String dateTime) {
  DateTime parsedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
  parsedDateTime = DateTime(parsedDateTime.year, parsedDateTime.month, parsedDateTime.day, parsedDateTime.hour, parsedDateTime.minute, parsedDateTime.second);
  return parsedDateTime;
}

class ExamAPI {
  late Database _database;
  Future<void> _initDatabase() async {
    _database = await openDatabase('exam.db', version: 2,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE exam(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          dateTime TEXT
        )
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('ALTER TABLE exam ADD COLUMN description TEXT DEFAULT ""');
      }
    });
  }

  Future<void> addExam(Exam exam) async {
    await _initDatabase();
    try {
      await _database.insert('exam', {
        'title': exam.title,
        'description': exam.description,
        'dateTime': formatDateTime(exam.dateTime),
      });
    } catch (e) {
      print('データベースエラーが発生しました: $e');
      throw Exception('試験の追加に失敗しました');
    }
  }

  Future<void> deleteExam(int id) async {
    await _initDatabase();
    try {
      await _database.delete('exam', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('データベースエラーが発生しました: $e');
      throw Exception('試験の削除に失敗しました');
    }
  }

  Future<void> updateExam(Exam exam) async {
    await _initDatabase();
    try {
      await _database.update('exam', {
        'title': exam.title,
        'description': exam.description,
        'dateTime': formatDateTime(exam.dateTime),
      }, where: 'id = ?', whereArgs: [exam.id]);
    } catch (e) {
      print('データベースエラーが発生しました: $e');
      throw Exception('試験の更新に失敗しました');
    }
  }

  Future<List<Exam>> getallExams() async {
    await _initDatabase();
    late List<Map<String, dynamic>> exams;
    exams = await _database.query('exam');
    return exams.map((exam) {
      return Exam(
        id: exam['id'],
        title: exam['title'],
        description: exam['description'] ?? '',
        dateTime: parseDateTime(exam['dateTime']),
      );
    }).toList();
  }

  Future<List<Exam>> getExams(DateTime startAt, DateTime endAt) async {
    await _initDatabase();
    late List<Map<String, dynamic>> exams;
    exams = await _database.query('exam', 
        where: 'dateTime BETWEEN ? AND ?',
        whereArgs: [formatDateTime(startAt), formatDateTime(endAt)]);
    return exams.map((exam) {
      return Exam(
        id: exam['id'],
        title: exam['title'],
        description: exam['description'] ?? '',
        dateTime: parseDateTime(exam['dateTime']),
      );
    }).toList();
  }
}
