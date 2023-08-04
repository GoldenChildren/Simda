import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:simda/models/FeedDto.dart';
import 'package:simda/models/UserDto.dart';
import 'package:http/http.dart' as http;

class FeedProviders {
  // String uri = "http://i9a709.p.ssafy.io:8000/feed/?";
  String ip = "http://i9a709.p.ssafy.io:8000";

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

  Future<int> postFeed(FeedDto feedDto, String path) async {
    Dio dio = Dio();
    var url = "$ip/feed/";

    FormData formData = FormData.fromMap({
      'imgfile': await MultipartFile.fromFile(path, filename: 'feed.jpg'),
      'title': feedDto.title,
      'content': feedDto.content,
      'lat': feedDto.lat,
      'lng': feedDto.lng,
      'userDto.userId': feedDto.userId
    });

    Response response = await dio.post(
      url,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );

    return response.data;
  }

  void removeFeed(int feedId) async {
    String uri = "$ip/feed/";
    uri += "$feedId";

    final response = await http.delete(Uri.parse(uri));

    if (response.statusCode == 200) {
      print("Success!");
    }
  }
}
