import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simda/models/UserDto.dart';
import 'package:simda/providers/user_providers.dart';
import 'informaion_policy.dart';
import 'location_service_policy.dart';
import 'main.dart';
import 'models/UserDto.dart';
import 'profile_edit_page.dart';
import 'KakaoLogin/kakao_login.dart';
import 'KakaoLogin/login_page.dart';
import 'package:simda/KakaoLogin/main_view_model.dart';
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
  String _email = "";
  String _profileImg = "";
  String _nickname = "";
  String _bio = "";
  int _userId = 0;
  int _followCount = 0;
  int _followerCount = 0;
  List<UserDto> _followList = [];
  List<UserDto> _followerList = [];
  UserProviders userProvider = UserProviders();

  @override
  void initState() {
    super.initState();
    getValueFromSecureStorage();
  }

  Future<void> getValueFromSecureStorage() async {
    try {
      String? storeEmail = await storage.read(key: "email");
      String? storeProfileImg = await storage.read(key: "profileImg");
      String? storeNickname = await storage.read(key: "nickname");
      String? storeBio = await storage.read(key: "bio");
      int storeUserId = int.parse((await storage.read(key: "userId"))!);

      List<UserDto>? followings =
      await userProvider.getFollowData("followings", storeUserId);
      List<UserDto>? followers =
      await userProvider.getFollowData("followers", storeUserId);

      setState(() {
        _email = storeEmail ?? "";
        _profileImg = storeProfileImg ?? "";
        _nickname = storeNickname ?? "";
        _bio = storeBio ?? "";
        _userId = storeUserId;
        _followList = followings;
        _followerList = followers;
        _followCount = followings?.length ?? 0;
        _followerCount = followers?.length ?? 0;
      });
    } catch (e) {
      print("Error reading from secure storage: $e");
    }
  }


  final viewModel = MainViewModel(KakaoLogin());

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
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _nickname,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Builder(
                      builder: (context) => IconButton(
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: const Icon(Icons.menu),
                        iconSize: 28,
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 2, color: Colors.purple),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StatefulBuilder(builder:
                                  (BuildContext context,
                                  StateSetter setState) {
                                return const ProfileEditPage();
                              })));
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      constraints: BoxConstraints(
                        minHeight: imageSize,
                        minWidth: imageSize,
                      ),
                      child: _profileImg == ""
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
                              image: NetworkImage(_profileImg),
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
                                _navigateToFollowingList(
                                  context,
                                  _followList,
                                ); // 팔로잉 숫자를 누르면 팔로잉 목록 페이지로 이동
                              },
                              child: createColumns('following', _followCount),
                            ),
                            GestureDetector(
                              onTap: () {
                                _navigateToFollowersListPage(context,
                                    _followerList); // 팔로워 숫자를 누르면 팔로워 목록 페이지로 이동
                              },
                              child: createColumns('followers', _followerCount),
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
              // const SizedBox(
              //   height: 20,
              // ),

              // Container(
              //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              //   alignment: Alignment.center,
              //   child: Image(image: NetworkImage(_profileImg)),
              // ),
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
              const Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ProfileCalendarPage(),
                    ProfileFeedPage(),
                    ProfileMapPage(),
                  ],
                ),
              ),
            ],
          ),
          endDrawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(_profileImg),
                    backgroundColor: Colors.white,
                  ),
                  accountName: Text(_nickname),
                  accountEmail: Text(_email),
                  decoration: BoxDecoration(
                      color: Colors.purple[400],
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0))),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout_outlined,
                    color: Colors.blueGrey,
                  ),
                  title: const Text('로그아웃'),
                  onTap: () async {
                    await viewModel.logout();
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.question_mark_outlined,
                    color: Colors.blueGrey,
                  ),
                  title: const Text('문의하기'),
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('SIMDA에 문의사항이 있으십니까?'),
                          content: const Text('simda709@gmail.com 으로 문의주세요!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Clipboard.setData(const ClipboardData(
                                    text: "simda709@gmail.com"));
                                Navigator.of(context).pop(); // 다이얼로그를 닫음
                              },
                              child: const Text("복사하기"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("닫기"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_forever,
                    color: Colors.blueGrey,
                  ),
                  title: const Text('탈퇴하기'),
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('회원 탈퇴 하시겠습니까?'),
                          content: const Text('정말요? 가지마요~~~'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                userProvider.deleteUser(_userId);
                                if (!mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              },
                              child: const Text("탈퇴하기"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("취소하기"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ), ListTile(
                  leading: const Icon(
                    Icons.info,
                    color: Colors.blueGrey,
                  ),
                  title: const Text('개인정보처리방침'),
                  onTap: () async {
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InformationPolicy()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Colors.blueGrey,
                  ),
                  title: const Text('위치기반서비스이용약관'),
                  onTap: () async {
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LocationServicePolicy()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToProfileEditPage(BuildContext context) async {
    final updatedData = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ProfileEditPage()))
        .then((value) {
      setState(() {});
    });

    if (updatedData != null) {
      setState(() {
        _nickname = updatedData['nickname'];
        _bio = updatedData['bio'];
        _profileImg = updatedData['profileImg'];
      });
    }
  }

  void _navigateToFollowingList(BuildContext context, List<UserDto> userList) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FollowingListPage(userList: userList), // FollowingListPage는 팔로잉 목록을 보여주는 새로운 페이지입니다.
      ),
    );
  }

  void _navigateToFollowersListPage(
      BuildContext context, List<UserDto> userList) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FollowersListPage(userList: userList), // FollowersListPage는 팔로워 목록을 보여주는 새로운 페이지입니다.
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
