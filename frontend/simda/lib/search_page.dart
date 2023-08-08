import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simda/following_list.dart';
import 'package:simda/friend_profile.dart';
import 'package:simda/models/UserDto.dart';
import 'package:simda/providers/user_providers.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
  _SearchPageState() {
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
      final userList = await userProviders.getUsers(_searchText);
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

  // 검색 결과를 보여주는 함수
  // Future<void> _fetchData() async {
  //   final url = Uri.parse(
  //       'http://i9a709.p.ssafy.io:8000/user/search?nickname=$_searchText');
  //   final response = await http.get(url);
  //
  //   if (response.statusCode == 200) {
  //     // API 호출이 성공한 경우
  //     final responseData = response.body;
  //     final Map<String, dynamic> jsonResponse = jsonDecode(responseData);
  //
  //     if (jsonResponse.containsKey('userList') &&
  //         jsonResponse['userList'] is List) {
  //       final List<dynamic> userListJson = jsonResponse['userList'];
  //
  //       _userList =
  //           userListJson.map((json) => UserDto.fromJson(json)).toList();
  //
  //     }
  //   } else if (response.statusCode == 404) {
  //     setState(() {
  //       _userList = [];
  //     });
  //   } else {
  //     // API 호출이 실패한 경우(404 이외의 오류)
  //     if (kDebugMode) {
  //       print('Failed to fetch data: ${response.statusCode}');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(30)),
        Container(
          color: Colors.green,
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: TextField(
                  focusNode: focusNode,
                  style: const TextStyle(fontSize: 15),
                  autofocus: true,
                  controller: _filter,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white60,
                      size: 20,
                    ),
                    suffixIcon: focusNode.hasFocus
                        ? IconButton(
                            icon: const Icon(
                              Icons.cancel,
                              size: 20,
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
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),
              focusNode.hasFocus
                  ? Expanded(
                      child: TextButton(
                        child: const Text('취소'),
                        onPressed: () {
                          setState(() {
                            _filter.clear();
                            _searchText = "";
                            focusNode.unfocus();
                          });
                        },
                      ),
                    )
                  : Expanded(flex: 0, child: Container()),
            ],
          ),
        ),

        // nickname이 비어있지 않으면 결과를 출력
        _userList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: _userList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage(_userList[index].profileImg),
                    ),
                    title: Text(_userList[index].nickname),
                    onTap: () {
                      UserDto user = _userList[index]; // user의 정보들을 넘기지 않고, userDto를 넘기면 될 것 같은데?
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendProfilePage(
                            userDto: user,
                            // userId: user.userId,
                            // nickname: user.nickname,
                            // bio: user.bio,
                            // profileImage: user.profileImg,
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            : Text('결과 없음'), // 닉네임이 빈 경우 결과 없음을 출력
      ],
    );
  }
}
