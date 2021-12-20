enum Sex { female, male }
enum ActivityLevel { none, low, medium, above, high }

class User {
  final int? id;
  final String name;
  final int age;
  final double height;
  final double initWeight;
  final double targetWeight;
  final int stars;
  final String gender;
  final String activityLevel;
  final String initDate;

  User({
    this.id,
    required this.name,
    required this.age,
    required this.height,
    required this.initWeight,
    required this.targetWeight,
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
      initWeight: json['initWeight'],
      targetWeight: json['targetWeight'],
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
    data['initWeight'] = initWeight;
    data['targetWeight'] = targetWeight;
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
