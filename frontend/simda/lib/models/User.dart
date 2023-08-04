import 'dart:convert';

class User {
  final String email;
  final String nickname;
  final String profileImg;
  final int userId;
  final int userRole;

  User({
    required this.email,
    required this.nickname,
    required this.profileImg,
    required this.userId,
    required this.userRole,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        nickname: json['nickname'],
        profileImg: json['profileImg'],
        userId: json['userId'],
        userRole: json['userRole'],
    );
  }
}
