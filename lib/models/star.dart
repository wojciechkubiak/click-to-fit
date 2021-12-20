class Star {
  final int? id;
  final String date;
  final int userId;
  int stars;

  Star({
    this.id,
    required this.date,
    required this.userId,
    required this.stars,
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
    );
    return starProgress;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pk'] = id;
    data['date'] = date;
    data['userId'] = userId;
    data['stars'] = stars;
    return data;
  }

  List<dynamic> get props => [
        id,
        date,
        userId,
        stars,
      ];
}
