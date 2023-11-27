import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:simda/models/CommentDto.dart';
import 'package:simda/models/FeedDto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? baseUrl = dotenv.env['BASE_URL'];

class FeedProviders {
  Dio dio = Dio();
  String url = "$baseUrl/feed";

  // 내 주변, 24시간 이내의 피드를 가져오는 메소드
  Future<List<FeedDto>> getFeed(double lat, double lng) async {
    List<FeedDto> feed = [];

    final response = await dio.get(
        '$url/',
        queryParameters: {
          'lat' : lat,
          'lng' : lng
        });
    if (response.statusCode == 200) {
      feed = response.data['feedList'].map<FeedDto>((feeds) {
        return FeedDto.fromJson(feeds);
      }).toList();
    }

    for(FeedDto feedDto in feed){
      for(CommentDto commentDto in feedDto.comments??[]){
        for(CommentDto cCommentDto in commentDto.cCommentList??[]){
        }
      }
    }

    return feed;
  }

  // Feed 감정 분석 받는 메소드
  Future<FeedDto> getEmotion(FeedDto feedDto, String path) async{

    FormData formData = FormData.fromMap({
      'imgfile':
      await MultipartFile.fromFile(path, filename: 'feed.jpg'),
      'title': feedDto.title,
      'content': feedDto.content,
      'lat': feedDto.lat,
      'lng': feedDto.lng,
      'nickname': feedDto.nickname,
      'userId': feedDto.userId
    });

    Response response = await dio.post(
        '$baseUrl/bard',
        data : formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'})
    );


    return FeedDto.fromJson(response.data);
  }

  // Feed를 post하는 메소드
  Future<String> postFeed(FeedDto feedDto) async {

    Response response = await dio.post(
      '$url/',
      data: feedDto.toJson(),
      options: Options(
        headers: {'Content-Type': 'application/json'}, // Content-Type 설정
      ),
    );
    return response.data;
  }

  // feed 수정 메소드
  Future<void> modifyFeed(FeedDto feedDto) async {
    Response response = await dio.put(
        '$url/',
        data: feedDto
    );

  }

  Future<void> addLikes(FeedDto feedDto) async {
    await dio.put(
      '$url/like',
      data: feedDto.toJson(),
    );
  }

  // feed 삭제 메소드
  Future<void> deleteFeed(int feedId) async{
    Response response = await dio.delete(
        '$url/',
      options: Options(
        headers: {'feedId': feedId},
      ),
    );

  }

  // userId로 그 유저의 피드 목록을 가져오는 메소드
  Future<List<FeedDto>> getUserFeedList(int userId) async {
    List<FeedDto> feed = [];

    final response = await dio.get('$url/$userId');

    if (response.statusCode == 200) {
      feed = response.data['feedList'].map<FeedDto>((feeds) {
        return FeedDto.fromJson(feeds);
      }).toList();
    }

    return feed;
  }

  // userId로 그 유저의 팔로워들의 피드 목록을 가져오는 메소드
  Future<List<FeedDto>> getFollowFeedList(int userId) async {
    List<FeedDto> feed = [];

    final response = await dio.get(
        '$url/follow',
        queryParameters: {
          'userId' : userId
        }
    );

    if (response.statusCode == 200) {
      feed = jsonDecode(response.data)['feedList'].map<FeedDto>((feeds) {
        return FeedDto.fromJson(feeds);
      }).toList();
    }


    return feed;
  }


  // 좋아요 메소드
  Future<void> hitLikePoint(int feedId) async {
    final response = await dio.put(
        '$url/',
        queryParameters: {
          'feedId' : feedId
        });

  }
}