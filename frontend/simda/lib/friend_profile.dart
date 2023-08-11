import 'package:flutter/material.dart';
import 'package:simda/main.dart';
import 'package:simda/models/UserDto.dart';
import 'package:simda/profile_map.dart';
import 'package:simda/providers/user_providers.dart';
import 'friend_profile_calendar.dart';
import 'friend_profile_feed.dart';
import 'profile_calendar.dart';
import 'chat_with_friend.dart';

class FriendProfilePage extends StatefulWidget {
  UserDto userDto;

  FriendProfilePage({Key? key, required this.userDto}) : super(key: key);

  @override
  State<FriendProfilePage> createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  bool _isFollowing = false; // Add a state for follow button toggle
  List<UserDto> _followList = [];
  List<UserDto> _followerList = [];
  UserProviders userProvider = UserProviders();
  int loginUserId = 0;

  @override
  void initState() {
    super.initState();
    _fetchFollowData();
  }

  Future<void> _fetchFollowData() async {
    try {
      List<UserDto> followingList =
          await userProvider.getFollowData("followings", widget.userDto.userId);
      List<UserDto> followerList =
          await userProvider.getFollowData("followers", widget.userDto.userId);
      loginUserId =
          int.parse((await storage.read(key: 'userId'))!); // 현재 로그인한 유저의 아이디
      _isFollowing =
          await userProvider.followCheck(loginUserId, widget.userDto.userId);

      setState(() {
        _followList = followingList;
        _followerList = followerList;
      });
    } catch (e) {
      print("Error fetching follow data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    int followCnt = _followList.length;
    int followerCnt = _followerList.length;

    final imageSize = MediaQuery.of(context).size.width / 4;

    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
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
                    Text(
                      widget.userDto.nickname,
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        child: widget.userDto.profileImg == null
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
                                      image: NetworkImage(
                                          widget.userDto.profileImg),
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
                              createColumns('following', followCnt),
                              createColumns('followers', followerCnt),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (_isFollowing) {
                                    await userProvider.deleteFollowUser(
                                        loginUserId, widget.userDto.userId);
                                    setState(() {
                                      _isFollowing = false;
                                    });
                                  } else {
                                    await userProvider.createFollowUser(
                                        loginUserId, widget.userDto);
                                    setState(() {
                                      _isFollowing = true;
                                    });
                                  }
                                  await _fetchFollowData();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: _isFollowing
                                      ? Colors.grey
                                      : Theme.of(context).primaryColor,
                                ),
                                child: Text(
                                  _isFollowing ? 'unFollow' : 'Follow',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ChatWithFriend(2)),
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
                          widget.userDto.nickname,
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
                  widget.userDto.bio ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const TabBar(
                  indicatorColor: Colors.purple,
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
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    FriendProfileCalendarPage(widget.userDto.userId),
                    FriendProfileFeedPage(widget.userDto.userId),
                    const ProfileMapPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
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
