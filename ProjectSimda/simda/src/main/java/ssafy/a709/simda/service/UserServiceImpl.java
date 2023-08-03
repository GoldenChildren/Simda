package ssafy.a709.simda.service;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.firebase.cloud.FirestoreClient;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssafy.a709.simda.domain.User;
import ssafy.a709.simda.dto.UserDto;
import ssafy.a709.simda.repository.UserRepository;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;
import java.util.concurrent.ExecutionException;

@Service
public class UserServiceImpl implements UserService {

    // Entity를 가져오기 위해서 Repo 불러오기
    @Autowired
    UserRepository userRepository;

    // 전체 유저를 조회한다
    @Override
    public List<UserDto> selectAllUser() {
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

        // 이름이 포함되는 유저를 검색해 온 User Entity 리스트 생성
        List<User> userList = userRepository.findAllByNicknameContaining(nickname);

        // Dto Type의 List 생성
        List<UserDto> userDtoList = new ArrayList<>();

        // User Entity -> UserDto로 변환해서 List에 담는다
        for(User u : userList) {
            userDtoList.add(UserDto.changeToUserDto(u));
        }
        
        // User Dto Type의 List 반환
        return userDtoList;
    }

    // 닉네임 중복검사
    @Override
    public boolean selectUserByNickname(String nickname) {
        // 닉네임이 동일한 유저가 있는지 확인해서 있으면 false, 없으면 true를 반환
        User user = userRepository.findByNickname(nickname);

        return user == null;
    }

    // 로그인시 DB에 Email check과 함께 DB에 저장된 정보를 반환
    @Override
    public UserDto selectUserByEmail(String email) {

        // 닉네임이 동일한 유저가 있는지 확인해서 있으면 false, 없으면 true를 반환
        System.out.println("repo "+ email);
        User user = userRepository.findByEmail(email);

        if(user == null) {
            return null;
        }

        // user값을 찾아서, Dto형태로 반환
        return UserDto.changeToUserDto(user);
    }

    // User정보 수정, 실패와 성공을 반환한다
    @Override
    public boolean updateUser(UserDto userDto) {
        try {
            System.out.println("UserServiceImpl updateUser 진입");
            // User Repo에서 id를 통해 해당 User의 Entity를 가져오기
            System.out.println("현재 유저의 Id를 가져오는가? : "+ userDto.getUserId());
            User nowUser = userRepository.findByUserId(userDto.getUserId());

            // 닉네임, 프로필 사진 두 개만 변경이 가능하다
            nowUser.setProfileImg(userDto.getProfileImg());
            nowUser.setNickname(userDto.getNickname());
            nowUser.setUserRole(userDto.getUserRole());

            System.out.println("UserService에서 eamil을 가져오는가? "+ nowUser.getEmail());
            System.out.println("그때의 유저 Role은? "+ selectRole(nowUser.getEmail()));

            if(selectRole(nowUser.getEmail()) == 2) {
                nowUser = userRepository.findByEmail(userDto.getEmail());
                System.out.println("UserServiceImpl의 120까지 오나?");
                nowUser.setUserRole(1);
            }
            // userRepo에서 변경된 부분을 저장한다.
            userRepository.save(nowUser);

        } catch(Exception e) {
            // 실패를 출력
            System.out.println("실패");
            return false;
        }

        return true;
    }

    // 닉네임이 일치하는 한 명의 유저를 조회한다
    @Override
    public UserDto selectOneUser(int userId) {
        // UserRepo에서 동일한 nickname으로 찾아오기
        User user = userRepository.findByUserId(userId);
        
        // Entity를 Dto로 변환

        // User Dto 반환
        return UserDto.changeToUserDto(user);
    }
    
    // 유저 회원 등록
    @Override
    public void createUser(UserDto userDto) {
        User user = User.changeToUser(userDto);

        userRepository.save(user);
    }

    // 유저를 탈퇴처리한다
    // nickname = "탈퇴한 유저입니다", userRole = 2, profile img = ""
    @Override
    public boolean deleteUser(int userId) {
        System.out.println("UserService 155 : 유저를 delete 처리합니다.");
        // userId로 현재 유저를 조회
        User user = userRepository.findByUserId(userId);
        if(user == null) {
            return false;
        } else {
            user.setNickname(user.getEmail());
            user.setUserRole(2);
            user.setProfileImg("");
            userRepository.save(user);
            return true;
        }
    }

    // userRole을 db에서 가져오기
    @Override
    public int selectRole(String email) {
        return userRepository.findByEmail(email).getUserRole();
    }


}
