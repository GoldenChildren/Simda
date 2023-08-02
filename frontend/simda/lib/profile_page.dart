import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simda/profileedit_page.dart';
import 'followers_list.dart';
import 'following_list.dart';
import 'profile_calendar.dart';
import 'profile_feed.dart';
import 'profile_map.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _nickname = "신짱구";
  String _bio = "노는게 제일 좋아";
  String? _pickedFile;


  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery
        .of(context)
        .size
        .width / 4;

    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '신짱구',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // IconButton(onPressed: () {},
                    //   icon: const Icon(Icons.menu), iconSize: 28,
                    // ),
                  ],
                ),
              ),
              Container(height: 2, color: Colors.purple),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _navigateToProfileEditPage(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      constraints: BoxConstraints(
                        minHeight: imageSize,
                        minWidth: imageSize,
                      ),
                      child: _pickedFile == null
                          ? Center(
                        child: Icon(
                          Icons.account_circle,
                          size: imageSize,
                        ),
                      )
                          : Center(
                        child: Container(
                          width: imageSize,
                          height: imageSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 2,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
                            ),
                            image: DecorationImage(
                              image: FileImage(File(_pickedFile!)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _navigateToFollowingListPage(
                                    context); // 팔로잉 숫자를 누르면 팔로잉 목록 페이지로 이동
                              },
                              child: createColumns('following', 1120),
                            ),
                            GestureDetector(
                              onTap: () {
                                _navigateToFollowersListPage(
                                    context); // 팔로워 숫자를 누르면 팔로워 목록 페이지로 이동
                              },
                              child: createColumns('followers', 12000),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Text(
                          _nickname,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _navigateToProfileEditPage(context);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  _bio,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Container(
              //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              //   alignment: Alignment.center,
              //   child: const Image(image: AssetImage('assets/images/promap.PNG')),
              // )
              const TabBar(indicatorColor: Colors.purple,
                  labelColor: Colors.purple,
                  labelStyle: TextStyle(
                    // color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  indicatorWeight: 3,
                  tabs: [
                    Tab(
                      text: '달력',
                      height: 50,
                    ),
                    Tab(
                      text: '피드',
                      height: 50,
                    ),
                    Tab(
                      text: '지도',
                      height: 50,
                    ),
                  ]),
              const Expanded(
                child: TabBarView(
                  children: [
                    TableCalendarScreen(),
                    //   Container(
                    //   width: 10,
                    //   color: const Color.fromRGBO(91, 91, 91, 1),
                    //   child: const Center(
                    //     child: Text(
                    //       '달력',
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 56,
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                    ProfileFeedPage(),
                    //   ListView.builder(
                    //       key: const PageStorageKey("피드"),
                    //       itemCount: 1000,
                    //       itemBuilder: (context, index) {
                    //         return Container(
                    //           padding: const EdgeInsets.symmetric(vertical: 12),
                    //           width: MediaQuery.of(context).size.width,
                    //           child: Center(
                    //             child: Text(
                    //               "List View $index",
                    //               style: TextStyle(
                    //                   fontSize: 16,
                    //                   color: Colors.accents[index % 15],
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //           ),
                    //         );
                    //       }),
                    ProfileMapPage(),
                    // Container(
                    //   width: 10,
                    //   color: const Color.fromRGBO(91, 91, 91, 1),
                    //   child: const Center(
                    //     child: Text(
                    //       '지도',
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 56,
                    //           fontWeight: FontWeight.bold),
                    //     ),s
                    //   ),
                  ],
                ),
              ),
            ],
          ),
            endDrawer: EndDrawerButton(),
        ),
      ),
    );
  }

  void _navigateToProfileEditPage(BuildContext context) async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditPage(
          nickname: _nickname,
          bio: _bio,
          pickedFile: _pickedFile,
        ),
      ),
    );

    if (updatedData != null) {
      setState(() {
        _nickname = updatedData['nickname'];
        _bio = updatedData['bio'];
        _pickedFile = updatedData['pickedFile'];
      });
    }
  }

  void _navigateToFollowingListPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const FollowingListPage(), // FollowingListPage는 팔로잉 목록을 보여주는 새로운 페이지입니다.
      ),
    );
  }

  void _navigateToFollowersListPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const FollowersListPage(), // FollowersListPage는 팔로워 목록을 보여주는 새로운 페이지입니다.
      ),
    );
  }

  Column createColumns(String title, int count) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$count',
          style: const TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.black45,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
}

