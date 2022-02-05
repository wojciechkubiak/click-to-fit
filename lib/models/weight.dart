class Weight {
  final int? id;
  final int userId;
  String date;
  double weight;

  Weight({
    this.id,
    required this.date,
    required this.userId,
    required this.weight,
  });

  factory Weight.fromJson(Map<String, dynamic> json) {
    Weight weight = Weight(
      id: json['pk'],
      date: json['date'],
      userId: json['userId'],
      weight: json['weight'],
    );
    return weight;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pk'] = id;
    data['date'] = date;
    data['userId'] = userId;
    data['weight'] = weight;
    return data;
  }

  List<dynamic> get props => [
        id,
        date,
        weight,
        userId,
      ];
}

class SortedWeight {
  String date;
  double weight;
  int dayOfWeek;

  SortedWeight({
    required this.date,
    required this.weight,
    required this.dayOfWeek,
  });

  factory SortedWeight.fromJson(Map<String, dynamic> json) {
    SortedWeight weight = SortedWeight(
      date: json['date'],
      weight: json['weight'],
      dayOfWeek: json['dayOfWeek'],
    );
    return weight;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['date'] = date;
    data['weight'] = weight;
    data['dayOfWeek'] = dayOfWeek;
    return data;
  }

  List<dynamic> get props => [date, weight, dayOfWeek];
}

class YearWeight {
  double value;
  int found;

  YearWeight({
    required this.value,
    required this.found,
  });

  factory YearWeight.fromJson(Map<String, dynamic> json) {
    YearWeight weights = YearWeight(
      value: json['value'],
      found: json['found'],
    );
    return weights;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['value'] = value;
    data['found'] = found;
    return data;
  }

  List<dynamic> get props => [
        value,
        found,
      ];
}
