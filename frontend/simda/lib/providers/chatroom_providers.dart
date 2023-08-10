import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:simda/models/ChatRoomDto.dart';
import 'package:http/http.dart' as http;
import 'package:simda/models/ChatUserDto.dart';
//db에서 들고오기
class ChatRoomProviders {
  // Future<List<ChatRoomDto>> getChatRoom1(int userId) async {
  //   List<ChatRoomDto> chatroom = [];
  //   String uri = "http://i9a709.p.ssafy.io:8000/simda/chat/rooms/";
  //   uri += "${userId}";
  //
  //   final response = await http.get(Uri.parse(uri));
  //
  //   if (response.statusCode == 200) {
  //     chatroom =
  //         jsonDecode(response.body).map<ChatRoomDto>((chatrooms) {
  //       return ChatRoomDto.fromJson(chatrooms);
  //     }).toList();
  //     print(chatroom);
  //   }
  //
  //   return chatroom;
  // }


  Future<List<ChatRoomDto>> getChatRooms(ChatUserDto myUserId, ChatUserDto contactUserId) async {
    List<ChatRoomDto> chatRooms = [];
    Query chatRoomRef = FirebaseDatabase.instance.reference().child('chatrooms')
        .orderByChild("participants/${myUserId.userId}")
        .equalTo(true);

    try {
      DataSnapshot snapshot = (await chatRoomRef.once()) as DataSnapshot;
      if (snapshot.value != null) {
        dynamic data = snapshot.value;

        data.forEach((roomId, roomData) {
          if (roomData is Map<String, dynamic>) { // Map 타입 확인
            if (roomData['participants'] != null && roomData['participants'][contactUserId.userId] != null) {
              ChatRoomDto chatRoom = ChatRoomDto.fromJson(roomData, int.parse(roomId));
              chatRooms.add(chatRoom);
            }
          }
        });
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
        ChatUserDto chatUserDto = ChatUserDto.fromJson(data, userId1);
        return chatUserDto;
      }
    } else {
      print('No data available.');

    }
    return ChatUserDto(nickname: "", profileImg: "", userId: "");
  }





  void createChatRoom(ChatUserDto myuid, ChatUserDto uid){
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

    ref.child(newChatroomId!).set(newChatroomData).then((_) {
      print("New chatroom added with key: $newChatroomId");
    }).catchError((error) {
      print("Error adding new chatroom: $error");
    });
  }

}
