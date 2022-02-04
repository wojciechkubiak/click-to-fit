import 'package:bloc/bloc.dart';
import 'package:star_metter/models/measure.dart';
import 'package:star_metter/models/user.dart';
import 'package:star_metter/models/weight.dart';
import 'package:star_metter/services/measures.dart';
import '../../services/settings.dart';
import './../../services/services.dart';

part 'measures_event.dart';
part 'measures_state.dart';

class MeasuresBloc extends Bloc<MeasuresEvent, MeasuresState> {
  final SettingsService _settingsService;
  final WeightService _weightService;
  final MeasuresService _measuresService;

  MeasuresBloc(
    SettingsService settingsService,
    WeightService weightService,
    MeasuresService measuresService,
  )   : _settingsService = settingsService,
        _weightService = weightService,
        _measuresService = measuresService,
        super(MeasuresInitial()) {
    on<MeasuresLoadInit>(_mapMeasuresMainPage);
    on<MeasuresLoadDetailed>(_mapMeasuresDetailed);
  }

  void _mapMeasuresMainPage(
    MeasuresEvent event,
    Emitter<MeasuresState> emit,
  ) async {
    emit(MeasuresSplash());

    if (event is MeasuresLoadInit) {
      if (event.option is MeasuresDetailedOption) {
        if (event.option == MeasuresDetailedOption.delete) {
          if (event.weightId is int) {
            await _weightService.removeWeight(recordId: event.weightId!);
          }

          if (event.measureId is int) {
            await _measuresService.removeMeasure(measureId: event.measureId!);
          }
        } else if (event.option == MeasuresDetailedOption.edit &&
            event.weight is Weight) {
          await _weightService.updateWeight(
            recordId: event.weight!.id!,
            weight: event.weight!.weight,
          );

          if (event.measure is Measure) {
            await _measuresService.updateMeasure(measure: event.measure!);
          }
        } else if (event.option == MeasuresDetailedOption.create &&
            event.weight is Weight) {
          Weight? weight = await _weightService.insertNewRecord(
            userId: event.weight!.userId,
            weight: event.weight!.weight,
            date: event.weight!.date,
          );
          Measure? measure = event.measure;

          if (event.measure is Measure && weight is Weight) {
            measure!.weightId = weight.id;
            await _measuresService.addMeasure(measure: event.measure!);
          }
        }

        emit(MeasuresInitial());
      }

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

      if (event.weight is Weight && event.weight?.id is int) {
        measure = await _measuresService.getMeasureByWeightId(
          weightId: event.weight!.id!,
        );
      }

      emit(
        MeasuresDetailed(
          lockedDates: lockedDates,
          weight: event.weight,
          measure: measure,
          option: event.option,
          isNotFirst: event.isNotFirst,
        ),
      );
    } else {
      emit(MeasuresError());
    }
  }
}
