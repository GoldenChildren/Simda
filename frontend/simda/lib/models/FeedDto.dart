import 'UserDto.dart';

class FeedDto {
  final String content;
  final int emotion;
  final int feedId;
  final String img;
  final double lat;
  late int likeCnt;
  final double lng;
  final String nickname;
  final String regDate;
  final String title;
  final int userId;

  FeedDto({
    required this.content,
    required this.emotion,
    required this.feedId,
    required this.img,
    required this.lat,
    required this.likeCnt,
    required this.lng,
    required this.nickname,
    required this.regDate,
    required this.title,
    required this.userId,
  });

  factory FeedDto.fromJson(Map<String, dynamic> json) {
    return FeedDto(
      content: json['content'],
      emotion: json['emotion'],
      feedId: json['feedId'],
      img: json['img'],
      lat: json['lat'],
      likeCnt: json['likeCnt'],
      lng: json['lng'],
      nickname: json['nickname']??'',
      regDate: json['regDate']??'',
      title: json['title'],
      userId: json['userId'],
    );}

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "emotion": emotion,
      "feedId": feedId,
      "img": img,
      "lat": lat,
      "likeCnt": likeCnt,
      "lng": lng,
      "nickname": nickname,
      "regDate": regDate,
      "title": title,
      "userId": userId,
    };
  }
}