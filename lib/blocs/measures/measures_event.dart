part of 'measures_bloc.dart';

abstract class MeasuresEvent {
  const MeasuresEvent();
}

class MeasuresLoadInit extends MeasuresEvent {}

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

class MeasureUpdate extends MeasuresEvent {
  final Weight weight;
  final Measure measure;

  const MeasureUpdate({required this.weight, required this.measure});

  List<Object?> get props => [weight, measure];
}

class MeasureCreate extends MeasuresEvent {
  final Weight weight;
  final Measure measure;

  const MeasureCreate({required this.weight, required this.measure});

  List<Object?> get props => [weight, measure];
}

class MeasureDelete extends MeasuresEvent {
  final int weightId;

  const MeasureDelete({required this.weightId});

  List<Object?> get props => [weightId];
}
