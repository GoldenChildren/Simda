import 'package:flutter/material.dart';
import 'package:simda/chat_with_friend.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatWithFriend()),
              );
            },
            child: const Text('Chat with friend'),
          ),
          const TextField(
            cursorColor: Colors.black12,
            cursorWidth: 1.0,
            decoration: InputDecoration(
                suffixIcon: Icon(Icons.send, color: Colors.black54),
                hintText: '답글을 입력하세요',
                enabledBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(
                        Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.black12,
                      width: 0.0,
                    )),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black12,
                  width: 0.0,
                )
              ),
              filled: true,
              fillColor: Colors.black12,
            ),
          ),
        ]);
  }
}
