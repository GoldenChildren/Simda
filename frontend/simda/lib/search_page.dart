import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simda/models/UserDto.dart';

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

  // 응답 저장
  String _nickname = "";

  // 프로필 이미지 저장
  String _profileImg = "";

  // 프로필 이미지 저장
  String _userId = "";

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

  // 검색 결과를 보여주는 함수
  Future<void> _fetchData() async {
    final url = Uri.parse(
        'http://i9a709.p.ssafy.io:8000/user/search?nickname=$_searchText');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // API 호출이 성공한 경우
      final responseData = response.body;
      final Map<String, dynamic> jsonResponse = jsonDecode(responseData);

      if (jsonResponse.containsKey('userList') &&
          jsonResponse['userList'] is List) {
        final List<dynamic> userListJson = jsonResponse['userList'];

        final userList =
            userListJson.map((json) => UserDto.fromJson(json)).toList();

        if (userList.isNotEmpty) {
          setState(() {
            _nickname = userList.map((user) => user.nickname).join(', ');
            _profileImg = userList.map((user) => user.profileImg).join(', ');
            _userId = userList.map((user) => user.userId).join(', ');
          });
        }
      }
    } else if (response.statusCode == 404) {
      setState(() {
        _nickname = '검색 결과가 없습니다'; // 404 오류일 경우 결과 없음 메시지 표시
      });
    }
    else {
      // API 호출이 실패한 경우(404 이외의 오류)
      if (kDebugMode) {
        print('Failed to fetch data: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> ulist = _nickname.split(', ');
    List<String> plist = _profileImg.split(', ');

    return Column(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(30)),
        Container(
          color: Colors.black,
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
        ulist.isNotEmpty
            ? ListView.builder(
          shrinkWrap: true,
          itemCount:ulist.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(plist[index]),
              ),
              title: Text(ulist[index]),
            );
          },
        )
            : Text('결과 없음'),
      ],
    );
  }
}
