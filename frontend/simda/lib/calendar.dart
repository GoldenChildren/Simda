import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class TableCalendarScreen extends StatelessWidget {
  const TableCalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TableCalendar(
        locale: 'ko_KR',
        firstDay: DateTime.utc(2021, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: true,
          weekendTextStyle: const TextStyle().copyWith(color: Colors.red),
          holidayTextStyle: const TextStyle().copyWith(color: Colors.blue[800]),
        ),
      ),
    );
  }
}
