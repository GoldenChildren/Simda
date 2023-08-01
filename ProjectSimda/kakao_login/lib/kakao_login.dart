import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_login/social_login.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class KakaoLogin implements SocialLogin {
  final storage = new FlutterSecureStorage();

  // static String email = "";

  // cmd -> ipconfig -> IPv4 복사
  static String ip = "http://i9a709.p.ssafy.io:8080/";

  Future<void> saveStorage(String userDto) async {
    Map<String, dynamic> map = jsonDecode(userDto);
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
  }

  @override
  Future<int> login() async {
    // 로그인 성공, 회원가입 되어있는 경우 = 1 | 로그인 성공, 회원가입 실패한 경우 0 | 로그인 실패 -1
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

          final url = Uri.parse("http://i9a709.p.ssafy.io:8080/user/login/kakao");
          final response = await http.post(url,
              headers: {"Content-Type": "application/json"},
              body: json.encode({
                'accessToken': actoken,
              }));
          saveStorage(response.body);

          print(response);
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
      storage.delete(key: "email");
      storage.delete(key: "nickname");
      storage.delete(key: "profileImg");
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
      var url = ip + "/user/";

      String? email = await storage.read(key: "email");

      FormData formData = FormData.fromMap({
        'profileImg':
            await MultipartFile.fromFile(path, filename: 'profile_img.jpg'),
        'nickname': nickname,
        'email': email,
      });

      Response response = await dio.post(url, data: formData);

      saveStorage(response.data);

      print(response.data);
      print('회원가입 성공!');
      return true;
    } catch (error) {
      return false;
    }
  }
}
