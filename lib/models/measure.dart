class Measure {
  final int? id;
  final int userId;
  final int weightId;
  String date;
  double neck;
  double abdomen;
  double chest;
  double hips;
  double bicep;
  double thigh;
  double waist;
  double calf;

  Measure({
    this.id,
    required this.userId,
    required this.weightId,
    required this.date,
    required this.neck,
    required this.abdomen,
    required this.chest,
    required this.hips,
    required this.bicep,
    required this.thigh,
    required this.waist,
    required this.calf,
  });

  factory Measure.fromJson(Map<String, dynamic> json) {
    Measure weight = Measure(
      id: json['pk'],
      userId: json['userId'],
      weightId: json['weightId'],
      date: json['date'],
      neck: json['neck'],
      abdomen: json['abdomen'],
      chest: json['chest'],
      hips: json['hips'],
      bicep: json['bicep'],
      thigh: json['thigh'],
      waist: json['waist'],
      calf: json['calf'],
    );
    return weight;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pk'] = id;
    data['userId'] = userId;
    data['weightId'] = weightId;
    data['date'] = date;
    data['neck'] = neck;
    data['abdomen'] = abdomen;
    data['chest'] = chest;
    data['hips'] = hips;
    data['bicep'] = bicep;
    data['thigh'] = thigh;
    data['waist'] = waist;
    data['calf'] = calf;
    return data;
  }

  List<dynamic> get props => [
        id,
        userId,
        weightId,
        date,
        neck,
        abdomen,
        chest,
        hips,
        bicep,
        thigh,
        waist,
        calf,
      ];
}
