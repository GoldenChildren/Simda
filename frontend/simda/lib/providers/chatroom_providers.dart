import 'dart:convert';

import 'package:simda/models/ChatRoomDto.dart';
import 'package:simda/models/UserDto.dart';
import 'package:http/http.dart' as http;

class ChatRoomProviders {
  Future<List<ChatRoomDto>> getChatRoom(UserDto user) async {
    List<ChatRoomDto> chatroom = [];
    String uri = "http://i9a709.p.ssafy.io:8000/simda/chat/rooms/";
    uri += "${user.userId}";

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      chatroom =
          jsonDecode(response.body)['chatrooms'].map<ChatRoomDto>((chatrooms) {
        return ChatRoomDto.fromJson(chatrooms);
      }).toList();
    }

    return chatroom;
  }
}
