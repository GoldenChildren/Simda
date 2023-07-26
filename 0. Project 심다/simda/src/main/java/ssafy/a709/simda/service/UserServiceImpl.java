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

//    @Override
//    public List<UserDto> testUser() throws ExecutionException, InterruptedException{
//        final String COLLECTION_NAME = "users";
//
//        List<UserDto> list = new ArrayList<>();
//        Firestore db = FirestoreClient.getFirestore();
//        ApiFuture<QuerySnapshot> future = db.collection(COLLECTION_NAME).get();
//        List<QueryDocumentSnapshot> documents = future.get().getDocuments();
//        for (QueryDocumentSnapshot document : documents) {
//            list.add(document.toObject(UserDto.class));
//
//        }
//
//        return list;
//    }

    // 검색한 닉네임이 포함되는 유저들을 조회한다
    @Override
    public List<UserDto> selectUsers(String keyword) {

        // 이름이 포함되는 유저를 검색해 온 User Entity 리스트 생성
        List<User> userList = userRepository.findByNicknameLike(keyword);

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
    public boolean selectUserByNickname(String keyword) {
        // 닉네임이 동일한 유저가 있는지 확인해서 있으면 false, 없으면 true를 반환
        User user = userRepository.findByNickname(keyword);

        return user == null;
    }

    // 로그인시 DB에 Email check
    @Override
    public boolean selectUserByEmail(String keyword) {
        // 닉네임이 동일한 유저가 있는지 확인해서 있으면 false, 없으면 true를 반환
        System.out.println("repo "+ keyword);
        User user = userRepository.findByEmail(keyword);
        System.out.println(user);
        if(user == null) return false;
        return true;
    }

    // User정보 수정, 실패와 성공을 반환한다
    @Override
    public boolean updateUser(UserDto userDto) {
        try {
            // User Repo에서 id를 통해 해당 User의 Entity를 가져오기
            User nowUser = userRepository.findByUserId(userDto.getUserId());

            // 닉네임, 프로필 사진 두 개만 변경이 가능하다
            nowUser.setProfileImg(userDto.getProfileImg());
            nowUser.setNickname(userDto.getNickname());

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

    @Override
    public void createUser(UserDto userDto) {
        User user = User.changeToUser(userDto);

        userRepository.save(user);
    }

}
