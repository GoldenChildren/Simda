


class ChatUserDto {
  final String nickname;
  final String profileImg;
  final String userId;

  ChatUserDto({
    required this.userId,
    required this.nickname,
    required this.profileImg,
  });

  factory ChatUserDto.fromJson(Map<dynamic, dynamic> json, dynamic userId) {
    return ChatUserDto(
      userId: userId,
      nickname: json['nickname'] ?? "",
      profileImg: json['profileImg'] ?? "",
    );
  }
}
