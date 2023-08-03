import 'UserDto.dart';

class FollowDto {
  final int followId;
  final UserDto fromUserId;
  final UserDto toUserId;

  FollowDto({
    required this.followId,
    required this.fromUserId,
    required this.toUserId,
  });
}