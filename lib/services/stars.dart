import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/models.dart';
import '../../services/services.dart';
import '../config/config_service.dart';
import './storage.dart';

abstract class DataStarsService extends ConfigService {
  Future<List<Star>> getStars({required int id});
  Future<Star?> getTodayStars({
    required int id,
    required int progressLimit,
  });
  Future<bool> updateStars({
    required int recordId,
    required int stars,
  });
}

class StarsService extends DataStarsService {
  @override
  Future<List<Star>> getStars({required int id}) async {
    StorageService storageService = StorageService();

    final db = await storageService.getDatabase();

    List<Star> stars = [];

    try {
      List<Map<String, dynamic>> starsList = [];
      starsList = await db
          .rawQuery("SELECT * FROM stars WHERE userId = $id ORDER BY pk ASC");

      print('STARSLIST $starsList');
      if (starsList.isNotEmpty) {
        for (var star in starsList) {
          stars.add(Star.fromJson(star));
        }
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
}
