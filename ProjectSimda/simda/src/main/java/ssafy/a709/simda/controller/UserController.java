package ssafy.a709.simda.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.google.api.client.json.Json;
import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import ssafy.a709.simda.dto.FollowDto;
import ssafy.a709.simda.dto.TokenDto;
import ssafy.a709.simda.dto.UserDto;
import ssafy.a709.simda.service.ApiService;
import ssafy.a709.simda.service.FileService;
import ssafy.a709.simda.service.FollowService;
import ssafy.a709.simda.service.UserService;

import java.io.File;
import java.util.List;

import java.util.Map;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/user")
public class UserController {

    private static final String SUCCESS = "success";
    private static final String FAIL = "fail";

    @Autowired
    UserService userService;

    @Autowired
    FollowService followService;

    @Autowired
    ApiService apiService;

    @Autowired
    FileService fileService;

    /*
    Follow Controller를 따로 만드는 대신
    User Controller에서 둘 다 관리하는 것으로 하자
    Why? API 명세서에 다 /user로 시작하기 때문에 굳이 안나눠도 될 것 같아
    Follow는 다 User 화면과 관련되어 있기 때문에... 데이터를 가공하는 Service만 나눴구요
    */

    // 유저 닉네임 중복 검사
    @GetMapping("/check")
    public ResponseEntity<String> checkNickname(@RequestParam String nickname) {
        // String type의 nickname을 받아와서 DB와 비교
        if (userService.selectUserByNickname(nickname)) {
            return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
        }
        return new ResponseEntity<>(FAIL, HttpStatus.NOT_ACCEPTABLE);
    }

    // 유저 - 검색 keyword를 통해 닉네임을 포함하는 유저를 전체 반환
    @GetMapping("/search")
    public ResponseEntity<List<UserDto>> getUsers(@RequestParam String nickname) {

        // 키워드를 포함하는 닉네임을 받아올 유저들의 리스트 생성
        List<UserDto> userDtoList = userService.selectUsers(nickname);

        // 만약 userDtoList의 size가 0이라면, 검색 결과가 없는 것이므로, notFound 반환
        if (userDtoList.size() == 0) {
            return ResponseEntity.notFound().build();
        }

        // 정보가 있다면 user 반환
        return new ResponseEntity<>(userDtoList, HttpStatus.OK);
    }

    // 유저 정보 수정하는 Post 요청
    @PutMapping("/")
    public ResponseEntity<String> modifyUser(@RequestBody UserDto userDto) {

        if (userService.updateUser(userDto)) {
            return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
        }

        return new ResponseEntity<>(FAIL, HttpStatus.NO_CONTENT);
    }

    // 유저 프로필 보기 -> 한 명의 유저를 선택하는 API
    @GetMapping("/profile")
    public ResponseEntity<UserDto> getUser(@RequestParam int userId) {

        // 검색한 userId를 바탕으로 유저 하나 가져오기
        UserDto userDto = userService.selectOneUser(userId);

        // 만약 user가 null이라면, notFound 반환
        if (userDto == null) {
            return ResponseEntity.notFound().build();
        }

        // 정보가 있다면 user 반환
        return new ResponseEntity<>(userDto, HttpStatus.OK);
    }

    // 사용자 kakao Login 처리
    @PostMapping("/login/kakao")
    public ResponseEntity<UserDto> loginUser(@RequestBody TokenDto tokenDto) throws Exception {
        String email = apiService.getEmailByAccessToken(tokenDto);

        UserDto userDto = userService.selectUserByEmail(email);

        // DB에 email 비교해서 가입했는지, 안했는지 확인
        if(userDto != null && userDto.getUserRole() != 2){
            System.out.println("로그인 성공!");
            System.out.println(userDto.getNickname());
            return new ResponseEntity<>(userDto, HttpStatus.OK);
        }else{
            System.out.println("회원가입으로!");
            System.out.println(email);
            userDto = new UserDto();
            userDto.setEmail(email);
            return new ResponseEntity<>(userDto, HttpStatus.ACCEPTED);
        }
    }

