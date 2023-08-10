import 'package:flutter/material.dart';
import 'package:simda/main.dart';
import 'package:simda/models/ChatRoomDto.dart';
import 'package:simda/models/ChatUserDto.dart';
import 'package:simda/models/UserDto.dart';
import 'package:simda/providers/chatroom_providers.dart';

class ChatWithFriend extends StatefulWidget {
  final ChatUserDto contact;
  final ChatUserDto me;
  const ChatWithFriend({super.key, required this.contact, required this.me});
  @override
  State<ChatWithFriend> createState() => _ChatWithFriendState();
}

class _ChatWithFriendState extends State<ChatWithFriend> {
  List<ChatRoomDto> chatroomsList=[];
  late String? chatRoomId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRoom();
    print("초기화 ");
    print(chatroomsList.length);
    // print("챗룸아이디 가져왔다 ! :${chatRoomId}");
  }
  void getRoom() async{
    chatroomsList = await ChatRoomProviders().getChatRooms(widget.me, widget.contact);
    print("chatroomsList:${chatroomsList.length}");
    if(chatroomsList.length==0){
      chatRoomId = await ChatRoomProviders().createChatRoom(widget.me, widget.contact) as String;
    }else{
      chatRoomId = await chatroomsList.first.chatroomId;
      print("기존의 챗룸있고 아이디 : ${chatRoomId}");
    }
    setState(() {
    });
  }




  @override
  Widget build(BuildContext context) {
          if(widget.me==null){
            return CircularProgressIndicator();
          }
          return SafeArea(
            child: Scaffold(
              body: Column(children: [
                Row(
                  children: [
                    const SizedBox(width: 10),
                    SizedBox(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          isVisible = !isVisible;
                        },
                        icon: const Icon(Icons.arrow_back),
                        iconSize: 28,
                      ),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.contact.profileImg),
                      radius: 13,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      widget.contact.nickname,
                      style:
                      const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(height: 2, color: Colors.purple),
                Expanded(child: ListViewBuilder(me:widget.me, contact: widget.contact,)),
                Container(
                  color: Colors.black12,
                  child: const TextField(
                    style: TextStyle(fontSize: 14.0),
                    cursorColor: Colors.black12,
                    cursorWidth: 1.0,
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.fromLTRB(20, 0, 10, 0),
                      suffixIcon:
                      Icon(Icons.send, color: Colors.black54),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 0.0,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 0.0,
                          )),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
              ]),
            ),
          );


  }

  // Future<void> getValueFromSecureStorage() async {
  //   try {
  //     String storeUserId = await storage.read(key: "userId").toString();
  //     print("hi getValueFromSecureStorage");
  //     String storeNickname = await storage.read(key: "nickname").toString();
  //     String storeProfileImg = await storage.read(key: "profileImg").toString();
  //     me = ChatUserDto(
  //         userId: storeUserId,
  //         nickname: storeNickname,
  //         profileImg: storeProfileImg,
  //     );
  //
  //     setState(() {});
  //     print("me 저장 완료 ");
  //   } catch (e) {
  //     print("Error reading from secure storage: $e");
  //   }
  // }
}

class ListViewBuilder extends StatefulWidget {
  final ChatUserDto me;
  final ChatUserDto contact;
  const ListViewBuilder( {super.key,required this.me, required this.contact});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}


class _ListViewBuilderState extends State<ListViewBuilder> {
  List<String> arr=[];
  late Future<List<ChatRoomDto>> chatRoomsFuture;
  List<ChatRoomDto> chatRooms =[];
  late Future<String> chatroomId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatRoomsFuture = ChatRoomProviders().getChatRooms(
      widget.me,
      widget.contact,
    );
    // getRoomId();
  }
  // Future<void>? getRoomId() async{
  //   chatroomId = (await ChatRoomProviders().createChatRoom(
  //       int.parse(widget.me.userId),
  //       int.parse(widget.contact.userId))) as Future<String>;
  // }
  void sendMsg(){
    if(chatRooms.length ==0){
      // ChatRoomProviders().createChatRoom(widget.me, widget.contact);
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatRoomDto>>(
      future: chatRoomsFuture, // chatRoomsFuture의 완료를 기다림
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // 로딩 중에 표시할 위젯
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
           chatRooms = snapshot.data!;
          print("챗룸이 있어? ${chatRooms.length}");
          return ListView.builder(
              reverse: true,
              itemCount: arr.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(children: [
                    const Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/images/yuri.jpg'),
                          radius: 26,
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                            height: 23,
                            child: Text(
                              "메세지 내용 넣는곳",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade200,
                                borderRadius: const BorderRadius.only(
                                  // topLeft: Radius.circular(5),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                              ),
                              child: Text(
                                arr[arr.length - index - 1],
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '오후 4: 30',
                              style: TextStyle(fontSize: 12, color: Colors.black45),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
                );
              });
        } else {
          return Text('No data available');
        }
      },
    );
  }
  }

