import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simda/models/FollowDto.dart';
import 'package:simda/models/UserDto.dart';
import 'package:dio/dio.dart';

import '../main.dart';


class UserProviders {
  final storage = const FlutterSecureStorage();

  Dio dio = Dio();

  String url = "http://i9a709.p.ssafy.io:8000/user";
  // String url = "http://70.12.247.215:8000/user";
  // static String ip = "http://70.12.247.165:8000";

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
  Future<bool> checkNickname(String nickname) async{
    final response = await dio.get('$url/check');

    print('닉네임 중복? : $response');

    return response.data;
  }
  // 유저 체크
  Future<int> checkUser(String email) async{
    storage.write(key: "email", value: email);
    try{
      final response = await dio.get('$url/email?email=$email');
      return 1;
    }catch (Exception) {
      return -1;
    }
  }

  // 회원 정보를 수정한다.
  Future<UserDto> modifyUser(String path, UserDto userDto) async {
    try {
      MultipartFile? multipartfile;

      print('path : $path');

      if(path.isNotEmpty){
        multipartfile = await MultipartFile.fromFile(path, filename: 'modified');
      }else{
        multipartfile = null;
      }

      print(multipartfile?.filename?? '왜 null 임?');

      FormData formData = FormData.fromMap({
        'imgfile': multipartfile,
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

      return UserDto.fromJson(response.data);
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


// 검색하는 로직
  Future<List<UserDto>> getUsers(String check) async {
    final response = await dio.get('$url/search?nickname=$check');
    final List<UserDto> userList = [];

    if (response.statusCode == 200) {
      // API 호출이 성공한 경우
      final Map<String, dynamic> jsonResponse = response.data;

      if (jsonResponse.containsKey('userList') &&
          jsonResponse['userList'] is List) {
        final List<dynamic> userListJson = jsonResponse['userList'];

        for (var userJson in userListJson) {
          var userDto = UserDto.fromJson(userJson);
          userList.add(userDto);
        }
      }
    }
    else if (response.statusCode == 204) {
      // 검색 결과 없음
      userList.clear();
      return userList;
    }
    else {
      // API 호출이 실패한 경우(204 이외의 오류)

      if (kDebugMode) {
        print('Failed to fetch data: ${response.statusCode}');
      }
    }
    return userList;
  }

  // ---------------- 팔로우 기능 -----------------
  Future<List<UserDto>> getFollowData(String endpoint, int userId) async {
    final response = await dio.get('$url/$endpoint?userId=$userId');
    final List<UserDto> userList = [];

    if (response.statusCode == 200) {
      // API 호출이 성공한 경우
      final Map<String, dynamic> jsonResponse = response.data;

      if (jsonResponse.containsKey('userList') &&
          jsonResponse['userList'] is List) {
        final List<dynamic> userListJson = jsonResponse['userList'];

        for (var userJson in userListJson) {
          var userDto = UserDto.fromJson(userJson);
          userList.add(userDto);
        }
      }
    } else if (response.statusCode == 204) {
      // 검색 결과 없음
      userList.clear();
    } else {
      // API 호출이 실패한 경우(204 이외의 오류)
      if (kDebugMode) {
        print('Failed to fetch data: ${response.statusCode}');
      }
    }
    return userList;
  }

  Future<bool> followCheck(int fromUserId, int toUserId) async {
    final response = await dio.get('$url/followcheck?fromUserId=$fromUserId&toUserId=$toUserId');
    bool check = false;

    if (response.statusCode == 200) {
      check = true;
    }
    return check;
  }

  Future<void> deleteFollowUser(int fromUserId, int toUserId) async{
    final response = await dio.delete('$url/followers?fromUserId=$fromUserId&toUserId=$toUserId');
  }

  Future<void> createFollowUser(int fromUserId, UserDto toUserDto) async{
    // userId만 집어넣어서 찾을 수 있을까?
    final fromUserDtoResponse = await dio.get('$url/profile?userId=$fromUserId');
    print(fromUserDtoResponse.statusCode);

    if (fromUserDtoResponse.statusCode == 200) {
      final fromUserDto = UserDto.fromJson(fromUserDtoResponse.data);
      print(fromUserDto.nickname);
      print(toUserDto.nickname);

      final followDto = FollowDto(
        fromUserId: fromUserDto,
        toUserId: toUserDto,
      );

      final response = await dio.post('$url/followers', data: followDto,
          options: Options(contentType: 'application/json'));
    } else {
      print("안돼");
    }
  }
}
