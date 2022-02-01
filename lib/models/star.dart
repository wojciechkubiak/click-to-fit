enum DateScope { week, month, year }

class Star {
  final int? id;
  final String date;
  final int userId;
  int stars;
  int progressLimit;

  Star({
    this.id,
    required this.date,
    required this.userId,
    required this.stars,
    required this.progressLimit,
  });

  bool isTodayCheck() {
    DateTime now = DateTime.now();
    int day = now.day;
    int month = now.month;
    int year = now.year;
    print('$day $month $year');
    List<String> parsed = date.split('-');

    return day == int.parse(parsed[0]) &&
        month == int.parse(parsed[1]) &&
        year == int.parse(parsed[2]);
  }

  factory Star.fromJson(Map<String, dynamic> json) {
    Star starProgress = Star(
      id: json['pk'],
      date: json['date'],
      userId: json['userId'],
      stars: json['stars'],
      progressLimit: json['progressLimit'],
    );
    return starProgress;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pk'] = id;
    data['date'] = date;
    data['userId'] = userId;
    data['stars'] = stars;
    data['progressLimit'] = progressLimit;
    return data;
  }

  List<dynamic> get props => [
        id,
        date,
        userId,
        stars,
        progressLimit,
      ];
}

class ChartStar {
  int value;
  int limit;
  String date;

  ChartStar({
    required this.value,
    required this.limit,
    required this.date,
  });

  factory ChartStar.fromJson(Map<String, dynamic> json) {
    ChartStar starProgress = ChartStar(
      value: json['value'],
      limit: json['limit'],
      date: json['date'],
    );
    return starProgress;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['value'] = value;
    data['limit'] = limit;
    data['date'] = date;
    return data;
  }

  List<dynamic> get props => [
        value,
        limit,
        date,
      ];
}

class YearStar {
  int value;
  int limit;

  YearStar({
    required this.value,
    required this.limit,
  });

  factory YearStar.fromJson(Map<String, dynamic> json) {
    YearStar starProgress = YearStar(
      value: json['value'],
      limit: json['limit'],
    );
    return starProgress;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['value'] = value;
    data['limit'] = limit;
    return data;
  }

  List<dynamic> get props => [
        value,
        limit,
      ];
}
