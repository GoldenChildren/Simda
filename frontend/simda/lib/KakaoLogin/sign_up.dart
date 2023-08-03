import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:simda/KakaoLogin/kakao_login.dart';
import 'dart:io';

import 'package:simda/KakaoLogin/main_view_model.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final viewModel = MainViewModel(KakaoLogin());
  final formKey = GlobalKey<FormState>();
  final TextEditingController nicknameController = TextEditingController(); // 닉네임 입력 값을 저장하는 컨트롤러를 생성
  final _picker = ImagePicker();
  XFile? _profileImage;

  // 이미지 선택 메서드
  Future<void> _pickImage(BuildContext context) async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      (context as Element).markNeedsBuild();
      _profileImage = pickedImage;
    }
  }

  // 이미지 미리보기를 원하는 크기로 조정하는 함수
  Widget _getProfileImagePreview() {
    if (_profileImage != null) {
      return Image.file(
        File(_profileImage!.path),
        width: 200, // 원하는 너비로 조정
        height: 200, // 원하는 높이로 조정
      );
    } else {
      return Text("프로필 이미지를 선택하세요");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 프로필 이미지 선택 버튼
                  // 이미지 선택한 경우 이미지 미리보기
                  _getProfileImagePreview(), // 미리보기 이미지 출력 함수 사용
                  SizedBox(height: 20), // 간격 추가
                  ElevatedButton(
                    child: Text("프로필 이미지 선택"),
                    onPressed: () async {
                      await _pickImage(context);
                      print(_profileImage?.path);
                    },
                  ),
                  TextFormFieldComponent(
                    false,
                    TextInputType.text,
                    TextInputAction.next,
                    '닉네임을 입력해주세요',
                    20,
                    '닉네임은 20자 이하여야 합니다',
                    nicknameController, // 닉네임 입력 값을 저장하는 컨트롤러를 전달
                  ),
                  ElevatedButton(
                    child: const Text("회원가입"),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        // 폼 검증을 통과한 경우에만 회원가입 동작 수행
                        String nickname = nicknameController.text; // 닉네임 값을 가져옴
                        print("가입 시 닉네임 : "+nickname);
                        // FormData formData = FormData.fromMap({
                        //   'profileImg': await MultipartFile.fromFile(_profileImage!.path, filename: nickname+'_profile_img.jpg'),
                        //   'nickname' : nickname,
                        //   'email': null,
                        // });
                        viewModel.signup(_profileImage!.path, nickname);
                        Navigator.pop(context);
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

  Widget TextFormFieldComponent(
      bool obscureText,
      TextInputType keyboardType,
      TextInputAction textInputAction,
      String hintText,
      int maxSize,
      String errorMessage,
      TextEditingController controller, // 컨트롤러 매개변수 추가
      ) {
    return Container(
      child: TextFormField(
        controller: controller, // 전달받은 컨트롤러를 사용하여 입력 값을 관리
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          hintText: hintText,
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return errorMessage;
          }
          if (value.length > maxSize) {
            return '닉네임은 $maxSize자 이하여야 합니다';
          }
          return null;
        },
      ),
    );
  }
}