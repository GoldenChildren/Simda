import 'ChatRoomDto.dart';
import 'UserDto.dart';

class ChatDto {
  final int chatId;
  final ChatRoomDto chatRoom;
  final String content;
  final int readFlag;
  final String regDate;
  final UserDto user;

  ChatDto({
    required this.chatId,
    required this.chatRoom,
    required this.content,
    required this.readFlag,
    required this.regDate,
    required this.user,
  });

  factory ChatDto.fromJson(Map<String, dynamic> json) {
    return ChatDto(
      chatId: json['chatId'],
      chatRoom: json['chatRoom'],
      content: json['content'],
      readFlag: json['readFlag'],
      regDate: json['regDate'],
      user: json['user'],
    );
  }
}
