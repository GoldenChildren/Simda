import 'User.dart';

class Feed {
  final String content;
  final int emotion;
  final int feedId;
  final String img;
  final double lat;
  late int likeCnt;
  final double lng;
  final String regDate;
  final String title;
  final User userDto;

  Feed({
    required this.content,
    required this.emotion,
    required this.feedId,
    required this.img,
    required this.lat,
    required this.likeCnt,
    required this.lng,
    required this.regDate,
    required this.title,
    required this.userDto,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      content: json['content'],
      emotion: json['emotion'],
      feedId: json['feedId'],
      img: json['img'],
      lat: json['lat'],
      likeCnt: json['likeCnt'],
      lng: json['lng'],
      regDate: json['regDate'],
      title: json['title'],
      userDto: json['userDto'],
    );}
}
