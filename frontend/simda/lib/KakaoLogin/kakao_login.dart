import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:simda/KakaoLogin/social_login.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:simda/Session.dart';
import 'package:simda/models/UserDto.dart';

class KakaoLogin implements SocialLogin {
  final storage = const FlutterSecureStorage();
  final session = Session();

  // static String email = "";
  // static String ip = "http://70.12.247.215:8000";
  static String ip = "http://i9a709.p.ssafy.io:8000";

  Future<void> saveStorage(Map<String, dynamic> map) async {
    // print(userDto);
    // Map<String, dynamic> map = jsonDecode(userDto);
    // print(map);
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

  @override
  Future<int> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      if (isInstalled) {
        print("실행1");
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          print('카카오계정으로 로그인 성공1 ${token.accessToken}');
          return 1;
        } catch (e) {
          print('카카오계정으로 로그인 실패1 $e');
          return -1;
        }
      } else {
        print("실행2");
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          var actoken = token.accessToken;
          var retoken = token.refreshToken;
          print(actoken);
          print(retoken);

          session.saveAccessToken(token);

          final url = Uri.parse("$ip/user/login/kakao");
          final response = await http.post(url,
              headers: {"Content-Type": "application/json"},
              body: json.encode({
                'accessToken': actoken,
                // 'socialType' : retoken,
              }));

          print(response);
          saveStorage(jsonDecode(response.body));
          if (response.statusCode == 200) {
            print("로그인 성공!");
            return 1;
          } else if (response.statusCode == 202) {
            print("회원가입 필요!");
            // email = response.body;
            // print(email);
            return 0;
          }

          print("뭔가 오류가 있다");
          return -1;
        } catch (e) {
          print(e);
          return -1;
        }
      }
    } catch (e) {
      return -1;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      storage.write(key: "email", value: "");
      storage.write(key: "nickname", value: "");
      storage.write(
          key: "profileImg",
          value:
              "https://simda.s3.ap-northeast-2.amazonaws.com/img/profile/noimg.jpg");
      session.logout();
      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> signup(String path, String nickname) async {
    print('회원가입');
    try {
      Dio dio = Dio();
      var url = "$ip/user/";

      String? email = await storage.read(key: "email");

      UserDto userDto = UserDto(
          bio: '',
          userId: 0,
          email: email ?? '',
          nickname: nickname,
          profileImg: '',
          userRole: 0);

      FormData formData = FormData.fromMap({
        'imgfile': await MultipartFile.fromFile(path, filename: 'profile.jpg'),
        'email': userDto.email,
        'nickname': userDto.nickname,
      });

      Response response = await dio.post(
        url,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      // print(response.data);

      saveStorage(response.data);
      String? storeUid = await storage.read(key:"userId");
      String? storeEmail = await storage.read(key: "email");
      String? storeProfileImg = await storage.read(key: "profileImg");
      String? storeNickname = await storage.read(key: "nickname");
      print("여기야");
      print(response.data);
      DatabaseReference ref = FirebaseDatabase.instance.ref("users").child(storeUid!);
      await ref.set({
        "nickname": storeNickname,
        "userEmail" : storeEmail,
        "profileImg": storeProfileImg,
      });

      print('회원가입 성공!');
      return true;
    } catch (error) {
      print("회원가입 에러");
      print(error);
      return false;
    }
  }
}
