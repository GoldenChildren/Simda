import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends StatefulWidget {
  final String nickname;
  final String bio;
  final String? pickedFile;

  const ProfileEditPage({
    Key? key,
    required this.nickname,
    required this.bio,
    this.pickedFile,
  }) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  String _nickname = '';
  String _bio = '';
  String? _pickedFile;

  @override
  void initState() {
    super.initState();
    _nickname = widget.nickname;
    _bio = widget.bio;
    _pickedFile = widget.pickedFile;
  }

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
                const Text(
                  '프로필 수정',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 180),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      {
                        'nickname': _nickname,
                        'bio': _bio,
                        'pickedFile': _pickedFile,
                      },
                    );
                  },
                  child: const Text('Save'),
                ),
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
                child: _pickedFile == null
                    ? Center(
                        child: Icon(
                          Icons.account_circle,
                          size: imageSize,
                        ),
                      )
                    : Center(
                        child: Container(
                          width: imageSize,
                          height: imageSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 2,
                                color: Theme.of(context).colorScheme.primary),
                            image: DecorationImage(
                              image: FileImage(File(_pickedFile!)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  _nickname = value;
                },
                cursorColor: Colors.black45,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  labelText: '닉네임',
                  labelStyle: TextStyle(
                    color: Colors.black45,
                  ),
                  // hintText: '닉네임을 입력해주세요',
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
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
              padding: const EdgeInsets.all(16.10),
              child: TextField(
                onChanged: (value) {
                  _bio = value;
                },
                cursorColor: Colors.black45,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  labelText: '소개',
                  labelStyle: TextStyle(
                    color: Colors.black45,
                  ),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
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
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: '프로필 이미지 Crop',
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: '프로필 이미지 Crop',
          )
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _pickedFile = croppedFile.path;
        });
      }
    }
  }
}
