import 'dart:convert';

import 'package:simda/map_page.dart';
import 'package:simda/models/UserDto.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import '../main.dart';


class UserProviders {

  // Uri uri = Uri.parse("");

  void deleteUser(int userId) async {
    String uri = "http://i9a709.p.ssafy.io:8000/user/";
    uri += "$userId";

    final response = await http.put(Uri.parse(uri));

    if (response.statusCode == 200) {
      print("Success!");
    }
  }

  Future<String> modifyUser(UserDto userDto) async {
    Dio dio = Dio();
    // var response =
    // await http.put(Uri.parse("http://i9a709.p.ssafy.io:8000/user/${userDto.userId}"),
    //     headers: {"Content-Type": "application/json"},
    //     body: json.encode({
    //       "bio": userDto.bio,
    //       "email": userDto.email,
    //       "nickname": userDto.nickname,
    //       "profileImg": userDto.profileImg,
    //       "userId": userDto.userId,
    //       "userRole": userDto.userRole,
    //     }));

    var url = "http://i9a709.p.ssafy.io:8000/user/${userDto.userId}";

    FormData formData = FormData.fromMap({
      "bio": userDto.bio,
      "email": userDto.email,
      "nickname": userDto.nickname,
      "profileImg": userDto.profileImg,
      "userId": userDto.userId,
      "userRole": userDto.userRole,
    });
    var response = await dio.post(url,
        data: formData,
    options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );

    return response.data;
  }
}
