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
        await db.execute('''CREATE TABLE users (
              pk INTEGER PRIMARY KEY, 
              name TEXT, 
              age INTEGER, 
              height STRING, 
              initWeight REAL, 
              targetWeight REAL, 
              unit TEXT, 
              stars REAL, 
              gender STRING, 
              activityLevel INTEGER, 
              initDate TEXT
              )''');
        await db.execute('''CREATE TABLE weights (
              pk INTEGER PRIMARY KEY, 
              date TEXT, 
              userId INTEGER,
              weight REAL, 
              unit TEXT
              )''');
        await db.execute('''CREATE TABLE stars (
              pk INTEGER PRIMARY KEY, 
              date TEXT, 
              userId INTEGER, 
              stars REAL, 
              progressLimit REAL
              )''');
        await db.execute('''CREATE TABLE measures (
              pk INTEGER PRIMARY KEY, 
              userId INTEGER,
              weightId INTEGER, 
              date TEXT, 
              neck REAL, 
              abdomen REAL, 
              chest REAL, 
              hips REAL, 
              bicep REAL, 
              thigh REAL, 
              waist REAL, 
              calf REAL
              )''');
      },
      version: 1,
    );

    return database;
  }
}
