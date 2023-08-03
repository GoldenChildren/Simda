import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:simda/KakaoLogin/social_login.dart';

class MainViewModel {
  final SocialLogin _socialLogin;
  int isLoggedIn = -1;
  User? user;

  MainViewModel(this._socialLogin);

  Future login() async {
    isLoggedIn = await _socialLogin.login();
    if (isLoggedIn == 1) {
      user = await UserApi.instance.me();
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    isLoggedIn = -1;
    user = null;
  }

  Future signup(String path, String nickname) async {
    await _socialLogin.signup(path, nickname);
  }
}
