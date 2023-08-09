
class ChatRoomDto {
  final int chatRoomId;
  final int user1Id;
  final String user1nickName;
  final String user1Img;
  final int user2Id;
  final String user2nickName;
  final String user2Img;
  final String lChatContent;
  final int lChatUserId;
  final int lChatId;
  final String lChatTime;

  ChatRoomDto({
    required this.chatRoomId,
    required this.user1Id,
    required this.user1nickName,
    required this.user1Img,
    required this.user2Id,
    required this.user2nickName,
    required this.user2Img,
    required this.lChatContent,
    required this.lChatUserId,
    required this.lChatId,
    required this.lChatTime,
  });

  factory ChatRoomDto.fromJson(Map<String, dynamic> json) {
    if(json['lChatId'] ==null){
      ChatRoomDto chatRoomDto = ChatRoomDto(
          chatRoomId: json['chatRoomId'],
          user1Id: json['user1Id'],
          user1nickName: json['user1nickName'],
          user1Img: json['user1Img'],
          user2Id: json['user2Id'],
          user2nickName: json['user2nickName'],
          user2Img: json['user2Img'],
          lChatContent: "내용 없음",
          lChatUserId: 0,
          lChatId: 0,
          lChatTime:""
      );

      return chatRoomDto;
    }

    ChatRoomDto chatRoomDto = ChatRoomDto(
        chatRoomId: json['chatRoomId'],
        user1Id: json['user1Id'],
        user1nickName: json['user1nickName'],
        user1Img: json['user1Img'],
        user2Id: json['user2Id'],
        user2nickName: json['user2nickName'],
        user2Img: json['user2Img'],
        lChatContent: json['lChatContent'],
        lChatUserId: json['lChatUserId'],
        lChatId: json['lChatId'],
        lChatTime: json['lChatTime']
    );

    return chatRoomDto;
  }
}
