import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:simda/models/CommentDto.dart';

class CommentProviders{

  String url = "http://i9a709.p.ssafy.io:8000/comment";
  Dio dio = Dio();

  Future<List<CommentDto>> getComment(int feedId) async {
    // Future<List<Feed>> getFeed(double lat, double lng) async {
    List<CommentDto> comment = [];

    // Dio dio = Dio();
    // uri += "$lat=$lat&lng=$lng";

    // final response = await http.get(Uri.parse(uri));
    final response = await dio.get("$url/",
        queryParameters: {
          'feedId' : feedId
        });

    if (response.statusCode == 200) {
      comment = jsonDecode(response.data)['commentList'].map<CommentDto>((comments) {
        return CommentDto.fromJson(comments);
      }).toList();
    }
    return comment;
  }

  Future<int> postComment(CommentDto feedDto) async {
    // Dio dio = Dio();

    final response = await dio.post(
      "$url/",
      data: feedDto
    );

    return response.data;
  }

  Future<void> deleteComment(int commentId) async{
    final response = await dio.delete(
        "$url/",
        queryParameters: {
          'commentId' : commentId
        });
  }
}