import 'package:intl/intl.dart';

class Metric {
  final String? height;
  final double? weight;

  Metric({
    this.height,
    this.weight,
  });

  double getParsedHeight() {
    if (height is String) {
      List<String> splitted = height!.split('\'');

      int foots = int.tryParse(splitted.first) ?? 0;
      int inches = int.tryParse(splitted.last) ?? 0;

      return foots * 30.48 + inches * 2.54;
    }

    return 0;
  }

  double getParsedWeight() {
    if (weight is double) {
      return weight! * 0.45;
    }

    return 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['height'] = height;
    data['weight'] = weight;
    return data;
  }

  List<dynamic> get props => [height, weight];
}
