import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simda/KakaoLogin/kakao_login.dart';
import 'package:simda/KakaoLogin/main_view_model.dart';
import 'package:simda/KakaoLogin/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = const FlutterSecureStorage();
  final viewModel = MainViewModel(KakaoLogin());

  String email = "";
  String profileImg = "";
  String nickname = "";

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
      setState(() {
        email = storeEmail ?? "";
        profileImg = storeProfileImg ?? "/img/profile/noimg.jpg";
        nickname = storeNickname ?? "";
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
            const Image(image: AssetImage('assets/images/1152.png'), height: 150),
            const SizedBox(height: 20),
            const Image(image: AssetImage('assets/images/simda.png'), height: 40),
            const SizedBox(height: 50),
            // Image.network(
            //     viewModel.user?.kakaoAccount?.profile?.profileImageUrl ?? ''),
            Text(nickname),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await viewModel.login();
                if(!mounted) return;
                // Navigator.pushAndRemoveUntil(
                // context,
                // MaterialPageRoute(
                //     builder: (context) => const MainPage()), (route) => false
                // );
                setState(() {});

                // 화면 이동
                if (viewModel.isLoggedIn) {
                  print('회원가입 화면으로 이동합니다.');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                }
                // 카카오 로그인 오류
                if (!viewModel.isLoggedIn) {
                  print('카카오 로그인 오류');
                }

                getValueFromSecureStorage();
              },
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: const Image(image: AssetImage('assets/images/kakao_login_large_wide.png'))),
            ),


            Text(
              '${viewModel.isLoggedIn}',
              style: Theme.of(context).textTheme.headline4,
            ),

            // ElevatedButton(
            //   onPressed: () async {
            //     await viewModel.logout();
            //     setState(() {});
            //   },
            //   child: const Text('Logout'),
            // )
          ],
        ),
      ),
    );
  }
}
