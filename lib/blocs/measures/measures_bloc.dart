import 'package:bloc/bloc.dart';

import '../../models/models.dart';
import '../../services/services.dart';

part 'measures_event.dart';
part 'measures_state.dart';

class MeasuresBloc extends Bloc<MeasuresEvent, MeasuresState> {
  final HomeService _homeService;
  final WeightService _weightService;
  final MeasuresService _measuresService;

  MeasuresBloc(
    HomeService homeService,
    WeightService weightService,
    MeasuresService measuresService,
  )   : _homeService = homeService,
        _weightService = weightService,
        _measuresService = measuresService,
        super(MeasuresInitial()) {
    on<MeasuresLoadInit>(_mapMeasuresMainPage);
    on<MeasuresLoadDetailed>(_mapMeasuresDetailed);
    on<MeasureUpdate>(_mapMeasuresUpdate);
    on<MeasureCreate>(_mapMeasuresCreate);
    on<MeasureDelete>(_mapMeasuresDelete);
  }

  void _mapMeasuresMainPage(
    MeasuresEvent event,
    Emitter<MeasuresState> emit,
  ) async {
    emit(MeasuresSplash());

    if (event is MeasuresLoadInit) {
      emit(MeasuresInitial());
    } else {
      emit(MeasuresError());
    }
  }

  void _mapMeasuresDetailed(
    MeasuresEvent event,
    Emitter<MeasuresState> emit,
  ) async {
    emit(MeasuresSplash());

    if (event is MeasuresLoadDetailed) {
      List<String> lockedDates = [];
      for (Weight weight in event.weights) {
        lockedDates.add(weight.date);
      }

      Measure? measure;

      Weight? weight;

      if (event.weight is Weight && event.weight?.id is int) {
        weight = event.weight;
        measure = await _measuresService.getMeasureByWeightId(
          weightId: event.weight!.id!,
        );
      }

      if (weight is! Weight) {
        int? id = await _homeService.getCurrentUser();

        if (id is int) {
          weight = await _weightService.getLastWeight(id: id);
        }
      }

      emit(
        MeasuresDetailed(
          lockedDates: lockedDates,
          weight: event.weight,
          initialWeight: weight?.weight,
          measure: measure,
          option: event.option,
          isNotFirst: event.isNotFirst,
        ),
      );
    } else {
      emit(MeasuresError());
    }
  }

  void _mapMeasuresUpdate(
    MeasuresEvent event,
    Emitter<MeasuresState> state,
  ) async {
    emit(MeasuresSplash());

    if (event is MeasureUpdate) {
      await _weightService.updateWeight(
        recordId: event.weight.id!,
        weight: event.weight.weight,
      );

      if (event.measure.weightId is int) {
        await _measuresService.updateMeasure(measure: event.measure);
      } else {
        event.measure.weightId = event.weight.id;
        await _measuresService.addMeasure(measure: event.measure);
      }

      emit(MeasuresInitial());
    } else {
      emit(MeasuresError());
    }
  }

  void _mapMeasuresCreate(
    MeasuresEvent event,
    Emitter<MeasuresState> state,
  ) async {
    emit(MeasuresSplash());

    if (event is MeasureCreate) {
      Weight? weight;

      if (event.weight.id is! int) {
        weight = await _weightService.insertNewRecord(
          userId: event.weight.userId,
          weight: event.weight.weight,
          date: event.weight.date,
        );
      }

      Measure measure = event.measure;
      measure.weightId = weight is! Weight ? event.weight.id : weight.id;
      await _measuresService.addMeasure(measure: event.measure);

      if (weight is Weight && event.isLast) {
        await _homeService.updateUserWeight(weight.userId, weight.weight);
      }
      emit(MeasuresInitial());
    } else {
      emit(MeasuresError());
    }
  }

  void _mapMeasuresDelete(
    MeasuresEvent event,
    Emitter<MeasuresState> state,
  ) async {
    emit(MeasuresSplash());

    if (event is MeasureDelete) {
      await _weightService.removeWeight(recordId: event.weightId);

      await _measuresService.removeMeasure(weightId: event.weightId);

      emit(MeasuresInitial());
    } else {
      emit(MeasuresError());
    }
  }
}
