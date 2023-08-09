import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'main.dart';
import 'map_page.dart';
import '../feed_page.dart';
import '../chatting_page.dart';
import 'search_page.dart';
import 'profile_page.dart';

const List<TabItem> items = [
  TabItem(
    icon: Icons.home_outlined,
    title: 'Home',
  ),
  TabItem(
    icon: Icons.feed_outlined,
    title: 'Feed',
  ),
  TabItem(
    icon: Icons.chat_bubble_outline,
    title: 'Chatting',
  ),
  TabItem(
    icon: Icons.search_sharp,
    title: 'Search',
  ),
  TabItem(
    icon: Icons.person_outlined,
    title: 'Profile',
  ),
];

class MainPage extends StatelessWidget {

  int visit;

  MainPage(this.visit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _permission();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BottomNavigationBar(
        title: 'BottomNavigationBar',
        index: visit,
      ),
    );
  }
  void _permission() async {
    var requestStatus = await Permission.location.request();
    var status = await Permission.location.status;
    print(requestStatus.isGranted);
    print(status.isLimited);
    if (requestStatus.isGranted && status.isLimited) {
      // isLimited - 제한적 동의 (ios 14 < )
      // 요청 동의됨
      print("isGranted");
      if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
        // 요청 동의 + gps 켜짐
        var position = await Geolocator.getCurrentPosition();
        print("serviceStatusIsEnabled position = ${position.toString()}");
      } else {
        // 요청 동의 + gps 꺼짐
        print("serviceStatusIsDisabled");
      }
    } else if (requestStatus.isPermanentlyDenied ||
        status.isPermanentlyDenied) {
      // 권한 요청 거부, 해당 권한에 대한 요청에 대해 다시 묻지 않음 선택하여 설정화면에서 변경해야함. android
      print("isPermanentlyDenied");
      openAppSettings();
    } else if (status.isRestricted) {
      // 권한 요청 거부, 해당 권한에 대한 요청을 표시하지 않도록 선택하여 설정화면에서 변경해야함. ios
      print("isRestricted");
      openAppSettings();
    } else if (status.isDenied) {
      // 권한 요청 거절
      print("isDenied");
    }
    print("requestStatus ${requestStatus.name}");
    print("status ${status.name}");
  }
}

class BottomNavigationBar extends StatefulWidget {

  int index;
  BottomNavigationBar({super.key, required this.title, required this.index});

  final String title;

  @override
  State<BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: _page[widget.index],
          bottomNavigationBar: Visibility(
            visible: isVisible,
            child: Container(
              decoration: BoxDecoration(boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  blurRadius: 10.0,
                )
              ]),
              child: BottomBarBackground(
                items: items,
                backgroundColor: Colors.white,
                color: Colors.black54,
                colorSelected: Colors.deepPurpleAccent,
                indexSelected: widget.index,
                paddingVertical: 20,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    blurRadius: 5.0,
                    spreadRadius: 0.0,
                    offset: const Offset(0, 7),
                  )
                ],
                onTap: (int page) => setState(() {
                  widget.index = page;
                }),
                backgroundSelected: Colors.black12,
              ),
            ),
          ),
        ));
  }
}

final List<Widget> _page = [
  const MapPage(),
  const FeedPage(),
  const ChattingPage(),
  const SearchPage(),
  const ProfilePage(),
];
