import 'package:simda/models/ChatDto.dart';
import 'package:simda/models/UserDto.dart';

class ChatRoomDto {
  final int chatRoomId;
  final ChatDto lchat;
  final UserDto user1;
  final UserDto user2;

  ChatRoomDto({
    required this.chatRoomId,
    required this.lchat,
    required this.user1,
    required this.user2,
  });

  factory ChatRoomDto.fromJson(Map<String, dynamic> json) {
    return ChatRoomDto(
      chatRoomId: json['chatRoomId'],
      lchat: json['lchat'],
      user1: json['user1'],
      user2: json['user2'],
    );
  }
}
