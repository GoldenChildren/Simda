import "package:flutter/material.dart";
import 'package:simda/KakaoLogin/main_view_model.dart';
import 'package:simda/KakaoLogin/kakao_login.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:simda/main_page.dart';
import 'package:simda/providers/user_providers.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final viewModel = MainViewModel(KakaoLogin());
  final formKey = GlobalKey<FormState>();
  final TextEditingController nicknameController =
  TextEditingController(); // 닉네임 입력 값을 저장하는 컨트롤러를 생성
  final _picker = ImagePicker();
  XFile? _profileImage;
  bool _isNicknameAvailable = true;
  UserProviders userProvider = UserProviders();

  // 이미지 선택 메서드
  Future<void> _pickImage(BuildContext context) async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      (context as Element).markNeedsBuild();
      _profileImage = pickedImage;
    }
  }

  // 닉네임 중복 체크
  Future<void> _checkNicknameAvailability(String nickname) async {
    if (nickname.isNotEmpty) {
      try {
        bool isAvailable = await userProvider.checkNickname(nicknameController.text);
        setState(() {
          _isNicknameAvailable = isAvailable;
        });
      } catch (error) {
        setState(() {
          _isNicknameAvailable = false;
        });
      }
    } else {
      setState(() {
        _isNicknameAvailable = false; // 닉네임이 비어있는 경우 사용 가능하도록 설정
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20),
                      Text(
                        '회원 설정',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        child: IconButton(
                          color: Colors.transparent,
                          onPressed: null,
                          icon: Icon(Icons.settings),
                          iconSize: 28,
                        ),
                      ),
                    ],
                  ),
                  Container(height: 2, color: Colors.purple),
                  const SizedBox(height: 50),
                  // 프로필 이미지 선택 버튼
                  // 이미지 선택한 경우 이미지 미리보기
                  _getProfileImagePreview(context), // 미리보기 이미지 출력 함수 사용
                  const SizedBox(height: 10), // 간격 추가
                  TextButton(
                    child: const Text("프로필 이미지 선택",
                        style: TextStyle(color: Colors.black45)),
                    onPressed: () async {
                      await _pickImage(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: textFormFieldComponent(
                      false,
                      TextInputType.text,
                      TextInputAction.next,
                      '닉네임을 입력해주세요',
                      20,
                      '닉네임은 20자 이하여야 합니다',
                      nicknameController, // 닉네임 입력 값을 저장하는 컨트롤러를 전달
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (nicknameController.text.isNotEmpty) {
                        await _checkNicknameAvailability(nicknameController.text);
                      }
                      setState(() {}); // 이 부분을 추가하여 화면을 갱신합니다.
                    },
                    child: Text("닉네임 중복 확인"),
                  ),
                  Text(
                    _isNicknameAvailable
                        ? ""  // 사용 가능한 닉네임일 경우 빈 문자열을 출력
                        : "이미 사용 중인 닉네임입니다.",
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsetsDirectional.all(15),
                    ),
                    child: const Text("회원가입"),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        // 폼 검증을 통과한 경우에만 회원가입 동작 수행
                        String nickname = nicknameController.text; // 닉네임 값을 가져옴
                        viewModel.signup(_profileImage!.path, nickname);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage(0)),
                              (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textFormFieldComponent(
      bool obscureText,
      TextInputType keyboardType,
      TextInputAction textInputAction,
      String hintText,
      int maxSize,
      String errorMessage,
      TextEditingController controller,
      ) {
    return TextFormField(
      controller: controller,
      maxLength: 20,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      cursorColor: Colors.black45,
      decoration: InputDecoration(
        hintText: hintText,
        // helperText: !_isNicknameAvailable ? '이미 사용 중인 닉네임입니다.' : null,
        enabledBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        border: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        fillColor: Colors.purple[200],
        filled: true,
      ),
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "error";
        }
        if (value.length > maxSize) {
          return '닉네임은 $maxSize자 이하여야 합니다';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _isNicknameAvailable = true; // 닉네임이 변경되면 다시 확인 가능하도록
        });
      },
    );
  }

  Widget _getProfileImagePreview(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 4;
    if (_profileImage != null) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: FileImage(File(_profileImage!.path)),
      );
    } else {
      return CircleAvatar(
          radius: imageSize / 2,
          backgroundColor: Colors.transparent,
          child: Icon(
            Icons.account_circle,
            size: imageSize,
            color: Colors.black45,
          ));
    }
  }
}
