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

  Map<DateTime, List<Image>> _emotionMap = {};

  Future<void> initFeed() async {
    feed = await feedProvider.getUserFeedList(_userId);
    setState(() {
      isVisible = List.generate(feed.length, (index) => true);
      _generateMarkers();
    });
  }

  Future<void> _generateMarkers() async {
    _emotionMap = {};
    for (var i = 0; i < feed.length; i++) {
      final feedItem = feed[i];
      final emotion = feedItem.emotion;
      // final date = DateTime.parse(feedItem.regDate);
      final year = int.parse(feedItem.regDate.substring(0, 4)); // 년 추출
      final month = int.parse(feedItem.regDate.substring(5, 7)); // 월 추출
      final day = int.parse(feedItem.regDate.substring(8, 10)); // 일 추출
      final date = DateTime.utc(year, month, day); // DateTime 객체 생성
      final image = Image.asset('assets/images/flower$emotion.png', width: 20, height: 17);
      await precacheImage(image.image, context);

      if (_emotionMap.containsKey(date)) {
        _emotionMap[date]!.add(image);
        print(_emotionMap);
      } else {
        _emotionMap[date] = [image];
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
              if (_emotionMap.containsKey(date)) {
                final emotions = _emotionMap[date]!;
                for (var emotionImage in emotions) {
                  children.add(emotionImage);
                }
              }
              return children.isNotEmpty
                  ? Positioned(bottom: 1, child: Row(children: children))
                  : SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}