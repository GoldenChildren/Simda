import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:simda/KakaoLogin/main_view_model.dart';
import 'package:simda/KakaoLogin/kakao_login.dart';
import 'package:simda/KakaoLogin/login_page.dart';
import 'package:simda/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: '57f9375c3d4e8452f5facd24db42ff6b',
  );
  runApp(const MyApp());
}

bool isVisible = true;
const storage = FlutterSecureStorage();
final viewModel = MainViewModel(KakaoLogin());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '심다',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          canvasColor: Colors.transparent,
        ),
        home: viewModel.isLoggedIn == 1 ? const MainPage() : const LoginPage(),
        // home: const MainPage(),
      ),
    );
  }
}