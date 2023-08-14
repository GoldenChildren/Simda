
import 'package:intl/intl.dart';

class LastChatDto {
  final String? text;
  final String? userId;
  final String? time;
  final bool? read;

  LastChatDto({
    required this.read,
    required this.text,
    required this.userId,
    required this.time,
  });

  factory LastChatDto.fromJson(Map<dynamic, dynamic> json) {
    // var format = new DateFormat('hh:mm');
    // var date = new DateTime.fromMillisecondsSinceEpoch(json['time']);
    return LastChatDto(
        read: json['read'],
        text: json['text'],
        userId: json['userId'],
        time: json['time'].toString(),
    );
  }
}
