import 'package:flutter/material.dart';
import 'package:simda/friend_profile.dart';
import 'package:simda/models/ChatUserDto.dart';
import 'package:simda/models/UserDto.dart';
import 'package:simda/providers/user_providers.dart';

import 'chat_with_friend.dart';
import 'main.dart';
import 'main_page.dart';

class ChattingSearchPage extends StatefulWidget {
  const ChattingSearchPage({super.key});

  @override
  State<ChattingSearchPage> createState() => _ChattingSearchPageState();
}

class _ChattingSearchPageState extends State<ChattingSearchPage> {
  int _userId = 0;
  late ChatUserDto me;
  @override
  void initState() {
    super.initState();
    getValueFromSecureStorage();
  }

  Future<void> getValueFromSecureStorage() async {
    try {
      int storeUserId = int.parse((await storage.read(key: "userId"))!);
      String storeNickname = await storage.read(key: "nickname").toString();
      String storeProfileImg = await storage.read(key: "profileImg").toString();
      setState(() {
        _userId = storeUserId;
        me = ChatUserDto(
          userId: storeUserId.toString(),
          nickname: storeNickname,
          profileImg: storeProfileImg,
        );
      });
    } catch (e) {
      print("Error reading from secure storage: $e");
    }
  }

  // Text 컨트롤 위젯
  final TextEditingController _filter = TextEditingController();

  // 커서의 상태 관리
  FocusNode focusNode = FocusNode();

  // 검색어
  String _searchText = "";

  // 응답 리스트로 저장
  List<UserDto> _userList = [];

  UserProviders userProviders = UserProviders();

  // SearchPage에 대한 상태관리
  _ChattingSearchPageState() {
    _filter.addListener(() {
      // filter가 상태를 상태 변화를 감지
      setState(() {
        _searchText = _filter.text;
      });
      _fetchData(); // 입력 변경 시 API 호출
    });
  }

  // getUsers 메서드를 사용하여 API 데이터 가져오기
  Future<void> _fetchData() async {
    if (_searchText.isNotEmpty) {
      final userList = await userProviders.getUsers(_searchText); // 바꿔줘야함
      setState(() {
        _userList = userList;
      });
    } else {
      setState(() {
        print("빈값 주나");
        _userList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
            child: Row(
              children: <Widget>[
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
                Expanded(
                  flex: 7,
                  child: TextField(
                    cursorColor: Colors.black54,
                    focusNode: focusNode,
                    style: const TextStyle(fontSize: 15),
                    autofocus: true,
                    controller: _filter,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black45,
                        size: 28,
                      ),
                      suffixIcon: focusNode.hasFocus
                          ? IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                size: 23,
                                color: Colors.black45,
                              ),
                              onPressed: () {
                                setState(() {
                                  _filter.clear();
                                  _searchText = "";
                                });
                              },
                            )
                          : Container(),
                      hintText: "검색",
                      labelStyle: const TextStyle(color: Colors.white),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  ),
                ),
                Expanded(flex: 0, child: Container()),
              ],
            ),
          ),
          // nickname이 비어있지 않으면 결과를 출력
          _userList.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _userList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                NetworkImage(_userList[index].profileImg),
                          ),
                          title: Text(_userList[index].nickname),
                          onTap: () {
                            // UserDto user = _userList[
                            //     index]; // user의 정보들을 넘기지 않고, userDto를 넘기면 될 것 같은데?
                            ChatUserDto contact= ChatUserDto(
                                userId: _userList[index].userId.toString(),
                                nickname: _userList[index].nickname,
                                profileImg: _userList[index].profileImg
                            );
                            contact.userId == _userId
                                ? Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainPage(4)),
                                    (route) => false)
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatWithFriend(
                                        contact: contact,
                                        me : me,
                                      ),
                                    ),
                                  );
                          },
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: const Text('결과 없음')), // 닉네임이 빈 경우 결과 없음을 출력
        ],
      )),
    );
  }
}
