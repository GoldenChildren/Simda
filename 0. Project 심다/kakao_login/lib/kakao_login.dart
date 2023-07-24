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
          print('카카오계정으로 로그인 성공 ${token.accessToken}');
          return true;
        } catch(e) {
          print('카카오계정으로 로그인 실패1 $e');
          return false;
        }
      } else {
        print("실행2");
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print(token);
          var actoken = token.accessToken;

          // print('카카오계정으로 로그인 성공 ${token.accessToken}');
          String url = 'http://localhost:9090/user/login/kakao';
          // final response = await http.get(url);

          final response = await http.post(Uri.parse(url), body: {'access_token': actoken});

          // print('Response status: ${response.statusCode}');
          // print('Response body: ${response.body}');
          //
          print(response);

          // print('Response status: ${response.statusCode}');
          // print('Response body: ${response.body}');

          await AuthCodeClient.instance.authorize(
            redirectUri: url,
          );


          return true;
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