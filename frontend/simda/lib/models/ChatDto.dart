
import 'package:intl/intl.dart';

class ChatDto {
  final String chatId;
  final String text;
  final String userId;
  final String time;

  ChatDto({
    required this.chatId,
    required this.text,
    required this.userId,
    required this.time,
  });

  factory ChatDto.fromJson(Map<dynamic, dynamic> json, String inputChatId) {
    // var format = new DateFormat('hh:mm');
    // var date = new DateTime.fromMillisecondsSinceEpoch(json['time']);
    return ChatDto(
        chatId: inputChatId,
        text: json['text'],
        userId: json['userId'],
        time: json['time'].toString(),
    );
  }
}
