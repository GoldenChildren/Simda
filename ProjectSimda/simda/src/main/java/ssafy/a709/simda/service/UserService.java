package ssafy.a709.simda.service;

import ssafy.a709.simda.dto.UserDto;

import java.util.List;
import java.util.concurrent.ExecutionException;

public interface UserService {

    // 유저 검색(전체)
    List<UserDto> selectAllUser();

    // 유저 검색(동일 이름들)
    List<UserDto> selectUsers(String keyword);

    // 닉네임 중복 체크
    boolean checkNickname(String keyword);

    // Email 중복 체크
    public boolean checkEmail(String keyword);

    // 유저 정보 수정
    boolean modifyUser(UserDto userDto);

    // 유저 검색(one)
    UserDto selectOneUser(int userId);

//    List<UserDto> testUser() throws ExecutionException, InterruptedException;


}
