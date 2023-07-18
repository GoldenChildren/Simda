package ssafy.a709.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssafy.a709.domain.User;
import ssafy.a709.dto.UserDto;
import ssafy.a709.repository.UserRepository;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    // Entity를 가져오기 위해서 Repo 불러오기
    @Autowired
    UserRepository ur;

    // 전체 유저를 조회한다
    @Override
    public List<UserDto> selectAllUser() {
        // Entity Type의 User List를 하나 가져오고,
        List<User> userList = ur.findAll();

        // Dto Type의 List를 생성
        List<UserDto> userDtoList = new ArrayList<>();

        // User Entity -> UserDto로 변환해서 List에 담는다
        for(User u : userList) {
            userDtoList.add(UserDto.changeToUserDto(u));
        }

        // User Dto Type의 List 반환
        return userDtoList;
    }

    // 검색한 닉네임이 포함되는 유저들을 조회한다
    @Override
    public List<UserDto> selectUsers(String keyword) {

        // 이름이 포함되는 유저를 검색해 온 User Entity 리스트 생성
        List<User> userList = ur.findByNicknameLike(keyword);

        // Dto Type의 List 생성
        List<UserDto> userDtoList = new ArrayList<>();

        // User Entity -> UserDto로 변환해서 List에 담는다
        for(User u : userList) {
            userDtoList.add(UserDto.changeToUserDto(u));
        }
        
        // User Dto Type의 List 반환
        return userDtoList;
    }
    
    // User정보 수정
    @Override
    public UserDto modifyUser(UserDto userDto) {
        return null;
    }

    // 닉네임이 일치하는 한 명의 유저를 조회한다
    @Override
    public UserDto selectOneUser(String keyword) {
        // UserRepo에서 동일한 nickname으로 찾아오기
        User user = ur.findByNickname(keyword);
        
        // Entity를 Dto로 변환
        UserDto userDto = UserDto.changeToUserDto(user);

        // User Dto 반환
        return userDto;
    }
}
