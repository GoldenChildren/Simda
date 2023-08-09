
class ChatDto {
  final int chatId;
  final int chatRoomId;
  final int userId;
  final String nickName;
  final String content;
  final String regDate;
  final int readFlag;

  ChatDto({
    required this.chatId,
    required this.chatRoomId,
    required this.userId,
    required this.nickName,
    required this.content,
    required this.readFlag,
    required this.regDate,
  });

  factory ChatDto.fromJson(Map<String, dynamic> json) {
    return ChatDto(
        chatId: json['chatId'],
        chatRoomId: json['chatRoomId'],
        userId: json['userId'],
        nickName: json['nickName'],
        content: json['content'],
        readFlag: json['readFlag'],
        regDate: json['regDate']
    );
  }
}
