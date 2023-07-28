abstract class SocialLogin {
  Future<int> login();

  Future<bool> logout();

  Future<bool> signup(String path, String nickname);
}
