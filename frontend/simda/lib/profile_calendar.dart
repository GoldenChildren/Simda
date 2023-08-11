import 'package:flutter/material.dart';
import 'package:simda/providers/feed_providers.dart';
import 'package:simda/providers/user_providers.dart';
import 'package:table_calendar/table_calendar.dart';

import 'main.dart';
import 'models/FeedDto.dart';

class ProfileCalendarPage extends StatefulWidget {

  const ProfileCalendarPage({Key? key}) : super(key: key);

  @override
  State<ProfileCalendarPage> createState() => _ProfileCalendarPageState();
}

class _ProfileCalendarPageState extends State<ProfileCalendarPage> {
  int _userId = 0;
  UserProviders userProvider = UserProviders();

  List<FeedDto> feed = [];
  FeedProviders feedProvider = FeedProviders();

  bool isLoading = true;
  List<bool> isVisible = [];

  Map<DateTime, List<FeedDto>> _emotionMap = {};

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
      final year = int.parse(feedItem.regDate.substring(0, 4)); // 년 추출
      final month = int.parse(feedItem.regDate.substring(5, 7)); // 월 추출
      final day = int.parse(feedItem.regDate.substring(8, 10)); // 일 추출
      final date = DateTime.utc(year, month, day); // DateTime 객체 생성

      if (_emotionMap.containsKey(date)) {
        _emotionMap[date]!.add(feedItem);
      } else {
        _emotionMap[date] = [feedItem];
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
      backgroundColor: Colors.white,
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
                emotions.sort((a, b) => b.regDate.compareTo(a.regDate)); // 최신 값이 먼저 오도록 정렬
                final latestEmotion = emotions.first;
                final emotion = latestEmotion.emotion;
                final image = Image.asset('assets/images/flower$emotion.png', width: 20, height: 17);
                children.add(image);
              }
              return children.isNotEmpty
                  ? Positioned(bottom: 1, child: Row(children: children))
                  : const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
