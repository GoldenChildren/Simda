

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simda/main.dart';
import 'package:simda/models/ChatDto.dart';
import 'package:simda/models/ChatRoomDto.dart';
import 'package:simda/models/ChatUserDto.dart';
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
  List<ChatDto> chats=[];
  String chatContent="";
  var _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRoom().then((value)=>listenForChatUpdates());
    print("초기화 ");
    print(chatroomsList.length);
    print("내정보  가져왔다 ! :${widget.me.profileImg}");
  }
  void listenForChatUpdates() {
    Query starCountRef =
    FirebaseDatabase.instance.ref('chats')
        .child(chatRoomId!);
    starCountRef.onValue.listen((DatabaseEvent event) {
      chats=[];
      final data = event.snapshot.value;
      if (data == null) {
        return;
      }
      if(data is Map){
        data.forEach((chatId, chatdata) {
          if (chatdata is Map<dynamic, dynamic>) { // Map 타입 확인
            print(chatId is String);
            ChatDto rchat = ChatDto.fromJson(chatdata,chatId);
            print("1111111111111111111111111111");
            print(rchat.time);
            chats.add(rchat);
          }
        });
        int i = 0;
        while (i < chats.length){
          int j = i + 1;
          while(j < chats.length){
            if (int.parse(chats[j].time) > int.parse(chats[i].time)){
              ChatDto temp = chats[j];
              chats[j] = chats[i];
              chats[i] = temp;
            }
            j++;
          }
          i++;
        }
      }
      setState(() {if (mounted) {
        // 여기서 setState() 호출
      }});
    });
  }


  Future<void> getRoom() async{
    chatroomsList = await ChatRoomProviders().getChatRooms(widget.me, widget.contact);
    print("chatroomsList:${chatroomsList.length}");
    if(chatroomsList.length==0){
      print("getRoom 내닉네임: ${widget.me.nickname}");
      print("getRoom 상대닉네임 : ${widget.contact.nickname}");
      chatRoomId = await ChatRoomProviders().createChatRoom(widget.me, widget.contact) as String;
    }else{
      chatRoomId = await chatroomsList.first.chatroomId;
      print("기존의 챗룸있고 아이디 : ${chatRoomId}");
    }
    setState(() {
    });
  }

  void sendMessage() {
    if (chatContent!=null) {
      ChatRoomProviders().sendMsg(chatRoomId!, widget.me.userId, chatContent);
      setState(() {
        chatContent = ''; // Clear the text field after sending the message
        _controller.clear();
      });
    }

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
                Expanded(child: ListViewBuilder(chatList:chats ,me:widget.me, contact: widget.contact,)),
                Container(
                  color: Colors.black12,
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(fontSize: 14.0),
                    cursorColor: Colors.black12,
                    cursorWidth: 1.0,
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.fromLTRB(20, 0, 10, 0),
                      suffixIcon:
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.black54),
                          onPressed: sendMessage,
                        ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 0.0,
                          )),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 0.0,
                          )),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    onChanged: (text){
                      chatContent = text;
                    },
                  ),
                ),
              ]),
            ),
          );


  }

}

class ListViewBuilder extends StatefulWidget {
  final ChatUserDto me;
  final ChatUserDto contact;
  final List<ChatDto> chatList;
  const ListViewBuilder( {super.key,required this.chatList ,required this.me, required this.contact});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}


class _ListViewBuilderState extends State<ListViewBuilder> {

  @override
  Widget build(BuildContext context) {
    print("_ListViewBuilderState입니다!!!!!!!!!!!");
    print("프로필 내꺼 : ${widget.me.profileImg}");
    print("프로필 너꺼 : ${widget.contact.profileImg}");
    return ListView.builder(

        reverse: true,
        itemCount: widget.chatList.length,
        itemBuilder: (BuildContext context, int index) {
          ChatDto thisChat = widget.chatList[index];
          bool isCurrentUserMessage = thisChat.userId == widget.me.userId;
          ChatUserDto thisUser =
          isCurrentUserMessage ? widget.me : widget.contact;
          //시간 변경

          var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(thisChat.time));
          var format = new DateFormat('hh:mm').format(date);


          return Row(
              mainAxisAlignment:
              isCurrentUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (isCurrentUserMessage) ...{

                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              format,
                              style: TextStyle(
                                fontSize: 10
                              ),
                            ),
                            BubbleSpecialOne(
                                text: thisChat.text,
                                isSender: true,
                                color: Colors.blue,
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                ),
                                ),
                          ]))

                },
                if (!isCurrentUserMessage)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 00),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      BubbleSpecialOne(
                                        text: thisChat.text,
                                        isSender: false,
                                        color: Colors.grey.shade200,
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20
                                        ),
                                      ),
                                      Text(format,
                                        style: TextStyle(
                                            fontSize: 10
                                        ),
                                      )
                                    ]))
                          ]))
              ]);









          // return Container(
          //   padding: const EdgeInsets.symmetric(vertical: 10),
          //   alignment:
          //   isCurrentUserMessage ? Alignment.centerRight : Alignment.centerLeft,
          //   child: Row(
          //     mainAxisAlignment: isCurrentUserMessage
          //         ? MainAxisAlignment.end
          //         : MainAxisAlignment.start,
          //     children: [
          //       Column(
          //         children: [
          //           CircleAvatar(
          //             backgroundImage: NetworkImage(thisUser.profileImg),
          //             radius: 26,
          //           ),
          //           SizedBox(height: 10),
          //         ],
          //       ),
          //       const SizedBox(width: 8),
          //       Column(
          //         crossAxisAlignment: isCurrentUserMessage
          //             ? CrossAxisAlignment.end
          //             : CrossAxisAlignment.start,
          //         children: [
          //           SizedBox(
          //             height: 23,
          //             child: Text(
          //               thisUser.nickname,
          //               style: const TextStyle(
          //                   fontSize: 15, fontWeight: FontWeight.bold),
          //             ),
          //           ),
          //           Container(
          //             padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          //             decoration: BoxDecoration(
          //               color: isCurrentUserMessage
          //                   ? Colors.blueGrey.shade200
          //                   : Colors.white,
          //               borderRadius: BorderRadius.circular(10),
          //             ),
          //             child: Text(
          //               thisChat.text,
          //               style: const TextStyle(fontSize: 15),
          //             ),
          //           ),
          //           const SizedBox(height: 5),
          //           Text(
          //             thisChat.time,
          //             style: TextStyle(fontSize: 12, color: Colors.black45),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // );
        });
  }
}


