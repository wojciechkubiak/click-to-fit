import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:star_metter/models/date_parser.dart';
import 'package:star_metter/models/weight.dart';

import '../config/config_service.dart';
import './storage.dart';

abstract class DataWeightService extends ConfigService {
  Future<Weight?> getTodayWeight(
      {required double initialWeight, required int id});
  Future<Weight?> getPreviousWeight({required int id});
  Future<List<Weight>?> getWeights({required int id});
  Future<Weight?> getLastWeight({required int id});
  Future<bool> updateWeight({
    required int recordId,
    required double weight,
  });
}

class WeightService extends DataWeightService {
  @override
  Future<Weight?> getTodayWeight({
    required double initialWeight,
    required int id,
  }) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();

      DateTime now = DateTime.now();
      DateParser date = DateParser(date: now);
      String parsedDate = date.getDateWithoutTime();

      List<Map<String, dynamic>> weightsList = [];

      weightsList = await db.rawQuery(
          "SELECT * FROM weights WHERE userId = $id AND date = '$parsedDate'");

      print('PARSED DATE $parsedDate');
      if (weightsList.isEmpty) {
        Weight? previous = await getLastWeight(id: id);

        Weight _emptyWeight = Weight(
          date: parsedDate,
          userId: id,
          weight: previous is Weight ? previous.weight : initialWeight,
        );

        Weight _resultWeight = await db
            .insert(
          'weights',
          _emptyWeight.toJson(),
        )
            .then(
          (value) {
            print('INSERTED ${_emptyWeight.toJson()}');
            int pk = value;

            print('PK $pk');
            return Weight(
              id: pk,
              date: _emptyWeight.date,
              userId: _emptyWeight.userId,
              weight: _emptyWeight.weight,
            );
          }, //TODO pk?
        );

        return _resultWeight;
      } else {
        print('TODAY WEIGHT ${weightsList.last}');
        Weight weight = Weight.fromJson(weightsList.last);
        return weight;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<Weight?> getPreviousWeight({required int id}) async {
    StorageService storageService = StorageService();

    try {
      List<Map<String, dynamic>> weightList = [];

      final db = await storageService.getDatabase();
      weightList = await db.rawQuery(
          "SELECT * FROM weights WHERE userId = $id ORDER BY pk DESC LIMIT 2");

      if (weightList.length > 1) {
        print('PREVIOUS WEIGHT ${weightList.last}');
        Weight weight = Weight.fromJson(weightList.last);
        return weight;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<Weight?> getLastWeight({required int id}) async {
    StorageService storageService = StorageService();

    try {
      List<Map<String, dynamic>> weightList = [];

      final db = await storageService.getDatabase();
      weightList = await db.rawQuery(
          "SELECT * FROM weights WHERE userId = $id ORDER BY pk DESC LIMIT 1");

      if (weightList.isNotEmpty) {
        Weight weight = Weight.fromJson(weightList.last);
        return weight;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<Weight>?> getWeights({required int id}) async {
    StorageService storageService = StorageService();

    try {
      List<Map<String, dynamic>> weightList = [];
      List<Weight> weights = [];

      final db = await storageService.getDatabase();
      weightList = await db.query(
        'weights',
        where: 'userId = $id',
      );

      print('ALL WEIGHTS $weightList');

      for (var element in weightList) {
        weights.add(Weight.fromJson(element));
      }

      return weights;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> updateWeight({
    required int recordId,
    required double weight,
  }) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();

      int count = await db.rawUpdate(
        'UPDATE weights SET weight = ? WHERE pk = ?',
        [weight, recordId],
      );

      print('UPDATED WEIGHTS: id $recordId count $count');
      return count > 0;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
