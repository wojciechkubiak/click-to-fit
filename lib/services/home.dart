import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sql.dart';
import 'package:star_metter/models/date_parser.dart';
import 'package:star_metter/models/progress.dart';
import 'package:star_metter/models/star.dart';
import 'package:star_metter/models/weight.dart';

import '../config/config_service.dart';
import '../models/user.dart';
import './storage.dart';

abstract class DataHomeService extends ConfigService {
  Future<int?> insertUser(User user);
  Future<User?> getUser(int? id);
  Future<Progress?> getProgress({
    required User? user,
    required List<Star>? starProgress,
    required Weight? weight,
    required Weight? prevWeight,
    required List<Weight>? weightProgress,
  });
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
  Future<Progress?> getProgress({
    required User? user,
    required List<Star>? starProgress,
    required Weight? weight,
    required Weight? prevWeight,
    required List<Weight>? weightProgress,
  }) async {
    try {
      DateParser dateParsed = DateParser(date: DateTime.now());

      //TODO temp
      Star star = Star(
        userId: user!.id!,
        progressLimit: user.stars,
        date: dateParsed.getDateWithoutTime(),
        stars: 0,
      );
      List<Star> stars = [star];

      Progress progress = Progress(
        date: dateParsed.getDateWithoutTime(),
        stars: star.stars,
        progressLimit: star.progressLimit,
        currentWeight: weight!.weight,
        starProgress: stars,
        weight: weight,
        prevWeight: prevWeight,
        weightProgress: weightProgress!,
      );

      return progress;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      return null;
    }
  }
}
