import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DataStorageService {
  Future<Database> getDatabase();
}

class StorageService extends DataStorageService {
  @override
  Future<Database> getDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'star_metter.db'),
      onCreate: (db, version) async {
        await db.execute(
            '''CREATE TABLE users (pk INTEGER PRIMARY KEY, name TEXT, age INTEGER, 
          height STRING, initWeight REAL, targetWeight REAL, unit TEXT, stars INTEGER, 
          gender STRING, activityLevel INTEGER, initDate TEXT)''');
        await db.execute(
            '''CREATE TABLE weights (pk INTEGER PRIMARY KEY, date TEXT, userId INTEGER,
            weight REAL, unit TEXT)''');
        await db
            .execute('''CREATE TABLE stars (pk INTEGER PRIMARY KEY, date TEXT, 
            userId INTEGER, stars INT, progressLimit INT)''');
      },
      version: 1,
    );

    return database;
  }
}
