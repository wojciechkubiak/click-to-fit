part of 'measures_bloc.dart';

abstract class MeasuresState {}

class MeasuresInitial extends MeasuresState {}

class MeasuresSplash extends MeasuresState {}

class MeasuresDetailed extends MeasuresState {
  final List<String> lockedDates;
  final Weight? weight;
  final Measure? measure;
  final bool? isNotFirst;
  final MeasuresDetailedOption option;

  MeasuresDetailed({
    required this.option,
    this.lockedDates = const [],
    this.weight,
    this.measure,
    this.isNotFirst = true,
  });

  List<Object?> get props => [lockedDates];
}

class MeasuresError extends MeasuresState {}
