package ssafy.a709.simda.service;

import ssafy.a709.simda.dto.UserDto;

import java.util.List;

public interface UserService {

    // 유저 검색(전체)
    List<UserDto> selectAllUser();

    // 유저 검색(동일 이름들)
    List<UserDto> selectUsers(String keyword);

    // 닉네임 중복 체크
    boolean checkNickname(String keyword);

    // 유저 정보 수정
    boolean modifyUser(UserDto userDto);

    // 유저 검색(one)
    UserDto selectOneUser(int userId);


}
