import 'dart:convert';

import 'package:simda/models/Feed.dart';
import 'package:http/http.dart' as http;

class FeedProviders {

  // String uri = "http://i9a709.p.ssafy.io:8000/feed/?";

  Uri uri = Uri.parse("http://i9a709.p.ssafy.io:8000/feed/?lat=37.5013068&lng=127.0396597");

  Future<List<Feed>> getFeed() async {
  // Future<List<Feed>> getFeed(double lat, double lng) async {
    List<Feed> feed = [];

    // uri += "${uri}lat=$lat&lng=$lng";

    // final response = await http.get(Uri.parse(uri));
    final response = await http.get(uri);

    if (response.statusCode == 200) {

      feed = jsonDecode(response.body)['feeds'].map<Feed>((feeds) {
        return Feed.fromJson(feeds);
      }).toList();
    }
    return feed;
  }
}
