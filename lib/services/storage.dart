import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../config/config_service.dart';

abstract class DataStorageService extends ConfigService {
  Future<Database> getDatabase();
}

class StorageService extends DataStorageService {
  @override
  Future<Database> getDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'star_metter.db'),
      onCreate: (db, version) {
        return db.execute(
            '''CREATE TABLE users (pk INTEGER PRIMARY KEY, name TEXT, age INTEGER, 
          height INTEGER, initWeight INTEGER, targetWeight INTEGER, stars INTEGER, 
          gender STRING, activityLevel STRING, storageType STRING)''');
      },
      version: 1,
    );

    return database;
  }
}
