import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_login/kakao_login.dart';
import 'package:kakao_login/main_view_model.dart';
import 'package:kakao_login/sign_up.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: '57f9375c3d4e8452f5facd24db42ff6b',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Kakao Login Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = FlutterSecureStorage();
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
    print("email : " + email);
    print("profileImg : " + profileImg);
    print("nickname : " + nickname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              // viewModel.user?.kakaoAccount?.profile?.profileImageUrl ?? ''),
              "http://70.12.247.215:9090" + profileImg,
              fit: BoxFit.cover,
              width: 200,
              height: 200,
            ),
            Text(
              '${nickname}',
              style: Theme.of(context).textTheme.headline4,
            ),
            GestureDetector(
              onTap: () async {
                await viewModel.login();
                setState(() {});

                // 화면 이동
                if (viewModel.isLoggedIn == 0) {
                  print('회원가입 화면으로 이동합니다.');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                }
                // 카카오 로그인 오류
                if (viewModel.isLoggedIn == -1) {
                  print('카카오 로그인 오류');
                }

                getValueFromSecureStorage();
              },
              // style: const ButtonStyle(backgroundColor: Colors.transparent,),
              child: SizedBox(
                  width: 250,
                  child: Image.asset('assets/images/kakaologin.png')),
            ),
            ElevatedButton(
              onPressed: () async {
                await viewModel.login();
                setState(() {});
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () async {
                await viewModel.logout();
                setState(() {});
                getValueFromSecureStorage();
              },
              child: const Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
