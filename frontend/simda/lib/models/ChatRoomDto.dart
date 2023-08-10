
class ChatRoomDto {
  final Map<dynamic, dynamic> participants;
  final Map<dynamic, dynamic> lastMessage;
  final int chatroomId;
  ChatRoomDto({
    required this.participants,
    required this.lastMessage,
    required this.chatroomId,
  });

  factory ChatRoomDto.fromJson(Map<dynamic, dynamic> json, int chatroomId) {
    return ChatRoomDto(
      participants: json['participants'] ?? {},
      lastMessage: json['last_message'] ?? {},
      chatroomId: chatroomId,
    );
  }
}
