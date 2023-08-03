import 'ChatRoom.dart';
import 'User.dart';

class Chat {
  final int chatId;
  final ChatRoom chatRoom;
  final String content;
  final int readFlag;
  final String regDate;
  final User user;

  Chat({
    required this.chatId,
    required this.chatRoom,
    required this.content,
    required this.readFlag,
    required this.regDate,
    required this.user,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chatId'],
      chatRoom: json['chatRoom'],
      content: json['content'],
      readFlag: json['readFlag'],
      regDate: json['regDate'],
      user: json['user'],
    );
  }
}
