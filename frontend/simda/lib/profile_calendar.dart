import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalendarScreen extends StatefulWidget {
  const TableCalendarScreen({Key? key}) : super(key: key);

  @override
  _TableCalendarScreenState createState() => _TableCalendarScreenState();
}

class _TableCalendarScreenState extends State<TableCalendarScreen> {
  late final Image _flowerGreen;
  late final Image _flowerYellow;
  late final Image _flowerPurple;
  late final Image _flowerPink;
  late final Image _flowerBlue;

  final Map<DateTime, List<Widget>> _markers = {};

  @override
  void initState() {
    super.initState();
    _flowerGreen = Image.asset('assets/images/flower0.png', width: 20, height: 17);
    _flowerYellow = Image.asset('assets/images/flower1.png', width: 20, height: 17);
    _flowerPurple = Image.asset('assets/images/flower2.png', width: 20, height: 17);
    _flowerPink = Image.asset('assets/images/flower3.png', width: 20, height: 17);
    _flowerBlue = Image.asset('assets/images/flower4.png', width: 20, height: 17);


    _markers.addAll({
      DateTime.utc(2023, 7, 1): [_flowerPink],
      DateTime.utc(2023, 7, 3): [_flowerGreen],
      DateTime.utc(2023, 7, 4): [_flowerGreen],
      DateTime.utc(2023, 7, 5): [_flowerBlue],
      DateTime.utc(2023, 7, 6): [_flowerGreen],
      DateTime.utc(2023, 7, 9): [_flowerBlue],
      DateTime.utc(2023, 7, 11): [_flowerGreen],
      DateTime.utc(2023, 7, 14): [_flowerPurple],
      DateTime.utc(2023, 7, 15): [_flowerYellow],
      DateTime.utc(2023, 7, 16): [_flowerYellow],
      DateTime.utc(2023, 7, 18): [_flowerYellow],
      DateTime.utc(2023, 7, 20): [_flowerPurple],
      DateTime.utc(2023, 7, 21): [_flowerYellow],
      DateTime.utc(2023, 7, 22): [_flowerYellow],
      DateTime.utc(2023, 7, 23): [_flowerYellow],
      DateTime.utc(2023, 7, 25): [_flowerGreen],
      DateTime.utc(2023, 7, 28): [_flowerPurple],
      DateTime.utc(2023, 7, 31): [_flowerGreen],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: SingleChildScrollView(
       scrollDirection: Axis.vertical,
       child: TableCalendar(
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
          // cellMargin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            final children = <Widget>[];
            if (_markers.containsKey(date)) {
              children.addAll(_markers[date]!);
            }
            return children.isNotEmpty ? Positioned(bottom: 1, child: Row(children: children)) : SizedBox.shrink();

          },
        ),
      ),
    ),
    );
  }
}