import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'profileedit_page.dart'; // Replace this import with the correct path to profileedit_page.dart

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _nickname = "John Doe";
  String _bio = "Hello, I'm using Flutter!";
  String? _pickedFile;

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 4;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 20, 30),
              child: GestureDetector(
                onTap: () {
                  _navigateToProfileEditPage(context);
                },
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
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: IconButton(
                onPressed: () {
                  _navigateToProfileEditPage(context);
                },
                icon: const Icon(Icons.edit),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _nickname,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              _bio,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProfileEditPage(BuildContext context) async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditPage(
          nickname: _nickname,
          bio: _bio,
          pickedFile: _pickedFile,
        ),
      ),
    );

    if (updatedData != null) {
      setState(() {
        _nickname = updatedData['nickname'];
        _bio = updatedData['bio'];
        _pickedFile = updatedData['pickedFile'];
      });
    }
  }
}
