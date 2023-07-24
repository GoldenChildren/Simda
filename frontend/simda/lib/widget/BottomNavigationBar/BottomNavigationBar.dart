import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';

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
    title: 'profile',
  ),
];

class BottomNavigationBar extends StatefulWidget {
  const BottomNavigationBar({super.key, required this.title});

  final String title;

  @override
  State<BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  int visit = 0;
  double height = 30;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      bottomNavigationBar: Container(
        padding:const EdgeInsets.only(bottom: 20, right: 20, left: 20),
        child: BottomBarFloating(
          items: items,
          backgroundColor: Colors.white,
          color: Colors.black54,
          colorSelected: Colors.deepPurpleAccent,
          indexSelected: visit,
          paddingVertical: 24,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: const Offset(0,7),
            )
          ],
          onTap: (int index) => setState(() {
            visit = index;
          }),
        ),
      ),
    );
  }
}