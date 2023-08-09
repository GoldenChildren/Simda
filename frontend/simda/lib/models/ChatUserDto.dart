
class ChatUserDto {
  final String nickname;
  final String profileImg;

  ChatUserDto({
    required this.nickname,
    required this.profileImg,
  });

  factory ChatUserDto.fromJson(Map<String, dynamic> json) {
    return ChatUserDto(
      nickname: json['nickname'] ?? "",
      profileImg: json['profileImg'] ?? "",
    );
  }
}
