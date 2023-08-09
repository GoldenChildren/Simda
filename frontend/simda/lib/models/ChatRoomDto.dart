
class ChatRoomDto {
  final Map<dynamic, dynamic> participants;
  final Map<dynamic, dynamic> lastMessage;

  ChatRoomDto({
    required this.participants,
    required this.lastMessage,
  });

  factory ChatRoomDto.fromJson(Map<dynamic, dynamic> json) {
    return ChatRoomDto(
      participants: json['participants'] ?? {},
      lastMessage: json['last_message'] ?? {},
    );
  }
}
