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
  _ProfileEditPageState createState() => _ProfileEditPageState();
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
            TextField(
              onChanged: (value) {
                _nickname = value;
              },
              decoration: const InputDecoration(labelText: 'Nickname'),
              controller: TextEditingController(text: _nickname),
            ),
            TextField(
              onChanged: (value) {
                _bio = value;
              },
              decoration: const InputDecoration(labelText: 'Bio'),
              controller: TextEditingController(text: _bio),
            ),
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
      ),
    );
  }

  Future<void> _selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
