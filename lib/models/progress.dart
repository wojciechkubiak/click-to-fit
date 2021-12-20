import 'package:star_metter/models/weight.dart';
import 'package:star_metter/models/star.dart';

class Progress {
  final int? id;
  final String date;
  final int stars;
  final int limit;
  final double currentWeight;
  final List<Star> starProgress;
  final List<Weight> weightProgress;

  Progress({
    this.id,
    required this.date,
    required this.stars,
    required this.limit,
    required this.currentWeight,
    required this.starProgress,
    required this.weightProgress,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    List<Star> _starProgress = [];
    if (json['starProgress'] != null) {
      json['starProgress'].forEach(
        (progress) => _starProgress.add(Star.fromJson(progress)),
      );
    }

    List<Weight> _weightProgress = [];
    if (json['weightProgress'] != null) {
      json['weightProgress'].forEach(
        (progress) => _weightProgress.add(Weight.fromJson(progress)),
      );
      _weightProgress.sort((a, b) => a.id!.compareTo(b.id!));
    }

    Progress progress = Progress(
      id: json['pk'],
      date: json['date'],
      stars: json['stars'],
      limit: json['limit'],
      currentWeight: json['currentWeight'],
      starProgress: _starProgress,
      weightProgress: _weightProgress,
    );
    return progress;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pk'] = id;
    data['date'] = date;
    data['stars'] = stars;
    data['limit'] = limit;
    data['currentWeight'] = currentWeight;
    data['starProgress'] = starProgress;
    data['weightProgress'] = weightProgress;
    return data;
  }

  List<dynamic> get props => [
        id,
        date,
        stars,
        limit,
        currentWeight,
        starProgress,
        weightProgress,
      ];
}
