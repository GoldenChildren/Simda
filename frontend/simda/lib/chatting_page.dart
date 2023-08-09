import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:simda/chat_with_friend.dart';
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

  Future initChatRoom() async {

     print("채팅 목록 수 :${chatroom.length}");
     setState(() {});
  }
  void listenForChatRoomUpdates() {
    Query starCountRef =
    FirebaseDatabase.instance.ref('chatrooms')
        .orderByChild("participants/" +userId.toString())
        .equalTo(true);
    starCountRef.onValue.listen((DatabaseEvent event) {
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
            ChatRoomDto rchatRoom = ChatRoomDto.fromJson(roomData);
            print("여기까지 옴");
            chatroom.add(rchatRoom);
            print("여기까지 못옴");
          }
        });
      }
      setState(() {

      });
    });
  }

  @override
  void initState() {
    super.initState();
    initChatRoom();
    getValueFromSecureStorage();
    listenForChatRoomUpdates();
  }
  Future<void> getValueFromSecureStorage() async {
    try {
      int storeUserId = int.parse((await storage.read(key: "userId"))!);

      setState(() {
        userId = storeUserId;
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
                      IconButton(onPressed: () {chatroomprovider.createChatRoom(8, 4);},
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
  ListViewBuilder({required this.chatroom, super.key, required this.userId});


  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.chatroom.length,
      itemBuilder: (BuildContext context, int index) {
        print("여기3");
        ChatRoomDto chatRoom = widget.chatroom[index]; // 해당 인덱스의 채팅방 데이터
        String userId1 = chatRoom.participants.keys.first;
        String userId2 = chatRoom.participants.keys.last;
        ChatRoomProviders chatRoomProviders = ChatRoomProviders();
        ChatUserDto? contact;
        if(userId2 == widget.userId.toString()){
          print("여기1");
          contact= await chatRoomProviders.getChatUser(int.parse(userId1)) as ChatUserDto?;
        }else{
          print("여기2");
          contact= chatRoomProviders.getChatUser(int.parse(userId2)) as ChatUserDto?;
        }

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
                   //프로필 이미지
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
                          Text("여기다가 마지막 채팅 내용",
                          style: TextStyle(fontSize: 15),),
                        ],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("04:23",),
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
