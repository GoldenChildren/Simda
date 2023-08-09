import 'package:flutter/material.dart';
import 'package:simda/providers/feed_providers.dart';
import 'package:simda/providers/user_providers.dart';
import 'package:table_calendar/table_calendar.dart';

import 'main.dart';
import 'models/FeedDto.dart';

class TableCalendarScreen extends StatefulWidget {
  const TableCalendarScreen({Key? key}) : super(key: key);

  @override
  _TableCalendarScreenState createState() => _TableCalendarScreenState();
}

class _TableCalendarScreenState extends State<TableCalendarScreen> {
  int _userId = 0;
  UserProviders userProvider = UserProviders();

  List<FeedDto> feed = [];
  FeedProviders feedProvider = FeedProviders();

  bool isLoading = true;
  List<bool> isVisible = [];

  Future<void> initFeed() async {
    feed = await feedProvider.getUserFeedList(_userId);
    setState(() {
      isVisible = List.generate(feed.length, (index) => true);
      _generateMarkers();
    });
  }

  Map<DateTime, List<Widget>> _markers = {};

  Future<void> _generateMarkers() async {
    _markers = {};
    for (var i = 0; i < feed.length; i++) {
      final feedItem = feed[i];
      final emotion = feedItem.emotion;
      final date = DateTime.parse(feedItem.regDate);
      // final date = DateTime.utc(feedItem.regDate.year, feedItem.regDate.month, feedItem.regDate.day);

      final image = Image.asset('assets/images/flower$emotion.png', width: 20, height: 17);

      if (_markers.containsKey(date)) {
        _markers[date]!.add(image);
      } else {
        _markers[date] = [image];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _userId = 0;
    getValueFromSecureStorage();
  }

  Future<void> getValueFromSecureStorage() async {
    try {
      final storeUserId = int.parse(await storage.read(key: "userId") ?? "");
      setState(() {
        _userId = storeUserId;
        initFeed();
      });
    } catch (e) {
      print("Error reading from secure storage: $e");
    }
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
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, event) {
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
