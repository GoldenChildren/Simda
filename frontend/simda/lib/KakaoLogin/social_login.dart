abstract class SocialLogin {
  Future<bool> login();
  Future<bool> logout();
  Future<bool> signup(String path, String nickname);
}
