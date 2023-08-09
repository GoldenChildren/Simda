import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simda/providers/user_providers.dart';
import 'informaion_policy.dart';
import 'location_service_policy.dart';
import 'main.dart';
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
  String _profileImg = "";
  String _nickname = "";
  String _bio = "";
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    getValueFromSecureStorage();
  }

  Future<void> getValueFromSecureStorage() async {
    try {
      String? storeProfileImg = await storage.read(key: "profileImg");
      String? storeNickname = await storage.read(key: "nickname");
      String? storeBio = await storage.read(key: "bio");
      int storeUserId = int.parse((await storage.read(key: "userId"))!);
      setState(() {
        _profileImg = storeProfileImg ?? "";
        _nickname = storeNickname ?? "";
        _bio = storeBio ?? "";
        _userId = storeUserId;
      });
    } catch (e) {
      print("Error reading from secure storage: $e");
    }
  }

  UserProviders userProvider = UserProviders();

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
                      style:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      _navigateToProfileEditPage(context);
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
              // const SizedBox(
              //   height: 20,
              // ),

              // Container(
              //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              //   alignment: Alignment.center,
              //   child: const Image(image: AssetImage('assets/images/promap.PNG')),
              // )
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
                  children: [
                    TableCalendarScreen(),
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
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/shin.jpg'),
                    backgroundColor: Colors.white,
                  ),
                  accountName: const Text('SHIN'),
                  accountEmail: const Text('shin@ssafy.com'),
                  decoration: BoxDecoration(
                      color: Colors.purple[200],
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
                          content: const Text('simda@gmail.com 으로 문의주세요!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Clipboard.setData(const ClipboardData(
                                    text: "simda@gmail.com"));
                                Navigator.of(context).pop(); // 다이얼로그를 닫음
                              },
                              child: const Text("복사하기"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("알겠습니다."),
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
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileEditPage(
          // nickname: _nickname,
          // bio: _bio,
          // pickedFile: _pickedFile,
        ),
      ),
    );

    if (updatedData != null) {
      setState(() {
        _nickname = updatedData['nickname'];
        _bio = updatedData['bio'];
        _profileImg = updatedData['profileImg'];
      });
    }
  }

  void _navigateToFollowingListPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const FollowingListPage(userList: [],), // FollowingListPage는 팔로잉 목록을 보여주는 새로운 페이지입니다.
      ),
    );
  }

  void _navigateToFollowersListPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const FollowersListPage(userList: [],), // FollowersListPage는 팔로워 목록을 보여주는 새로운 페이지입니다.
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
