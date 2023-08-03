import 'dart:convert';

import 'package:simda/models/ChatDto.dart';
import 'package:simda/models/ChatRoomDto.dart';
import 'package:http/http.dart' as http;

class ChatProviders {
  Future<List<ChatDto>> getChat(ChatRoomDto chatroom) async {
    List<ChatDto> chat = [];
    String uri = "http://i9a709.p.ssafy.io:8000/simda/chat/";
    uri += "${chatroom.chatRoomId}";

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      chat = jsonDecode(response.body)['chats'].map<ChatDto>((chats) {
        return ChatDto.fromJson(chats);
      }).toList();
    }

    return chat;
  }
}
