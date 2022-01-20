enum Sex { female, male }
enum ActivityLevel { none, low, medium, above, high }
enum Unit { metric, imperial }

class User {
  int? id;
  final String name;
  final int age;
  final double height;
  final String heightUnit;
  final double initWeight;
  final String initWeightUnit;
  final double targetWeight;
  final String targetWeightUnit;
  final int stars;
  final String gender;
  final String activityLevel;
  final String initDate;

  User({
    this.id,
    required this.name,
    required this.age,
    required this.height,
    required this.heightUnit,
    required this.initWeight,
    required this.initWeightUnit,
    required this.targetWeight,
    required this.targetWeightUnit,
    required this.stars,
    required this.gender,
    required this.activityLevel,
    required this.initDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    User user = User(
      id: json['pk'],
      name: json['name'] ?? '',
      age: json['age'] ?? 18,
      height: json['height'],
      heightUnit: json['heightUnit'],
      initWeight: json['initWeight'],
      initWeightUnit: json['initWeightUnit'],
      targetWeight: json['targetWeight'],
      targetWeightUnit: json['targetWeightUnit'],
      stars: json['stars'],
      gender: json['gender'].toString(),
      activityLevel: json['activityLevel'].toString(),
      initDate: json['initDate'].toString(),
    );
    return user;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pk'] = id;
    data['name'] = name;
    data['age'] = age;
    data['height'] = height;
    data['heightUnit'] = heightUnit;
    data['initWeight'] = initWeight;
    data['initWeightUnit'] = initWeightUnit;
    data['targetWeight'] = targetWeight;
    data['targetWeightUnit'] = targetWeightUnit;
    data['stars'] = stars;
    data['gender'] = gender;
    data['activityLevel'] = activityLevel;
    data['initDate'] = initDate;
    return data;
  }

  List<dynamic> get props => [
        id,
        name,
        age,
        height,
        initWeight,
        targetWeight,
        stars,
        gender,
        activityLevel,
        initDate,
      ];
}
