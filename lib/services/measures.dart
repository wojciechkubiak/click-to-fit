import 'dart:async';

import 'package:star_metter/models/measure.dart';
import 'package:star_metter/services/services.dart';

import '../models/user.dart';

abstract class DataMeasuresService {
  Future<List<Measure>> getAllMeasures({required int userId});
  Future<Measure?> getMeasure({required int id});
  Future<Measure?> getMeasureByWeightId({required int weightId});
  Future<Measure?> addMeasure({required Measure measure});
  Future<bool> updateMeasure({required Measure measure});
  Future<bool> removeMeasure({required int measureId});
}

class MeasuresService extends DataMeasuresService {
  @override
  Future<List<Measure>> getAllMeasures({required int userId}) async {
    StorageService storageService = StorageService();
    try {
      final db = await storageService.getDatabase();

      List<Map<String, dynamic>> measuresList = [];

      measuresList =
          await db.rawQuery("SELECT * FROM measures WHERE userId = $userId");

      List<Measure> result = [];

      if (measuresList.isNotEmpty) {
        result =
            List.from(measuresList.map((value) => Measure.fromJson(value)));
      }

      result.sort((a, b) {
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

      return result;
    } catch (e) {
      print(e);

      return [];
    }
  }

  @override
  Future<Measure?> getMeasure({required int id}) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();

      List<Map<String, dynamic>> measuresList = [];

      measuresList = await db.rawQuery("SELECT * FROM measures WHERE pk = $id");

      if (measuresList.isNotEmpty) {
        Measure measure = Measure.fromJson(measuresList.last);

        return measure;
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<Measure?> getMeasureByWeightId({required int weightId}) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();

      List<Map<String, dynamic>> measuresList = [];

      measuresList = await db
          .rawQuery("SELECT * FROM measures WHERE weightId = $weightId");

      if (measuresList.isNotEmpty) {
        Measure measure = Measure.fromJson(measuresList.last);

        return measure;
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<Measure?> addMeasure({required Measure measure}) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();

      Measure _resultMeasure = await db
          .insert(
        'measures',
        measure.toJson(),
      )
          .then(
        (value) {
          print('INSERTED ${measure.toJson()}');
          int pk = value;

          measure.id = pk;
          return measure;
        }, //TODO pk?
      );

      return _resultMeasure;
    } catch (e) {
      print(e);

      return null;
    }
  }

  @override
  Future<bool> updateMeasure({required Measure measure}) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();

      int count = await db.rawUpdate(
        '''UPDATE measures SET neck = ?,
        abdomen = ?,
        chest = ?, 
        hips = ?, 
        bicep = ?, 
        thigh = ?, 
        waist = ?, 
        calf = ?
        WHERE pk = ?''',
        [
          measure.neck,
          measure.abdomen,
          measure.chest,
          measure.hips,
          measure.bicep,
          measure.thigh,
          measure.waist,
          measure.calf,
          measure.id,
        ],
      );

      print('UPDATED MEASURES: id ${measure.id} count $count');
      return count > 0;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> removeMeasure({required int measureId}) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();

      int count =
          await db.rawDelete('DELETE FROM measures WHERE pk = ?', [measureId]);

      return count > 0;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
