import 'package:simda/models/UserDto.dart';

class CommentDto {
  final List<CommentDto>? cCommentList;
  final int cmtId;
  final String content;
  final int feedId;
  final int? pcmtId;
  final String regTime;
  final UserDto userDto;

  CommentDto({
    this.cCommentList,
    required this.cmtId,
    required this.content,
    required this.feedId,
    this.pcmtId,
    required this.regTime,
    required this.userDto
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    // print((json['cCommentList'] as List<dynamic>?)
    //     ?.map((e) => CommentDto.fromJson(e))
    //     .toList());
    // print((json['ccommentList'] as List<dynamic>?)
    //     ?.map((e) => CommentDto.fromJson(e))
    //     .toList());
    // print((json['commentList'] as List<dynamic>?)
    //     ?.map((e) => CommentDto.fromJson(e))
    //     .toList());
    return CommentDto(
      content: json['content'],
      cmtId: json['cmtId'],
      cCommentList: (json['ccommentList'] as List<dynamic>?)
          ?.map((e) => CommentDto.fromJson(e))
          .toList(),
      feedId: json['feedId'],
      pcmtId: json['pcmtId'],
      regTime: json['regTime'],
      userDto: UserDto.fromJson(json['userDto']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cCommentList': cCommentList??[],
      'cmtId': cmtId,
      'content': content,
      'feedId': feedId,
      'pcmtId': pcmtId,
      'regTime': regTime,
      'userDto': userDto.toJson(),
    };
  }
}