    // 사용자 가입 처리
    @PostMapping("/")
    public ResponseEntity<UserDto> registUser(
            @RequestParam("profileImg") MultipartFile profileImg,
            @RequestParam("nickname") String nickname,
            @RequestParam("email") String email
    ) throws Exception {
        System.out.println(profileImg);
        System.out.println(nickname);
        System.out.println(email);

        String fileName = fileService.createFile(profileImg);

        // 유저 DTO에 nickname, email, profile img path를 넣어준다
        UserDto userDto = new UserDto();

        userDto.setNickname(nickname);
        userDto.setEmail(email);
        userDto.setProfileImg(fileName);

        userService.createUser(userDto);

        System.out.println("회원가입 성공!");

        return new ResponseEntity<>(userDto, HttpStatus.OK);
    }


    // 사용자의 탈퇴 처리 - 수정과 유사하다
    @PutMapping("/{userId}")
    public ResponseEntity<String> removeUser(@PathVariable("userId") int userId) {

        // 현재 사용자의 고유 id값을 기준으로 userId 가져오기
        UserDto nowUser = userService.selectOneUser(userId);

        // userId로 DB에서 정보를 가져오지 못한 경우
        if(nowUser == null) {
            // 실패 출력
            return new ResponseEntity<>(FAIL, HttpStatus.NO_CONTENT);
        }

        // 현재 유저의 user_role을 2로 변경
        nowUser.setUserRole(2);
        System.out.println(nowUser.getUserRole());

        // 현재 유저의 상태를 변경하여 저장
        if(userService.updateUser(nowUser)) {

            // 성공하면 OK 반환
            System.out.println(userService.selectOneUser(userId).getNickname());
            System.out.println(userService.selectOneUser(userId).getUserRole());
            return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
        } else {
            // 실패하면 NOT_ACCEPTABLE 반환
            return  new ResponseEntity<>(FAIL, HttpStatus.NOT_ACCEPTABLE);
        }

    }

    // -------------- 팔로우 기능 ----------------
    // 팔로우 요청
    @PostMapping("/followers")
    public ResponseEntity<String> addFollowUser(@RequestBody FollowDto followDto) {
        // fromUserId와 toUserId를 받기 위해 FollowDto 객체를 RequestBody로 받아온다

        // 그럼 FollowService에서는 FollowDto를 Entity로 저장해준다
        if (followService.createFollow(followDto)) {
            return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
        }

        return new ResponseEntity<>(FAIL, HttpStatus.NO_CONTENT);
    }

    // 언팔로우
    @DeleteMapping("/followers")
    public ResponseEntity<String> removeFollowUser(@RequestBody FollowDto followDto) {
        // 내가 다른 유저를 unfollow 할 경우,
        // fromUserId와 내가 일치하는 것만 삭제하면 된다!
        if (followService.deleteFollow(followDto)) {
            return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
        }

        return new ResponseEntity<>(FAIL, HttpStatus.NO_CONTENT);
    }

    // 팔로잉 목록 보기(내가 팔로우 하는)
    @GetMapping("/followings")
    public ResponseEntity<List<UserDto>> getFollowings(@RequestParam int userId) {
        // userId를 통해서 해당 유저가 팔로우 하는 following 목록을 가져옵니다
        List<UserDto> userList = followService.selectFollowList(userId);

        // UserList의 size가 0이라면?
        if (userList.size() == 0) {
            System.out.println("비어있습니다");
            return ResponseEntity.notFound().build();
        }

        return new ResponseEntity<>(userList, HttpStatus.OK);

    }

    // 팔로워 목록 보기(나를 팔로우 하는)
    @GetMapping("/followers")
    public ResponseEntity<List<UserDto>> getFollowers(@RequestParam int userId) {
        // userId를 통해서 해당 유저가 팔로우 하는 followers 목록을 가져옵니다
        List<UserDto> userList = followService.selectFollowerList(userId);

        if (userList.size() == 0) {
            System.out.println("비어있습니다.");
            return ResponseEntity.notFound().build();
        }
        return new ResponseEntity<>(userList, HttpStatus.OK);
    }

}
