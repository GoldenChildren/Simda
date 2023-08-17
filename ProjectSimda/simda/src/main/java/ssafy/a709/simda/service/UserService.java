package ssafy.a709.simda.service;

import ssafy.a709.simda.dto.UserDto;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

public interface UserService {

    // 유저 검색(전체)
    List<UserDto> selectAllUser();

    // 유저 검색(동일 이름들)
    List<UserDto> selectUsers(String nickname);

    // 닉네임 중복 체크
    boolean selectUserByNickname(String nickname);

    // Email 중복 체크
    UserDto selectUserByEmail(String email);

    // 유저 정보 수정
    boolean updateUser(UserDto userDto);

    // 유저 검색(id로)
    UserDto selectOneUser(int userId);

    // 유저 회원가입
    void createUser(UserDto userDto);

    // 유저의 Role을 2로 바꾸는.
    boolean deleteUser(int userId);

    int selectRole(String email);

}
