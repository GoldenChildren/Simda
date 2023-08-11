import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:simda/models/ChatRoomDto.dart';
import 'package:http/http.dart' as http;
import 'package:simda/models/ChatUserDto.dart';
//db에서 들고오기
class ChatRoomProviders {

  Future<void> sendMsg(String chatroomId, String userId, String content)async {
    DateTime dt = DateTime.now();
    int timestamp = dt.millisecondsSinceEpoch;
    DatabaseReference ref = FirebaseDatabase.instance.ref("chats").child(chatroomId);


    Map<String, dynamic> newChatroomData = {
      "userId": userId,
      "text": content,
      "time": timestamp,
    };

    await ref.child(timestamp.toString()).set(newChatroomData);
  }



  Future<List<ChatRoomDto>> getChatRooms(ChatUserDto myUserId, ChatUserDto contactUserId) async {
    print("내아이디 ${myUserId.userId}");
    print("상대 아이디 ${contactUserId.userId}");
    List<ChatRoomDto> chatRooms = [];
    Query chatRoomRef = FirebaseDatabase.instance.ref().child('chatrooms')
        .orderByChild("participants/${myUserId.userId}")
        .equalTo(true);
    try {
      DatabaseEvent snapshot = await chatRoomRef.once();
      dynamic data = snapshot.snapshot.value;
      print(data);
      if (data != null) {
        print("데이터있다");
        data.forEach((roomId, roomData) {
          if (roomData is Map<dynamic, dynamic>) { // Map 타입 확인
            print("맵타입 확인");
            if (roomData['participants'] != null && roomData['participants'][contactUserId.userId] != null) {
              print("상대유저 확인");
              ChatRoomDto chatRoom = ChatRoomDto.fromJson(roomData, roomId);
              chatRooms.add(chatRoom);
            }
          }
        });

      }else{
        print("데이터 없다");
      }

    } catch (error) {
      print("Error getting chatrooms: $error");
    }
    return chatRooms;
  }



  Future<ChatUserDto> getChatUser(int userId1) async {
    final refer = FirebaseDatabase.instance.ref("users");
    final snapshot = await refer.child(userId1.toString()).get();
    if (snapshot.exists) {
      dynamic data = snapshot.value;
      print(data);
      if(snapshot.value is Map) {
        ChatUserDto chatUserDto = ChatUserDto.fromJson(data, userId1.toString());
        return chatUserDto;
      }
    } else {
      print('No data available.');

    }
    return ChatUserDto(nickname: "", profileImg: "", userId: "");
  }





  Future<String?> createChatRoom(ChatUserDto myuid, ChatUserDto uid) async {
    List<ChatRoomDto> chatRooms = [];
    DatabaseReference ref = FirebaseDatabase.instance.ref("chatrooms");


    Map<String, dynamic> newChatroomData = {
      "participants": {
        myuid.userId: true,
        uid.userId : true,
        // 다른 참여자들도 추가 가능
      },
      "last_message": {
        "sender_id": "",
        "text": "",
        "timestamp": "",
      },
    };
    String? newChatroomId = ref.push().key;
    print(newChatroomId);
    ref.child(newChatroomId!).set(newChatroomData).then((_) {
      print("New chatroom added with key: $newChatroomId");
      return newChatroomId;
    }).catchError((error) {
      print("Error adding new chatroom: $error");
    });
    return null;
  }

}
