import 'dart:convert';

import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_login/social_login.dart';
import 'package:http/http.dart' as http;

class KakaoLogin implements SocialLogin {
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

          final url = Uri.parse("http://70.12.247.165:9090/user/login/kakao");
          final response = await http.post(url,
              headers: {"Content-Type": "application/json"},
              body:json.encode({
                'accessToken': actoken,
                // 'socialType' : retoken,
              }));

          print(response.statusCode);
          if(response.statusCode == 200) {
            print("로그인 성공!");
            return true;
          } else if(response.statusCode == 404) {
            print("회원가입으로 이동!");
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

}