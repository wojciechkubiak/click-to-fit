import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sql.dart';

import '../../models/models.dart';
import './storage.dart';

abstract class DataHomeService {
  Future<int?> insertUser(User user);
  Future<User?> getUser(int? id);
  Future<Progress?> getProgress({
    required User? user,
    required List<Star>? starProgress,
    required Star star,
    required Weight? weight,
    required Weight? prevWeight,
    required List<Weight>? weightProgress,
  });
  Future<List<User>> getUsers();
  Future<int> getUserId();
  Future<void> updateUserWeight(int userId, double weight);
  Future<int?> getCurrentUser();
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

      print('NEW USER ${user.toJson()} -> id: $userId');
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

      if (id is int) prefs.setInt('userId', id);

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
    required Star star,
    required Weight? weight,
    required Weight? prevWeight,
    required List<Weight>? weightProgress,
  }) async {
    try {
      DateParser dateParsed = DateParser(date: DateTime.now());

      Progress progress = Progress(
        date: dateParsed.getDateWithoutTime(),
        stars: star.stars,
        progressLimit: star.progressLimit,
        currentWeight: weight?.weight,
        star: star,
        starProgress: starProgress is List<Star> ? starProgress : [],
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

  @override
  Future<List<User>> getUsers() async {
    StorageService storageService = StorageService();

    final db = await storageService.getDatabase();
    List<Map<String, dynamic>> userList = await db.query(
      'users',
    );
    List<User> users = [];

    for (var element in userList) {
      users.add(User.fromJson(element));
    }

    return users;
  }

  @override
  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('userId');

    return id ?? 0;
  }

  @override
  Future<void> updateUserWeight(int userId, double weight) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();

      int count = await db.rawUpdate(
        'UPDATE users SET initWeight = ? WHERE pk = ?',
        [weight, userId],
      );
      print('UPDATED WEIGHTS: id $userId count $count');
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<int?> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? userId = prefs.getInt('userId');

    return userId;
  }
}
