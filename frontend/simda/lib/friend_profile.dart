import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simda/profile_edit_page.dart';
import 'profile_calendar.dart';
import 'chat_with_friend.dart';

class FriendProfilePage extends StatefulWidget {
  String nickname;
  String bio;
  XFile profileImage;

  FriendProfilePage(
      {Key? key,
      required this.nickname,
      required this.bio,
      required this.profileImage})
      : super(key: key);

  @override
  State<FriendProfilePage> createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  bool _isFollowing = true; // Add a state for follow button toggle

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 4;

    return SafeArea(
        child: DefaultTabController(
        length: 3,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  SizedBox(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 28,
                    ),
                  ),
                  const Text(
                    '팔로잉 목록',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(height: 2, color: Colors.purple),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Add a method to view the full-size profile image, if needed
                    },
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: imageSize,
                        minWidth: imageSize,
                      ),
                      child: widget.profileImage == null
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
                                    color: Colors.purple,
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(widget.profileImage as String),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            createColumns('following', 150),
                            createColumns('followers', 271),
                          ],
                        ),
                        const SizedBox(height: 10),
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isFollowing =
                                      !_isFollowing; // Toggle the follow button
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: _isFollowing
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                              ),
                              child: Text(
                                _isFollowing ? 'Following' : 'Follow',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ChatWithFriend(2)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: const Text(
                                'Message',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.nickname,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                widget.bio,
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
      Expanded(
        child: TabBarView(
          children: [
            const TableCalendarScreen(),
            // Container(
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
            ListView.builder(
                key: const PageStorageKey("피드"),
                itemCount: 1000,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        "List View $index",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.accents[index % 15],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),

            Container(
              width: 10,
              color: const Color.fromRGBO(91, 91, 91, 1),
              child: const Center(
                child: Text(
                  '지도',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),),
      ],
      ),
    ),
        ),
    );
  }

  void _navigateToProfileEditPage(BuildContext context) async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditPage(
          nickname: widget.nickname,
          bio: widget.bio,
          pickedFile: widget.profileImage.path,
        ),
      ),
    );

    // if (updatedData != null) {
    //   setState(() {
    //     _nickname = updatedData['nickname'];
    //     _bio = updatedData['bio'];
    //     _pickedFile = updatedData['pickedFile'];
    //   });
    // }
  }

  Column createColumns(String title, int count) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black45,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }
}
