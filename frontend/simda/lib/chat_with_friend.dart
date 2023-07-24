import 'package:flutter/material.dart';
import 'package:simda/main_page.dart';

class ChatWithFriend extends StatefulWidget {
  const ChatWithFriend({super.key});

  @override
  State<ChatWithFriend> createState() => _ChatWithFriendState();
}

class _ChatWithFriendState extends State<ChatWithFriend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      color: Colors.white,
      child: Column(children: [
        const SizedBox(height: 30),
        Row(
          children: [
            const SizedBox(width: 10),
            SizedBox(
              height: 50,
              width: 50,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                iconSize: 30,

              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '맹구',
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ])),
    );
  }
}
