import 'package:simda/models/Chat.dart';
import 'package:simda/models/User.dart';

class ChatRoom {
  final int chatRoomId;
  final Chat lchat;
  final User user1;
  final User user2;

  ChatRoom({
    required this.chatRoomId,
    required this.lchat,
    required this.user1,
    required this.user2,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      chatRoomId: json['chatRoomId'],
      lchat: json['lchat'],
      user1: json['user1'],
      user2: json['user2'],
    );
  }
}
