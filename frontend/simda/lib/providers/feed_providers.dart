import 'dart:convert';

import 'package:simda/models/FeedDto.dart';
import 'package:simda/models/UserDto.dart';
import 'package:http/http.dart' as http;

class FeedProviders {
  // String uri = "http://i9a709.p.ssafy.io:8000/feed/?";

  Uri uri = Uri.parse(
      "http://i9a709.p.ssafy.io:8000/feed/?lat=37.5013068&lng=127.0396597");

  Future<List<FeedDto>> getFeed() async {
    // Future<List<Feed>> getFeed(double lat, double lng) async {
    List<FeedDto> feed = [];

    // uri += "$lat=$lat&lng=$lng";

    // final response = await http.get(Uri.parse(uri));
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      feed = jsonDecode(response.body)['feeds'].map<FeedDto>((feeds) {
        return FeedDto.fromJson(feeds);
      }).toList();
    }
    return feed;
  }

  Future<Map<String, dynamic>> postFeed(
      String content,
      int emotion,
      // int feedId,
      String img,
      double lat,
      // int likeCnt,
      double lng,
      String nickname,
      // String regDate,
      String title,
      int userId) async {
    var response = await http.post(
      Uri.parse('http://i9a709.p.ssafy.io:8000/feed/'),
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "content": content,
        "emotion": emotion,
        // "feedId": feedId,
        "img": img,
        "lat": lat,
        // "likeCnt": likeCnt,
        "lng": lng,
        "nickname": nickname,
        // "regDate": regDate,
        "title": title,
        "userId": userId,
      }),
    );
    return json.decode(response.body);
  }
}
