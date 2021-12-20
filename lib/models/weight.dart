class Weight {
  final int? id;
  final String date;
  final double weight;

  Weight({
    this.id,
    required this.date,
    required this.weight,
  });

  factory Weight.fromJson(Map<String, dynamic> json) {
    Weight weight = Weight(
      id: json['pk'],
      date: json['date'],
      weight: json['weight'],
    );
    return weight;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pk'] = id;
    data['date'] = date;
    data['weight'] = weight;
    return data;
  }

  List<dynamic> get props => [
        id,
        date,
        weight,
      ];
}
