import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simda/main.dart';
import 'package:simda/main_page.dart';
import 'package:simda/providers/user_providers.dart';

import 'main.dart';
import 'main_page.dart';
import 'models/UserDto.dart';

class ProfileEditPage extends StatefulWidget {

  const ProfileEditPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  String _email = "";
  String _profileImg = "";
  String _nickname = "";
  String _bio = "";
  XFile? _imgFile;
  int _userId = 0;
  final int _userRole = 1;
  bool _nicknameAvailability = true;
  bool isAvailable = true;
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    getValueFromSecureStorage();
  }
  // 닉네임 체크
  Future<void> _checkNicknameAvailability(String nickname) async {
    nickname = _nickname;
    try {
      isAvailable = await userProvider.checkNickname(nickname);

      setState(() {
        _nicknameAvailability = isAvailable;
      });
    } catch (error) {
      setState(() {
        _nicknameAvailability = false;
      });
    }
  }

  Future<void> getValueFromSecureStorage() async {
    try {
      String? storeEmail = await storage.read(key: "email");
      String? storeProfileImg = await storage.read(key: "profileImg");
      String? storeNickname = await storage.read(key: "nickname");
      String? storeBio = await storage.read(key: "bio");
      int storeUserId = int.parse((await storage.read(key: "userId"))!);

      setState(() {
        _email = storeEmail ?? "";
        _profileImg = storeProfileImg ?? "";
        _nickname = storeNickname ?? "";
        _bio = storeBio ?? "";
        _userId = storeUserId;
      });
    } catch (e) {
      print("Error reading from secure storage: $e");
    }
  }

  UserProviders userProvider = UserProviders();

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 4;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                SizedBox(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 28,
                  ),
                ),
                // const Text(
                //   '프로필 수정',
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '프로필 수정',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () async {
                          print(_bio);
                          print(_nickname);
                          print(_userId);
                          print(_profileImg);

                          await userProvider.modifyUser(_imgFile?.path ?? '', UserDto(
                              bio: _bio,
                              email: _email,
                              userId: _userId,
                              nickname: _nickname,
                              profileImg: _profileImg,
                              userRole: _userRole));

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage(4)), // 4는 이동하고 싶은 인덱스
                          );

                        },
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStatePropertyAll(Colors.blue.shade200)),
                        child: const Text(
                          '수정하기',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            Container(height: 2, color: Colors.purple),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: _selectImage,
              child: Container(
                  constraints: BoxConstraints(
                    minHeight: imageSize,
                    minWidth: imageSize,
                  ),
                  child: isChanged
                      ? CircleAvatar(
                    radius: imageSize / 2,
                    backgroundColor: Colors.transparent,
                    backgroundImage: FileImage(File(_imgFile!.path)),
                  )
                      : CircleAvatar(
                    radius: imageSize / 2,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage('${_profileImg}?timestamp=${DateTime.now().millisecondsSinceEpoch}'),
                  )

                // Center(
                //         child: Container(
                //           width: imageSize,
                //           height: imageSize,
                //           decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             border: Border.all(
                //                 width: 2,
                //                 color: Theme.of(context).colorScheme.primary),
                //             image: DecorationImage(
                //               image: FileImage(File(_pickedFile!)),
                //               fit: BoxFit.cover,
                //             ),
                //           ),
                //         ),
                //       ),
              ),
            ),
            const SizedBox(height:20),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                        child: TextField(
                          maxLength: 20,
                          maxLines: 1,
                          onChanged: (text) {
                            _nickname = text;
                          },
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            helperText: _nickname.isNotEmpty
                                ? _nicknameAvailability == true
                                ? '사용 가능한 닉네임입니다.'
                                : '이미 사용 중인 닉네임입니다.'
                                : '',
                            helperStyle: TextStyle(fontSize: 12.0, color:_nicknameAvailability  ? Colors.purple  : Colors.red  ),
                            enabledBorder:  const UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: const  UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            labelText: '닉네임',
                            labelStyle: const TextStyle(
                              color: Colors.black45,
                            ),
                            // hintText: '닉네임을 입력해주세요',
                            border: const UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),

                            fillColor: Colors.purple[200],
                            filled: true,
                          ),
                          controller: TextEditingController(text: _nickname)
                            ..selection = TextSelection.fromPosition(
                                TextPosition(offset: _nickname.length)),
                        ),
                      ),
    ),
                      const SizedBox(width: 10,),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),

                        ) ,
                        onPressed: () async {
                          if (_nickname.isNotEmpty) {
                            await _checkNicknameAvailability(
                                _nickname);
                          } else {
                            setState(() {
                              _nicknameAvailability = true;
                            });
                          }
                        },
                        child: Text("중복 확인", style: TextStyle(color: Colors.purple),),
                      ),
                    ],
                  ),
                ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                onChanged: (text) {
                  _bio = text;
                },
                cursorColor: Colors.black45,
                decoration:  InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  labelText: '소개',
                  labelStyle:const TextStyle(
                    color: Colors.black45,
                  ),
                  border:const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  fillColor: Colors.purple[200],
                  filled: true,
                ),
                controller: TextEditingController(text: _bio)
                  ..selection = TextSelection.fromPosition(
                      TextPosition(offset: _bio.length)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      (context as Element).markNeedsBuild();
      _imgFile = pickedFile;
      print(_imgFile);
      isChanged = true;
      // final croppedFile = await ImageCropper().cropImage(
      //   sourcePath: pickedFile.path,
      //   maxWidth: 1080,
      //   maxHeight: 1080,
      //   aspectRatioPresets: [
      //     CropAspectRatioPreset.square,
      //     CropAspectRatioPreset.ratio3x2,
      //     CropAspectRatioPreset.original,
      //     CropAspectRatioPreset.ratio4x3,
      //     CropAspectRatioPreset.ratio16x9
      //   ],
      //   uiSettings: [
      //     AndroidUiSettings(
      //         toolbarTitle: '프로필 이미지 Crop',
      //         initAspectRatio: CropAspectRatioPreset.original,
      //         lockAspectRatio: false),
      //     IOSUiSettings(
      //       title: '프로필 이미지 Crop',
      //     )
      //   ],
      // );
      //
      // if (croppedFile != null) {
      //   setState(() {
      //     _pickedFile = croppedFile.path;
      //   });
      // }
    }
  }
}
