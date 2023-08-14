import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simda/chat_with_friend.dart';
import 'package:simda/chatting_search_page.dart';
import 'package:simda/main.dart';
import 'package:simda/models/ChatUserDto.dart';
import 'package:simda/models/LastChatDto.dart';
import 'package:simda/providers/chatroom_providers.dart';

import 'models/ChatRoomDto.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  int userId = 0;
  ChatUserDto? me;
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
      if(data is Map){
        data.forEach((roomId, roomData) {
          if (roomData is Map<dynamic, dynamic>) { // Map 타입 확인
            print(roomId is String);
            ChatRoomDto rchatRoom = ChatRoomDto.fromJson(roomData,roomId);
            print("목록 프린트");
            print(rchatRoom.lastMessage.values.first);
            if(rchatRoom.lastMessage.values.first !=""){
              chatroom.add(rchatRoom);
            }
          }
        });

        chatroom.sort((a, b) {
          // Compare timestamps for sorting
          int aTimestamp = a.lastMessage['time'] ?? 0;
          int bTimestamp = b.lastMessage['time'] ?? 0;
          return bTimestamp.compareTo(aTimestamp);
        });
      }
      setState(() {});
    });
  }
  @override
  void dispose() {
    // 해제
    super.dispose();
  }
  @override
  void initState()  {
    super.initState();
    getValueFromSecureStorage().then((value) => listenForChatRoomUpdates());
  }

  Future<void> getValueFromSecureStorage() async {
    try {
      int storeUserId = int.parse((await storage.read(key: "userId"))!);
      String? storeNickname = await storage.read(key: "nickname");
      String? storeProfileImg = await storage.read(key: "profileImg");

        userId = storeUserId;
        me =  ChatUserDto(
          userId: storeUserId.toString(),
          nickname: storeNickname.toString(),
          profileImg: storeProfileImg.toString(),);

          setState(() {});
    } catch (e) {
      print("Error reading from secure storage: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
          if(me ==null){
            return CircularProgressIndicator();
          }
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
                      child: ListViewBuilder(chatroom: chatroom, userId : userId, me:me!),
                    ),
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
  ChatUserDto me;

  ListViewBuilder({super.key, required this.chatroom, required this.userId, required this.me});
  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
   List<ChatUserDto> contacts=[];

  @override
  void initState() {
    super.initState();
    print("${widget.me.nickname} 왔다");
  }

  Future<List<ChatUserDto>> fetchContacts() async {
    List<ChatUserDto> updatedContacts = [];


    for (int index = 0; index < widget.chatroom.length; index++) {
      ChatRoomDto chatRoom = widget.chatroom[index];
      String userId1 = chatRoom.participants.keys.first.toString();
      String userId2 = chatRoom.participants.keys.last.toString();
      ChatRoomProviders chatRoomProviders = ChatRoomProviders();
      ChatUserDto? contact;
      if (userId2 == widget.userId.toString()) {
        contact = await chatRoomProviders.getChatUser(int.parse(userId1));
      } else {
        contact = await chatRoomProviders.getChatUser(int.parse(userId2));
      }
      if (contact != null) {
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
        ChatRoomDto thischatRoom = widget.chatroom[index];
        LastChatDto lastChat = LastChatDto.fromJson(thischatRoom.lastMessage);
        bool shouldShowUnreadIndicator =
            lastChat.read == true && lastChat.userId == contact.userId;


        late var format;
        if(lastChat.time != null){
          var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(lastChat.time!));
          format= new DateFormat('hh:mm').format(date);
        }else{
          format=null;
        }


        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatWithFriend(contact: contact, me:widget.me)),
            );
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
                              lastChat.text ?? " ",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (shouldShowUnreadIndicator)
                              Container(
                                height: 15,
                                width: 15,
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ),
                            const SizedBox(height: 5),
                            Text(format?? " "),

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

