import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/models.dart';
import '../../services/services.dart';
import '../config/config_service.dart';
import './storage.dart';

abstract class DataStarsService extends ConfigService {
  Future<List<Star>> getStars({
    required int id,
    required DateScope scope,
  });
  Future<Star?> getTodayStars({
    required int id,
    required int progressLimit,
  });
  Future<bool> updateStars({
    required int recordId,
    required int stars,
  });
  Future<bool> updateLastUserStars({
    required int userId,
    required int stars,
  });
  Future<int> insertStarsDay({
    required Star star,
  });
  Future<bool> updateStarsLimit({
    required int recordId,
    required int stars,
    required int limit,
  });
}

class StarsService extends DataStarsService {
  @override
  Future<List<Star>> getStars({
    required int id,
    required DateScope scope,
    int offset = 0,
    bool isNullStarIncluded = true,
  }) async {
    StorageService storageService = StorageService();

    final db = await storageService.getDatabase();

    List<Star> stars = [];

    try {
      List<Map<String, dynamic>> starsList = [];
      starsList = await db
          .rawQuery("SELECT * FROM stars WHERE userId = $id ORDER BY pk");

      if (scope == DateScope.week) {
        DateTime now = DateTime.now();
        DateTime monday = now.add(Duration(days: -(now.weekday - 1)));

        List<String> dates = [];

        for (int i = 0; i <= 6; i++) {
          dates.add(
              DateParser(date: monday.add(Duration(days: i - (7 * offset))))
                  .getDateWithoutTime());
        }

        List<Star> result = [];

        if (starsList.isNotEmpty) {
          List<Star> starsFound = [];

          for (var star in starsList) {
            starsFound.add(Star.fromJson(star));
          }

          for (var date in dates) {
            Star? _star = starsFound.firstWhere(
              (element) => element.date == date,
              orElse: () {
                return Star(
                  date: date,
                  userId: starsFound.last.userId,
                  stars: 0,
                  progressLimit: starsFound.last.progressLimit,
                );
              },
            );
            result.add(_star);
          }
        }

        return result;
      }
    } catch (e) {
      print(e);
    }
    return stars;
  }

  @override
  Future<Star?> getTodayStars({
    required int id,
    required int progressLimit,
  }) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();

      DateTime now = DateTime.now();
      DateParser date = DateParser(date: now);
      String parsedDate = date.getDateWithoutTime();

      List<Map<String, dynamic>> starsList = [];

      starsList = await db.rawQuery(
          "SELECT * FROM stars WHERE userId = $id AND date = '$parsedDate'");

      if (starsList.isEmpty) {
        Star _emptyStars = Star(
          date: parsedDate,
          userId: id,
          progressLimit: progressLimit,
          stars: 0,
        );

        Star _resultStar = await db
            .insert(
          'stars',
          _emptyStars.toJson(),
        )
            .then(
          (value) {
            print('INSERTED ${_emptyStars.toJson()}');
            int pk = value;

            print('PK $pk');
            return Star(
              id: pk,
              date: _emptyStars.date,
              userId: _emptyStars.userId,
              progressLimit: _emptyStars.progressLimit,
              stars: _emptyStars.stars,
            );
          }, //TODO pk?
        );

        print('TODAY STAR $_resultStar');
        return _resultStar;
      } else {
        Star star = Star.fromJson(starsList.last);
        return star;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> updateStars({
    required int recordId,
    required int stars,
  }) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();

      int count = await db.rawUpdate(
        'UPDATE stars SET stars = ? WHERE pk = ?',
        [stars, recordId],
      );

      print('UPDATED STARS: id $recordId count $count');
      return count > 0;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> updateLastUserStars({
    required int userId,
    required int stars,
  }) async {
    StorageService storageService = StorageService();

    try {
      List<Map<String, dynamic>> starsList = [];

      final db = await storageService.getDatabase();
      starsList = await db.rawQuery(
          "SELECT * FROM stars WHERE userId = $userId ORDER BY pk DESC LIMIT 1");

      if (starsList.isNotEmpty) {
        Star tempStar = Star.fromJson(starsList.last);

        int count = await db.rawUpdate(
          'UPDATE stars SET progressLimit = ? WHERE pk = ?',
          [stars, tempStar.id],
        );

        print('UPDATED STARS: id ${tempStar.id} count $count');
        return count > 0;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<int> insertStarsDay({
    required Star star,
  }) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();
      int id = await db
          .insert(
        'stars',
        star.toJson(),
      )
          .then((value) {
        return value;
      });

      return id;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  @override
  Future<bool> updateStarsLimit({
    required int recordId,
    required int stars,
    required int limit,
  }) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();

      int count = await db.rawUpdate(
        'UPDATE stars SET stars = ?, progressLimit = ? WHERE pk = ?',
        [stars, limit, recordId],
      );

      print('UPDATED STARS: id $recordId count $count');
      return count > 0;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
