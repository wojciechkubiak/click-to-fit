import 'package:flutter/material.dart';
import 'package:star_metter/config/colors.dart';
import 'package:star_metter/lang/localization_code.dart';
import 'package:star_metter/models/measure.dart';
import 'package:star_metter/models/models.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  final List<DateTime> lockedDates;
  final Weight? weight;
  final MeasuresDetailedOption option;
  final Function hideError;
  final void Function({required DateTime dt}) handleDate;

  const Calendar({
    Key? key,
    required this.option,
    required this.hideError,
    required this.handleDate,
    this.lockedDates = const [],
    this.weight,
  }) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Weight? _weight;

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    _weight = widget.weight;
  }

  DateTime parseDate({required String date}) {
    List<String> v1 = _weight!.date.split('-');
    return DateTime.utc(
      int.parse(v1[2]),
      int.parse(v1[1]),
      int.parse(v1[0]),
    );
  }

  DateTime getFirstDay() {
    if (widget.option == MeasuresDetailedOption.create) {
      return DateTime.now().add(const Duration(days: -365));
    } else {
      if (_weight is Weight) {
        return parseDate(date: _weight!.date);
      } else {
        return DateTime.now().add(const Duration(days: -365));
      }
    }
  }

  DateTime getLastDay() {
    if (widget.option == MeasuresDetailedOption.create) {
      return DateTime.now().add(const Duration(days: 90));
    } else {
      if (_weight is Weight) {
        return parseDate(date: _weight!.date);
      } else {
        return DateTime.now().add(const Duration(days: 90));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? locale = LocalizationCode(context: context).getLocale();
    print(locale);

    return TableCalendar(
      locale: locale,
      startingDayOfWeek: StartingDayOfWeek.monday,
      firstDay: getFirstDay(),
      lastDay: getLastDay(),
      focusedDay: widget.option == MeasuresDetailedOption.edit
          ? parseDate(date: _weight!.date)
          : _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(
            widget.option == MeasuresDetailedOption.create
                ? _selectedDay
                : parseDate(date: _weight!.date),
            day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (widget.option == MeasuresDetailedOption.create) {
          DateTime now = DateTime.now();

          int year = now.year;
          int month = now.month;
          int day = now.day;

          if (selectedDay.isBefore(
            DateTime.utc(year, month, day).add(const Duration(days: 1)),
          )) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` here as well
            });

            widget.handleDate(dt: selectedDay);
            widget.hideError();
          }
        }
      },
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      headerStyle: HeaderStyle(
        titleCentered: true,
        titleTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w600,
            ),
        leftChevronIcon: Container(
          child: const Icon(
            Icons.arrow_back,
            size: 32,
            color: Colors.white,
          ),
        ),
        rightChevronIcon: Container(
          child: const Icon(
            Icons.arrow_forward,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
        weekendStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        outsideDaysVisible: false,
        selectedDecoration: const BoxDecoration(
          color: CustomColor.primaryAccentSemiLight,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
        defaultTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
        todayTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
        weekendTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
      ),
    );
  }
}
