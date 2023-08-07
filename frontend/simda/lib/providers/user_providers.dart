import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simda/models/UserDto.dart';
import 'package:dio/dio.dart';

import '../main.dart';


class UserProviders {
  final storage = const FlutterSecureStorage();

  Dio dio = Dio();

  String url = "http://i9a709.p.ssafy.io:8000/user";

  // 세션 스토리지에 유저 정보를 저장하는 메소드
  Future<void> saveStorage(Map<String, dynamic> map) async {
    print(map);
    print("정보받아보자 : " + map["email"]);

    map.forEach((key, value) {
      if (value is String) {
        storage.write(key: key, value: value);
      } else {
        String stringValue = json.encode(value);
        storage.write(key: key, value: stringValue);
      }
    });
    print(map);
  }

  // 회원 탈퇴
  void deleteUser(int userId) async {
    final response = await dio.put('$url/$userId');

    if (response.statusCode == 200) {
      print("Success!");
    }
  }

  // 닉네임 체크
  Future<bool> checkNickName(String nickName) async{
    final response = await dio.get('$url/check');

    print('닉네임 중복? : $response');

    return response.data;
  }

  // 회원 정보를 수정한다.
  Future<UserDto> modifyUser(String path, UserDto userDto) async {
    try {
      FormData formData = FormData.fromMap({
        'imgfile': await MultipartFile.fromFile(path, filename: 'modified'),
        "bio": userDto.bio,
        "email": userDto.email,
        "nickname": userDto.nickname,
        "profileImg": userDto.profileImg,
        "userId": userDto.userId,
        "userRole": userDto.userRole,
      });

      var response = await dio.post(
        "$url/modify",
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if(response != null){
        saveStorage(response.data);
      }

      return json.decode(response.data);
    }catch(error){
      print("유저 정보 수정 에러");
      print(error);
    }
    return userDto;
  }

  // userId로 해당 유저의 프로필을 가져오는 메소드
  Future<UserDto> getUser(int userId) async{
    UserDto userDto;
    Response response = await dio.get(
        '$url/profile',
      queryParameters: {
          'userId' : userId
      }
    );
    userDto = json.decode(response.data);

    print('유저 프로필 가져오기 : $userDto');

    return userDto;
  }

}
