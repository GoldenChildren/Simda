package ssafy.a709.service;

import ssafy.a709.dto.UserDto;

import java.util.ArrayList;
import java.util.List;

public interface UserService {

    // 유저 검색(전체)
    List<UserDto> searchAllUser();

    // 유저 검색(동일 이름들)
    List<UserDto> searchUsers(String keyword);

    // 유저 정보 수정
    UserDto modifyUser(UserDto userDto);

    // 팔로우 요청
    boolean follow(UserDto userDto);

    // 팔로우 취소
    boolean unfollow(UserDto userDto);

    // 유저 프로필 조회
    UserDto searchUser();

    // 팔로우 목록 보기
    List<UserDto> searchFollow();

    // 팔로워 목록 보기
    List<UserDto> searchFollower();

}
