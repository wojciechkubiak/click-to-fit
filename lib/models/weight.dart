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
