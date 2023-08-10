import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:simda/chat_with_friend.dart';
import 'package:simda/chatting_search_page.dart';
import 'package:simda/main.dart';
import 'package:simda/models/ChatUserDto.dart';
import 'package:simda/providers/chatroom_providers.dart';

import 'models/ChatRoomDto.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  int userId = 8;
  List<ChatRoomDto> chatroom = [];
  ChatRoomProviders chatroomprovider = ChatRoomProviders();

  void listenForChatRoomUpdates() {

    Query starCountRef =
    FirebaseDatabase.instance.ref('chatrooms')
        .orderByChild("participants/" +userId.toString())
        .equalTo(true);
    starCountRef.onValue.listen((DatabaseEvent event) {
      chatroom=[];
      final data = event.snapshot.value;
      if (data == null) {
        return;
      }
      print(data);

      if(data is Map){
        print("data가 맵이야!");
        data.forEach((roomId, roomData) {
          print(roomId);
          print(roomData is Map<dynamic, dynamic>);
          if (roomData is Map<dynamic, dynamic>) { // Map 타입 확인
            print("data가 Map<String, dynamic>이야!");
            ChatRoomDto rchatRoom = ChatRoomDto.fromJson(roomData,roomId);
            print("여기까지 옴");
            chatroom.add(rchatRoom);
            print(rchatRoom);

            print("여기까지 못옴");
          }
        });
      }
      setState(() {if (mounted) {
        // 여기서 setState() 호출
      }});
      print("끝");
    });
  }

  @override
  void initState() {
    super.initState();
    getValueFromSecureStorage();
    listenForChatRoomUpdates();
  }
  Future<void> getValueFromSecureStorage() async {
    try {
      int storeUserId = int.parse((await storage.read(key: "userId"))!);

      setState(() {
        userId = storeUserId;
        print(storeUserId);
      });
    } catch (e) {
      print("Error reading from secure storage: $e");
    }
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
                    child: ListViewBuilder(chatroom: chatroom, userId : userId)),
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
  int userId;

  ListViewBuilder({required this.chatroom, required this.userId,});
  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
   List<ChatUserDto> contacts=[];

  @override
  void initState() {
    super.initState();
  }

  Future<List<ChatUserDto>> fetchContacts() async {
    List<ChatUserDto> updatedContacts = [];

    print("작동 1");
    for (int index = 0; index < widget.chatroom.length; index++) {
      ChatRoomDto chatRoom = widget.chatroom[index];
      String userId1 = chatRoom.participants.keys.first;
      String userId2 = chatRoom.participants.keys.last;
      ChatRoomProviders chatRoomProviders = ChatRoomProviders();
      ChatUserDto? contact;
      print(userId2);
      if (userId2 == widget.userId.toString()) {
        contact = await chatRoomProviders.getChatUser(int.parse(userId1));
        print("작동 2");
      } else {
        contact = await chatRoomProviders.getChatUser(int.parse(userId2));
        print("작동 2");
      }

      if (contact != null) {
        print("작동 3");
        updatedContacts.add(contact);
      }
    }
    // 상태 갱신
    return updatedContacts;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: fetchContacts(),
        builder: (context, snapshot){
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center();
    } else
      if (snapshot.hasError) {
    return Center(
    child: Text("Error: ${snapshot.error}"),
    );
    } else {
    contacts = snapshot.data as List<ChatUserDto>;

    return ListView.separated(
      itemCount: widget.chatroom.length,
      itemBuilder: (BuildContext context, int index) {
        ChatUserDto contact = contacts[index]; // 가져온 데이터 사용

        return GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => ChatWithFriend(contact: contact,)),
            // );
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(contact.profileImg),
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
                            contact.nickname,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "여기다가 마지막 채팅 내용",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("04:23"),
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
        },
    );
  }
}

