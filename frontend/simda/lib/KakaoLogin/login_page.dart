import 'package:flutter/material.dart';
import 'package:simda/KakaoLogin/sign_up.dart';
import 'package:simda/main.dart';
import 'package:simda/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String email = "";
  String profileImg =
      "https://simda.s3.ap-northeast-2.amazonaws.com/img/profile/noimg.jpg";
  String nickname = "";
  String bio = "";

  @override
  void initState() {
    super.initState();
    getValueFromSecureStorage();
  }

  Future<void> getValueFromSecureStorage() async {
    try {
      String? storeEmail = await storage.read(key: "email");
      String? storeProfileImg = await storage.read(key: "profileImg");
      String? storeNickname = await storage.read(key: "nickname");
      String? storeBio = await storage.read(key: "bio");
      setState(() {
        email = storeEmail ?? "";
        profileImg = storeProfileImg ??
            "https://simda.s3.ap-northeast-2.amazonaws.com/img/profile/noimg.jpg";
        nickname = storeNickname ?? "";
        bio = storeBio ?? "";
      });
    } catch (e) {
      print("Error reading from secure storage: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
                image: AssetImage('assets/images/1152.png'), height: 150),
            const SizedBox(height: 20),
            const Image(
                image: AssetImage('assets/images/simda.png'), height: 40),
            const SizedBox(height: 50),
            // Image.network(
            //     viewModel.user?.kakaoAccount?.profile?.profileImageUrl ?? ''),
            Text(nickname),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await viewModel.login();
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const MainPage()), (route) => false
                // );
                setState(() {});
                if (!mounted) return;
                // 화면 이동
                if (viewModel.isLoggedIn == 0) {
                  print('회원가입 화면으로 이동합니다.');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                }
                // 카카오 로그인 오류
                else if (viewModel.isLoggedIn == -1) {
                  print('카카오 로그인 오류');
                }
                else {
                  print('로그인 성공');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainPage(0)), (route) => false
                  );
                }

                getValueFromSecureStorage();
              },
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: const Image(
                      image: AssetImage(
                          'assets/images/kakao_login_large_wide.png'))),
            ),

            Text(
              '${viewModel.isLoggedIn}',
            ),

            ElevatedButton(
              onPressed: () async {
                await viewModel.logout();
                setState(() {});
              },
              child: const Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
