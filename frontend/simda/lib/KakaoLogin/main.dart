// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   KakaoSdk.init(
//     nativeAppKey: '57f9375c3d4e8452f5facd24db42ff6b',
//   );
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Kakao Login Demo Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   final TextEditingController nicknameController = TextEditingController();
//   final _picker = ImagePicker();
//   XFile? _profileImage;
//   Future<void> _pickImage(BuildContext context) async {
//     final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       (context as Element).markNeedsBuild();
//       _profileImage = pickedImage;
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Form(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   SizedBox(width: 20),
//                   Text(
//                     '회원 설정',
//                     style:
//                     TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               Container(height: 2, color: Colors.purple),
//               // 프로필 이미지 선택 버튼
//               const SizedBox(height: 20),
//               // 이미지 선택한 경우 이미지 미리보기
//               Container(height: 200, width: 200, color: Colors.red),// 미리보기 이미지 출력 함수 사용
//               const SizedBox(height: 20), // 간격 추가
//               TextButton(
//                 child: const Text("프로필 이미지 선택",
//                 style: TextStyle(color: Colors.black45)),
//                 onPressed: () async {
//                   await _pickImage(context);
//                 },
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//                 child: textFormFieldComponent(
//                   false,
//                   TextInputType.text,
//                   TextInputAction.next,
//                   '닉네임을 입력해주세요',
//                   20,
//                   '닉네임은 20자 이하여야 합니다',
//                   nicknameController, // 닉네임 입력 값을 저장하는 컨트롤러를 전달
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueGrey,
//                   padding: const EdgeInsetsDirectional.all(15),
//                 ),
//                 child: const Text("회원가입"),
//                 onPressed: () {
//
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget textFormFieldComponent(
//       bool obscureText,
//       TextInputType keyboardType,
//       TextInputAction textInputAction,
//       String hintText,
//       int maxSize,
//       String errorMessage,
//       TextEditingController controller, // 컨트롤러 매개변수 추가
//       ) {
//     return TextFormField(
//       controller: controller, // 전달받은 컨트롤러를 사용하여 입력 값을 관리
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//       textInputAction: textInputAction,
//       cursorColor: Colors.black45,
//       decoration: InputDecoration(
//         hintText: hintText,
//         enabledBorder: const UnderlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(5)),
//           borderSide: BorderSide(color: Colors.transparent),
//         ),
//         focusedBorder: const UnderlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(5)),
//           borderSide: BorderSide(color: Colors.transparent),
//         ),
//         border: const UnderlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(5)),
//           borderSide: BorderSide(color: Colors.transparent),
//         ),
//
//         fillColor: Colors.lightGreen,
//         filled: true,
//       ),
//       validator: (value) {
//         if (value!.trim().isEmpty) {
//           return errorMessage;
//         }
//         if (value.length > maxSize) {
//           return '닉네임은 $maxSize자 이하여야 합니다';
//         }
//         return null;
//       },
//     );
//   }
// }
