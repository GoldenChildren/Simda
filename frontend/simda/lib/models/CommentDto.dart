class CommentDto {
  final List commentList;
  final int cmtId;
  final String content;
  final int feedId;
  final int pcmtId;
  final int userId;

  CommentDto({
    required this.commentList,
    required this.cmtId,
    required this.content,
    required this.feedId,
    required this.pcmtId,
    required this.userId,
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    return CommentDto(
      content: json['content'],
      cmtId: json['cmtId'],
      commentList: json['commentList'],
      feedId: json['feedId'],
      pcmtId: json['pcmtId'],
      userId: json['userId'],
    );
  }
}
