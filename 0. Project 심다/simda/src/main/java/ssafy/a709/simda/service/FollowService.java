package ssafy.a709.simda.service;

import ssafy.a709.simda.dto.FollowDto;
import ssafy.a709.simda.dto.UserDto;

import java.util.List;

public interface FollowService {

    // 팔로우 요청
    // 성공할 경우 true값 반환
    boolean follow(FollowDto followDto);

    // 팔로우 취소
    // 언팔 성공할 경우 true값 반환
    boolean unfollow(FollowDto followDto);

    // 팔로우 목록 보기
    List<UserDto> searchFollow(int userId);

    // 팔로워 목록 보기
    List<UserDto> searchFollower(int userId);

}
