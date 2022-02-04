import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';

import '../models/models.dart';
import './storage.dart';

abstract class DataWeightService {
  Future<Weight?> getTodayWeight({
    required double initialWeight,
    required int id,
  });
  Future<Weight?> getPreviousWeight({required int id});
  Future<List<Weight>?> getScopeWeights({
    required int id,
    DateScope scope = DateScope.week,
    int offset = 0,
  });
  Future<List<Weight>?> getAllWeights({required int id});
  Future<Weight?> getLastWeight({required int id});
  Future<bool> updateWeight({
    required int recordId,
    required double weight,
  });
  Future<bool> removeWeight({
    required int recordId,
  });
  Future<Weight?> insertNewRecord({
    required int userId,
    required double weight,
    String? date,
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
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
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
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
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
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<List<Weight>?> getScopeWeights({
    required int id,
    DateScope scope = DateScope.week,
    int offset = 0,
  }) async {
    StorageService storageService = StorageService();

    try {
      List<Map<String, dynamic>> weightList = [];
      List<Weight> weights = [];

      final db = await storageService.getDatabase();
      weightList = await db.query(
        'weights',
        where: 'userId = $id',
      );

      List<String> dates = [];
      DateTime now = DateTime.now();
      List<Weight> result = [];

      if (scope == DateScope.week) {
        DateTime monday = now.add(Duration(days: -(now.weekday - 1)));

        for (int i = 0; i <= 6; i++) {
          dates.add(
            DateParser(date: monday.add(Duration(days: i - (7 * offset))))
                .getDateWithoutTime(),
          );
        }
      }
      print('ALL WEIGHTS $weightList');

      if (weightList.isNotEmpty) {
        List<Weight> weightsFound = [];

        for (var element in weightList) {
          weightsFound.add(Weight.fromJson(element));
        }

        for (var date in dates) {
          Weight? _weight = weightsFound.firstWhere(
            (element) => element.date == date,
            orElse: () {
              return Weight(
                date: date,
                userId: weightsFound.last.userId,
                weight: 0,
              );
            },
          );
          result.add(_weight);
        }
      }

      return result;
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<List<Weight>?> getAllWeights({required int id}) async {
    try {
      StorageService storageService = StorageService();

      List<Map<String, dynamic>> weightList = [];
      List<Weight> weights = [];

      final db = await storageService.getDatabase();
      weightList = await db.query(
        'weights',
        where: 'userId = $id',
      );

      if (weightList.isNotEmpty) {
        List<Weight> weightsFound = [];

        for (var element in weightList) {
          weightsFound.add(Weight.fromJson(element));
        }

        weightsFound.sort((a, b) {
          List<String> v1 = a.date.split('-');
          List<String> v2 = b.date.split('-');

          DateTime date1 = DateTime.utc(
            int.parse(v1[2]),
            int.parse(v1[1]),
            int.parse(v1[0]),
          );

          DateTime date2 = DateTime.utc(
            int.parse(v2[2]),
            int.parse(v2[1]),
            int.parse(v2[0]),
          );

          if (v1.length == 3 && v2.length == 3) {
            return date1.isBefore(date2) ? 1 : 0;
          } else {
            return -1;
          }
        });

        weights = weightsFound;
      }

      return weights;
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
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
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  @override
  Future<bool> removeWeight({
    required int recordId,
  }) async {
    StorageService storageService = StorageService();
    try {
      final db = await storageService.getDatabase();

      int count =
          await db.rawDelete('DELETE FROM weights WHERE pk = ?', [recordId]);

      return count > 0;
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  @override
  Future<Weight?> insertNewRecord({
    required int userId,
    required double weight,
    String? date,
    int? id,
  }) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();

      DateTime now = DateTime.now();
      DateParser nDate = DateParser(date: now);
      String parsedDate = nDate.getDateWithoutTime();

      Weight _emptyWeight = Weight(
        date: date is String ? date : parsedDate,
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
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
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
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
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
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
