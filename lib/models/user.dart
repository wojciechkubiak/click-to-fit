enum Sex { female, male }
enum ActivityLevel { none, low, medium, above, high }
enum StorageType { local, cloud }

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
  final String storageType;

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
    required this.storageType,
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
      storageType: json['storageType'].toString(),
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
    data['storageType'] = storageType;
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
        storageType,
      ];
}
