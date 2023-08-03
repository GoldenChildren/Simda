import 'dart:convert';

import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:simda/KakaoLogin/social_login.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class KakaoLogin implements SocialLogin {
  static String email = "";
  static String ip = "http://i9a709.p.ssafy.io:8000";
  @override
  Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      if(isInstalled) {
        print("실행1");
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          print('카카오계정으로 로그인 성공1 ${token.accessToken}');
          return true;
        } catch(e) {
          print('카카오계정으로 로그인 실패1 $e');
          return false;
        }
      } else {
        print("실행2");
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          var actoken = token.accessToken;
          var retoken = token.refreshToken;
          print(actoken);
          print(retoken);

          final url = Uri.parse("$ip/user/login/kakao");
          final response = await http.post(url,
              headers: {"Content-Type": "application/json"},
              body:json.encode({
                'accessToken': actoken,
                // 'socialType' : retoken,
              }));

          print(response);
          if(response.statusCode == 200) {
            print("로그인 성공!");
            return true;
          } else if(response.statusCode == 404) {
            print("회원가입 필요!");
            email = response.body;
            print(email);
            return true;
          }

          print("뭔가 오류가 있다");
          return false;
        } catch(e) {
          print(e);
          return false;
        }
      }
    } catch(e) {
      return false;
    }
  }



  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch(error) {
      return false;
    }
  }

  @override
  Future<bool> signup(String path, String nickname) async {
    print('회원가입');
    try {
      Dio dio = Dio();
      var url = "$ip/user/";

      FormData formData = FormData.fromMap({
        'profileImg': await MultipartFile.fromFile(path, filename: 'profile_img.jpg'),
        'nickname': nickname,
        'email': email,
      });

      Response response = await dio.post(
          url,
          data: formData
      );

      print(response.data);
      // await http.post(url,
      //     headers: {"Content-Type": "application/json"},
      //     body:json.encode({
      //       'nickname': nickname,
      //       'email': email,
      //     }));
      print('회원가입 성공!');
      return true;
    } catch(error) {
      return false;
    }
  }

}
