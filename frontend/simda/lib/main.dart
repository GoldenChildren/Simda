import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:simda/KakaoLogin/main_view_model.dart';
import 'package:simda/KakaoLogin/kakao_login.dart';
import 'package:simda/KakaoLogin/login_page.dart';
import 'package:simda/main_page.dart';

// 달력 한국 시각
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: '57f9375c3d4e8452f5facd24db42ff6b',
  );

  // 달력 한국 시각
  await initializeDateFormatting();

  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp()));
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
        home: viewModel.isLoggedIn == 1 ? MainPage(0) : const LoginPage(),
        // home: const MainPage(),
      ),
    );
  }
}