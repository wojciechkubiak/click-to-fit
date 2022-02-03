part of 'measures_bloc.dart';

abstract class MeasuresEvent {
  const MeasuresEvent();
}

class MeasuresLoadInit extends MeasuresEvent {
  final MeasuresDetailedOption? option;
  final Weight? weight;
  final int? weightId;
  final Measure? measure;
  final int? measureId;
  final User? user;

  const MeasuresLoadInit({
    this.option,
    this.weight,
    this.weightId,
    this.measure,
    this.measureId,
    this.user,
  });

  List<Object?> get props => [option];
}

class MeasuresLoadDetailed extends MeasuresEvent {
  final List<Weight> weights;
  final Weight? weight;
  final bool? isNotFirst;
  final MeasuresDetailedOption option;

  const MeasuresLoadDetailed({
    required this.option,
    this.isNotFirst = true,
    this.weights = const [],
    this.weight,
  });

  List<Object?> get props => [weights];
}
