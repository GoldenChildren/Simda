package ssafy.a709.simda.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssafy.a709.simda.domain.User;
import ssafy.a709.simda.dto.UserDto;
import ssafy.a709.simda.repository.UserRepository;

import java.util.*;

@Slf4j
@Service
public class UserServiceImpl implements UserService {

    // Entity를 가져오기 위해서 Repo 불러오기
    @Autowired
    UserRepository userRepository;
    @Autowired
    FeedService feedService;
    @Autowired
    CommentService commentService;

    // 전체 유저를 조회한다
    @Override
    public List<UserDto> selectAllUser() {
        log.debug("selectAllUser 메서드 시작");
        // Entity Type의 User List를 하나 가져오고,
        List<User> userList = userRepository.findAll();

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
    public List<UserDto> selectUsers(String nickname) {
        log.debug("selectUsers 메서드 시작: nickname = {}", nickname);
        // 이름이 포함되는 유저를 검색해 온 User Entity 리스트 생성
        List<User> userList = userRepository.findAllByNicknameContaining(nickname);

        // Dto Type의 List 생성
        List<UserDto> userDtoList = new ArrayList<>();

        // User Entity -> UserDto로 변환해서 List에 담는다
        for(User u : userList) {
            if(u.getUserRole() == 2) {
                continue;
            }
            userDtoList.add(UserDto.changeToUserDto(u));
        }

        // User Dto Type의 List 반환
        return userDtoList;
    }

    // 닉네임 중복검사
    @Override
    public boolean selectUserByNickname(String nickname) {
        log.debug("selectUserByNickname 메서드 시작: nickname = {}", nickname);
        // 닉네임이 동일한 유저가 있는지 확인해서 있으면 false, 없으면 true를 반환
        User user = userRepository.findByNickname(nickname);
        log.debug("selectUserByNickname 메서드: user 정보 = {}", user);

        return user == null;
    }

    // 로그인시 DB에 Email check과 함께 DB에 저장된 정보를 반환
    @Override
    public UserDto selectUserByEmail(String email) {
        log.debug("selectUserByEmail 메서드 시작: email = {}", email);
        // 이메일이 동일한 유저가 있는지 확인해서 있으면 false, 없으면 true를 반환
        User user = userRepository.findByEmail(email);


        if(user == null) {
            log.error("selectUserByEmail 메서드 오류: user를 찾을 수 없습니다.");
            return null;
        }
        log.debug("selectUserByEmail 메서드: user 정보 = {}",user);

        // user값을 찾아서, Dto형태로 반환
        return UserDto.changeToUserDto(user);
    }

    // User정보 수정, 실패와 성공을 반환한다
    @Override
    public boolean updateUser(UserDto userDto) {
        log.debug("updateUser 메서드 시작: userDto = {}", userDto);
        try {
            // User Repo에서 id를 통해 해당 User의 Entity를 가져오기
            log.debug("updateUser 메서드: user 수정 정보 = {}", userDto);
            User nowUser = userRepository.findByUserId(userDto.getUserId());

            // 닉네임, 프로필 사진 BIO 수정
            nowUser.setProfileImg(userDto.getProfileImg());
            nowUser.setBio(userDto.getBio());
            nowUser.setNickname(userDto.getNickname());
            nowUser.setUserRole(userDto.getUserRole());

            // 유저가 탈퇴된 상황이면 userRole을 1로 변경한다
            if(selectRole(nowUser.getEmail()) == 2) {
                log.debug("updateUser 메서드: 유저 재가입");
                nowUser = userRepository.findByEmail(userDto.getEmail());
                nowUser.setUserRole(1);
            }
            log.debug("updateUser 메서드 결과: user 수정된 정보 = {}", nowUser);

            // userRepo에서 변경된 부분을 저장한다.
            userRepository.save(nowUser);

        } catch(Exception e) {
            // 실패를 출력
            log.error("updateUser 메서드 오류: {}", e.getMessage());
            return false;
        }

        return true;
    }

    // 닉네임이 일치하는 한 명의 유저를 조회한다
    @Override
    public UserDto selectOneUser(int userId) {
        log.debug("selectOneUser 메서드 시작: userId = {}", userId);
        // UserRepo에서 동일한 nickname으로 찾아오기
        User user = userRepository.findByUserId(userId);

        log.debug("selectOneUser 메서드: user 정보 = {}", user);
        // Entity를 Dto로 변환
        // User Dto 반환
        return UserDto.changeToUserDto(user);
    }

    // 유저 회원 등록
    @Override
    public void createUser(UserDto userDto) {
        log.debug("createUser 메서드 시작: userDto = {}", userDto);
        User user = User.changeToUser(userDto);
        log.debug("createUser 메서드: user 정보 = {}", user);

        userRepository.save(user);
    }

    // 유저를 탈퇴처리한다
    // nickname = "탈퇴한 유저입니다", userRole = 2, profile img = ""
    @Override
    public boolean deleteUser(int userId) {
        log.debug("deleteUser 메서드 시작: userId = {}", userId);
        // userId로 현재 유저를 조회
        User user = userRepository.findByUserId(userId);
        if(user == null) {
            log.error("deleteUser 메서드 오류: user를 찾을 수 없습니다.");
            return false;
        } else {
            user.setNickname(user.getEmail());
            user.setUserRole(2);
            user.setProfileImg("");
            log.debug("deleteUser 메서드: user 정보 = {}", user);
            userRepository.save(user);
            return true;
        }
    }

    // userRole을 db에서 가져오기
    @Override
    public int selectRole(String email) {
        log.debug("selectRole 메서드 시작: email = {}", email);
        return userRepository.findByEmail(email).getUserRole();
    }


}
