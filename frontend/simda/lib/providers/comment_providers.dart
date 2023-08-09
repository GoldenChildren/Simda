import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:simda/models/CommentDto.dart';

class CommentProviders{

  Dio dio = Dio();
  // String url = "http://i9a709.p.ssafy.io:8000/comment";
  String url = "http://70.12.247.215:8000/comment";

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

  Future<int> postComment(CommentDto commentDto) async {
    // Dio dio = Dio();

    final response = await dio.post(
      "$url/",
      data: commentDto.toJson(),
      options: Options(headers: {'Content-Type': 'application/json'})
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