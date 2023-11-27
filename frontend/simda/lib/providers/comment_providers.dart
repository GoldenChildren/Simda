import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:simda/models/CommentDto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? baseUrl = dotenv.env['BASE_URL'];

class CommentProviders{

  Dio dio = Dio();
  String url = "$baseUrl/comment";

  Future<List<CommentDto>> getComment(int feedId) async {
    List<CommentDto> comment = [];

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

  Future<void> postComment(CommentDto commentDto) async {

    final response = await dio.post(
      "$url/",
      data: commentDto.toJson(),
      options: Options(headers: {'Content-Type': 'application/json'})
    );
  }

  Future<void> deleteComment(int commentId) async{
    final response = await dio.delete(
        "$url/",
        options: Options(headers: {'commentId': commentId})
    );
    print("댓글 삭제: ${response.statusCode}");
  }

}