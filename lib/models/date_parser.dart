import 'package:intl/intl.dart';

class DateParser {
  final DateTime date;

  DateParser({
    required this.date,
  });

  String getDateWithoutTime() {
    final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');

    return dateFormatter.format(date);
  }

  List<dynamic> get props => [date];
}
