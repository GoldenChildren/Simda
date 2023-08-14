import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:simda/models/CommentDto.dart';
import 'package:simda/models/FeedDto.dart';

class FeedProviders {
  Dio dio = Dio();
  String url = "http://i9a709.p.ssafy.io:8000/feed";
  // String url = "http://70.12.247.215:8000/feed";


  // Uri uri = Uri.parse(
  //     "http://i9a709.p.ssafy.io:8000/feed/?lat=37.5013068&lng=127.0396597");


  // 내 주변, 24시간 이내의 피드를 가져오는 메소드
  Future<List<FeedDto>> getFeed(double lat, double lng) async {
    // Future<List<Feed>> getFeed(double lat, double lng) async {
    List<FeedDto> feed = [];

    // final response = await http.get(url);
    final response = await dio.get(
        '$url/',
        queryParameters: {
          'lat' : lat,
          'lng' : lng
        });
    if (response.statusCode == 200) {
      print(response.data);
      feed = response.data['feedList'].map<FeedDto>((feeds) {
        return FeedDto.fromJson(feeds);
      }).toList();
      print("여기야");
      print(feed);
    }

    for(FeedDto feedDto in feed){
      print('feedId : ${feedDto.feedId}');
      for(CommentDto commentDto in feedDto.comments??[]){
        print('cmt id : ${commentDto.cmtId}');
        for(CommentDto cCommentDto in commentDto.cCommentList??[]){
          print('ccmt id : ${cCommentDto.cmtId} : ${cCommentDto.content}');
        }
      }
    }

    return feed;
  }

  // Feed 감정 분석 받는 메소드
  Future<FeedDto> getEmotion(FeedDto feedDto, String path) async{
    print('getEmotion');
    print(feedDto.title);
    print(feedDto.nickname);

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
        'http://i9a709.p.ssafy.io:8000/bard',
        data : formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'})
    );

    // print(jsonDecode(response.data));
    print(response.statusCode);
    print(FeedDto.fromJson(response.data));

    return FeedDto.fromJson(response.data);
  }

  // Feed를 post하는 메소드
  Future<String> postFeed(FeedDto feedDto) async {

    // FormData formData = FormData.fromMap({
    //   'imgfile':
    //   await MultipartFile.fromFile(path, filename: 'feed.jpg'),
    //   'title': feedDto.title,
    //   'content': feedDto.content,
    //   'lat': feedDto.lat,
    //   'lng': feedDto.lng,
    //   'userDto.userId': feedDto.userId
    // });

    // Response response = await dio.post('$url/', data: formData, options: Options(headers: {'Content-Type': 'multipart/form-data'}),);

    Response response = await dio.post(
      '$url/',
      data: feedDto.toJson(),
      options: Options(
        headers: {'Content-Type': 'application/json'}, // Content-Type 설정
      ),
    );

    print(response.data);
    print(response.statusCode);

    return response.data;
  }

  // feed 수정 메소드
  Future<void> modifyFeed(FeedDto feedDto) async{
    Response response = await dio.put(
        '$url/',
        data: feedDto
    );

    print('피드 수정 : $response');
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
        headers: {'feedId': feedId.toString()},
      ),
    );

    print('피드 삭제 : $response');
  }

  // userId로 그 유저의 피드 목록을 가져오는 메소드
  Future<List<FeedDto>> getUserFeedList(int userId) async{
    List<FeedDto> feed = [];

    final response = await dio.get('$url/$userId');

    if (response.statusCode == 200) {
      feed = response.data['feedList'].map<FeedDto>((feeds) {
        return FeedDto.fromJson(feeds);
      }).toList();
    }

    print('user\'s feedList : $response');

    return feed;
  }

  // userId로 그 유저의 팔로워들의 피드 목록을 가져오는 메소드
  Future<List<FeedDto>> getFollowFeedList(int userId) async{
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

    print('follower\'s feedList : $response');

    return feed;
  }


  // 좋아요 메소드
  Future<void> hitLikePoint(int feedId) async{
    final response = await dio.put(
        '$url/',
        queryParameters: {
          'feedId' : feedId
        });

    print('좋아요 누르기 : $response');
  }
}