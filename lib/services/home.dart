import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sql.dart';
import 'package:star_metter/models/date_parser.dart';
import 'package:star_metter/models/progress.dart';

import '../config/config_service.dart';
import '../models/user.dart';
import './storage.dart';

abstract class DataHomeService extends ConfigService {
  Future<int?> insertUser(User user);
  Future<User?> getUser(int? id);
  Future<Progress?> getProgress(User? id);
}

class HomeService extends DataHomeService {
  @override
  Future<int?> insertUser(User user) async {
    StorageService storageService = StorageService();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final db = await storageService.getDatabase();
      print(user.toJson());
      int userId = await db
          .insert(
            'users',
            user.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          )
          .then(
            (value) => value,
          );
      prefs.setInt('userId', userId);
      return userId;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> getUser(int? id) async {
    StorageService storageService = StorageService();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final db = await storageService.getDatabase();
      List<Map<String, dynamic>> userList = [];

      id ??= prefs.getInt('userId');

      if (id != null) {
        userList = await db.query(
          'users',
          where: 'pk = $id',
        );
      } else {
        userList =
            await db.rawQuery("SELECT * FROM users ORDER BY pk DESC LIMIT 1");
        if (userList.isNotEmpty) {
          int userId = userList.last['pk'];
          prefs.setInt('userId', userId);
        }
      }

      if (userList.isNotEmpty) {
        User user = User.fromJson(userList.last);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<Progress?> getProgress(User? user) async {
    try {
      DateParser dateParsed = DateParser(date: DateTime.now());
      if (user is User) {
        Map<String, dynamic> temp = {
          "pk": user.id,
          "date": dateParsed.getDateWithoutTime(),
          "stars": 0,
          "limit": user.stars,
          "currentWeight": user.initWeight,
          "starProgress": [
            {
              "pk": 1,
              "date": dateParsed.getDateWithoutTime(),
              "userId": user.id,
              "stars": 0,
            }
          ],
          "weightProgress": [
            {
              "pk": 1,
              "date": dateParsed.getDateWithoutTime(),
              "weight": 85.4,
            },
            {
              "pk": 2,
              "date": dateParsed.getDateWithoutTime(),
              "weight": 82.1,
            },
          ]
        };
        //TODO: ADD WEIGHT ON INIT, SAME PROGRESS - INTO DB

        Progress progress = Progress.fromJson(temp);

        return progress;
      }

      return null;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      return null;
    }
  }
}
