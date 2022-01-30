import 'dart:async';

import '../models/models.dart';
import './storage.dart';

abstract class DataWeightService {
  Future<Weight?> getTodayWeight({
    required double initialWeight,
    required int id,
  });
  Future<Weight?> getPreviousWeight({required int id});
  Future<List<Weight>?> getWeights({required int id});
  Future<Weight?> getLastWeight({required int id});
  Future<bool> updateWeight({
    required int recordId,
    required double weight,
  });
  Future<Weight?> insertNewRecord({
    required int userId,
    required double weight,
    int? id,
  });
  Future<int?>? getFirstWeightID({required int id});
  Future<bool> isWeightCreated({required int id});
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
      if (weightsList.isNotEmpty) {
        print('TODAY WEIGHT ${weightsList.last}');
        Weight weight = Weight.fromJson(weightsList.last);
        return weight;
      }

      return null;
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

      DateTime now = DateTime.now();
      DateParser date = DateParser(date: now);
      String parsedDate = date.getDateWithoutTime();

      final db = await storageService.getDatabase();

      weightList = await db.rawQuery(
          "SELECT * FROM weights WHERE userId = $id AND date != '$parsedDate' ORDER BY pk DESC LIMIT 1");

      if (weightList.isNotEmpty) {
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

  @override
  Future<Weight?> insertNewRecord({
    required int userId,
    required double weight,
    int? id,
  }) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();

      DateTime now = DateTime.now();
      DateParser date = DateParser(date: now);
      String parsedDate = date.getDateWithoutTime();

      Weight _emptyWeight = Weight(
        date: parsedDate,
        userId: userId,
        weight: weight,
        id: id,
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
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<int?>? getFirstWeightID({required int id}) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();
      List<Map<String, dynamic>> weightList = await db.rawQuery(
          "SELECT * FROM weights WHERE userId = $id ORDER BY pk ASC LIMIT 1");

      List<Weight> tempWeights = [];

      for (var element in weightList) {
        tempWeights.add(Weight.fromJson(element));
      }

      if (tempWeights.isNotEmpty) {
        return tempWeights.first.id;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> isWeightCreated({required int id}) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();
      List<Map<String, dynamic>> weightList =
          await db.rawQuery("SELECT * FROM weights WHERE pk = $id");

      return weightList.isNotEmpty;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
