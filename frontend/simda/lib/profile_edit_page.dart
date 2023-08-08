import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simda/main.dart';
import 'package:simda/providers/user_providers.dart';

import 'main.dart';
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

  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    getValueFromSecureStorage();
  }

  Future<void> getValueFromSecureStorage() async {
    try {
      String? storeEmail = await storage.read(key: "profileImg");
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
                        onPressed: () {
                          print(_bio);
                          print(_nickname);
                          print(_userId);
                          print(_profileImg);
                          print(_imgFile!.path);
                          userProvider.modifyUser(_imgFile!.path, UserDto(
                              bio: _bio,
                              email: _email,
                              userId: _userId,
                              nickname: _nickname,
                              profileImg: _imgFile!.path,
                              userRole: _userRole));
                          Navigator.pop(context);
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
                  child: !isChanged
                      ? CircleAvatar(
                    radius: imageSize / 2,
                    backgroundColor: Colors.transparent,
                    backgroundImage: FileImage(File(_profileImg)),
                  )
                      : CircleAvatar(
                    radius: imageSize / 2,
                    backgroundColor: Colors.transparent,
                    backgroundImage: FileImage(File(_imgFile!.path)),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                maxLines: 1,
                onChanged: (text) {
                  _nickname = text;
                },
                cursorColor: Colors.black45,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  labelText: '닉네임',
                  labelStyle: TextStyle(
                    color: Colors.black45,
                  ),
                  // hintText: '닉네임을 입력해주세요',
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),

                  fillColor: Colors.lightGreen,
                  filled: true,
                ),
                controller: TextEditingController(text: _nickname)
                  ..selection = TextSelection.fromPosition(
                      TextPosition(offset: _nickname.length)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                onChanged: (text) {
                  _bio = text;
                },
                cursorColor: Colors.black45,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  labelText: '소개',
                  labelStyle: TextStyle(
                    color: Colors.black45,
                  ),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  fillColor: Colors.lightGreen,
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

