import 'dart:convert';

class UserDto {
  final String? bio;
  final String email;
  final String nickname;
  final String profileImg;
  final int userId;
  final int userRole;

  UserDto({
    this.bio,
    required this.email,
    required this.nickname,
    required this.profileImg,
    required this.userId,
    required this.userRole,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      bio: json['bio'],
      email: json['email'],
      nickname: json['nickname'],
      profileImg: json['profileImg'],
      userId: json['userId'],
      userRole: json['userRole'],
    );
  }
}
