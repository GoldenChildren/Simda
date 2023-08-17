import 'UserDto.dart';

class FollowDto {
  final int ? followId;
  final UserDto fromUserId;
  final UserDto toUserId;

  FollowDto({
    this.followId,
    required this.fromUserId,
    required this.toUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'followId': followId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
    };
  }

  // factory FollowDto.fromJson(Map<String, dynamic> json) {
  //   return FollowDto(
  //       followId: json['followId'],
  //       fromUserId: json['fromUserId'],
  //       toUserId: json['toUserId'],
  //   );
  // }
}