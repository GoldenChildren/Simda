import 'package:flutter/material.dart';
import 'package:simda/chat_with_friend.dart';
import 'package:simda/chatting_search_page.dart';
import 'package:simda/main.dart';
import 'package:simda/providers/chatroom_providers.dart';

import 'models/ChatRoomDto.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {

  List<ChatRoomDto> chatroom = [];
  ChatRoomProviders chatroomprovider = ChatRoomProviders();

  Future initChatRoom() async {
     chatroom = await chatroomprovider.getChatRoom(8);
     setState(() {});
  }


  @override
  void initState() {
    super.initState();
    initChatRoom();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '채팅 목록',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChattingSearchPage()),
                        );
                      },
                      icon: const Icon(Icons.add), iconSize: 28,),
                    ],
                  ),
                ),
                Container(height: 2, color: Colors.purple),
                Expanded(
                    child: ListViewBuilder(chatroom: chatroom,)),
              ],
            ),
          ),
        ),
      );
  }
}

// final List<String> friends = <String>['맹구', '철수', '유리', '짱아', '맹구', '철수', '유리', '짱아', '맹구', '철수', '유리', '짱아', '맹구', '철수', '유리', '짱아'];

class ListViewBuilder extends StatefulWidget {
  List<ChatRoomDto> chatroom;
  ListViewBuilder({required this.chatroom, super.key});


  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.chatroom.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatWithFriend(index)),
            );
            isVisible = !isVisible;
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 CircleAvatar(
                  // backgroundImage: AssetImage(widget.chatroom.user1.img),
                  backgroundImage: NetworkImage(widget.chatroom[index].user2Img),
                  radius: 30,
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.chatroom[index].user2nickName,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(widget.chatroom[index].lChatContent,
                          style: TextStyle(fontSize: 15),),
                        ],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(widget.chatroom[index].lChatTime,),
                            const SizedBox(height: 5),
                            Container(
                              height: 15,
                              width: 15,
                              decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            )
                          ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 2.0,
        color: Colors.black45,
      ),
    );
  }
}
