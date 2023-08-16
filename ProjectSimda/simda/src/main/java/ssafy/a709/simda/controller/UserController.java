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
import ssafy.a709.simda.dto.UserList;
import ssafy.a709.simda.service.*;

import java.io.File;
import java.io.IOException;
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

    @Autowired
    FeedService feedService;

    @Autowired
    CommentService commentService;

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
    // 유저 중복 검사
    @GetMapping("/email")
    public ResponseEntity<UserDto> checkUser(@RequestParam String email) {
        System.out.println(email);
        // String type의 email을 받아와서 DB와 비교
        UserDto userDto = userService.selectUserByEmail(email);
        if (userDto == null || userDto.getUserRole() != 1) // 유저가 없는 경우
            return new ResponseEntity<>(null, HttpStatus.NOT_ACCEPTABLE);
        else
            return new ResponseEntity<>(userDto, HttpStatus.OK);
    }

    // 유저 - 검색 keyword를 통해 닉네임을 포함하는 유저를 전체 반환
    @GetMapping("/search")
    public ResponseEntity<UserList> getUsers(@RequestParam String nickname) {

        // 키워드를 포함하는 닉네임을 받아올 유저들의 리스트 생성
        UserList userList = UserList.builder().userList(userService.selectUsers(nickname)).build();
        // 만약 userDtoList의 size가 0이라면, 검색 결과가 없는 것이므로, notFound 반환
        if (userList.getUserList().size() == 0) {
            return new ResponseEntity<>(userList, HttpStatus.NO_CONTENT);
        }

        // 정보가 있다면 user 반환
        return new ResponseEntity<>(userList, HttpStatus.OK);
    }

    // 유저 정보 수정하는 Post 요청
    @PostMapping(path = "/modify", consumes = "multipart/form-data")
    public ResponseEntity<UserDto> modifyUser(
            @RequestPart(value="imgfile", required = false) MultipartFile profileImg,
            @ModelAttribute UserDto userDto) throws IOException {
        // 프론트에서 프로필 이미지 변경 시 orgFileName을 modified로 저장해놔야함.
        if(profileImg != null && profileImg.getOriginalFilename().equals("modified")){
            System.out.println("profileImg : "+profileImg.getOriginalFilename());

            // origin file name이 modified라면 이미지 수정
            System.out.println("이미지 수정됨");
            userDto.setProfileImg(
                    fileService.updateProfile(
                            profileImg,
                            userDto.getProfileImg()
                    )
            );
        }

        if (userService.updateUser(userDto)) {
            return new ResponseEntity<>(userDto, HttpStatus.OK);
        }

        return new ResponseEntity<>(null, HttpStatus.NO_CONTENT);
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

        // 카카오톡 서버를 통해 token을 가져오고, 이메일을 추출한다
        String email = apiService.getEmailByAccessToken(tokenDto);

        // 해당 추출된 이메일을 참조하여 userDto를 가져온다
        UserDto userDto = userService.selectUserByEmail(email);
        System.out.println("-----로그인 해볼게요------");
//        System.out.println(userDto.getNickname());
//        System.out.println(userDto.getUserId());

        // userDto 값을 통해 가입했는지, 안했는지 확인
        // 가입 이력 자체가 없다
        if(userDto == null) {
            // userDto 값이 null이면 신규 유저
            System.out.println("UserController 121 : 신규유저 회원가입으로!");
            System.out.println(email);
            userDto = new UserDto();
            // email을 저장하여 넘겨줌
            userDto.setEmail(email);
            return new ResponseEntity<>(userDto, HttpStatus.ACCEPTED);
        } else{
            // 가입 이력이 있다
            int userRole = userService.selectRole(email); // userRole은 repo에서 가져와야만 한다.
            System.out.println("로그인 할 때 유저의 롤은? : "+userRole);
            if(userRole == 2) {
                // 탈퇴한 유저라면, 해당 유저의 email을 비운채로 넘겨주자
                System.out.println("UserController에서 넘겨줄 때 Id가 있는가? " + userDto.getUserId());
                System.out.println("UserController에서 넘겨줄 때 userRole이 있는가? " + userService.selectRole(email));
                System.out.println("UserController 129 : 탈퇴유저 회원가입으로!");
                return new ResponseEntity<>(userDto, HttpStatus.ACCEPTED);
            }else{
                // 둘 다 통과되면 성공
                System.out.println("UserController 130 : 로그인 성공!");
                System.out.println(userDto.getNickname());
                return new ResponseEntity<>(userDto, HttpStatus.OK);
            }
        }
    }

    // 사용자 가입 처리
    @PostMapping(path = "/", consumes = "multipart/form-data")
    public ResponseEntity<UserDto> registUser(
            @RequestPart(value="imgfile", required = false) MultipartFile profileImg,
            @ModelAttribute UserDto userDto
    ) throws Exception {
        System.out.println("UserController registUser 진입");
//        System.out.println(profileImg);
//        System.out.println(nickname);
//        System.out.println(email);

        String fileUrl = fileService.uploadProfile(profileImg);

        // 유저 DTO에 nickname, email, profile img path를 넣어준다

        UserDto beforeUser = userService.selectUserByEmail(userDto.getEmail());

        // user 있는지 email로 체크
        // 기존 유저의 경우
        if(beforeUser != null) {
            int temp = userService.selectRole(beforeUser.getEmail());
            System.out.println("UserController 164 : " + temp);
            if(temp != 2){
                // 탈퇴 안했는데 회원가입한 경우 에러
                return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
            }
            beforeUser.setNickname(userDto.getNickname());
            beforeUser.setEmail(userDto.getEmail());
            beforeUser.setProfileImg(fileUrl);
            System.out.println("UserController 161 진입 - 여기까지 온다");
            userService.updateUser(beforeUser);
        } else {
            // 신규 유저의 경우
            userDto.setProfileImg(fileUrl);
            userService.createUser(userDto);
        }
        System.out.println("UserController 158 : 회원가입 성공!");
        System.out.println(userDto.getNickname());
        //파이어베이스 이중 저장을 위한 데이터 반환
        List<UserDto> resultList=userService.selectUsers(userDto.getNickname());
        return new ResponseEntity<>(resultList.get(0), HttpStatus.OK);
    }

    // 사용자의 탈퇴 처리 - 수정과 유사하다
    @PutMapping("/{userId}")
    public ResponseEntity<String> removeUser(@PathVariable("userId") int userId) {
        System.out.println("UserController 160: 유저를 탈퇴처리 합니다");

        // 현재 유저의 상태를 변경하여 저장
        // 유저 정보가 있는 경우, 해당 userDto를 userService의 deleteUser로 보낸다
        if(userService.deleteUser(userId)
                && feedService.deleteUserFeed(userId)
                && commentService.deleteUserComment(userId)
                && followService.deleteUserFollow(userId)) {
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
    public ResponseEntity<String> removeFollowUser(@RequestParam int fromUserId, @RequestParam int toUserId) {
        // 내가 다른 유저를 unfollow 할 경우,
        // fromUserId와 나, toUserId와 상대방이 일치하는 경우 삭제
        if (followService.deleteFollow(fromUserId, toUserId)) {
            return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
        }

        return new ResponseEntity<>(FAIL, HttpStatus.NO_CONTENT);
    }

    // 팔로잉 목록 보기(내가 팔로우 하는)
    @GetMapping("/followings")
    public ResponseEntity<UserList> getFollowings(@RequestParam int userId) {
        // userId를 통해서 해당 유저가 팔로우 하는 following 목록을 가져옵니다
        UserList userList = UserList.builder().userList(followService.selectFollowList(userId)).build();
        // UserList의 size가 0이라면?
        if (userList.getUserList().size() == 0) {
            System.out.println("비어있습니다");
            return new ResponseEntity<>(userList, HttpStatus.NO_CONTENT);
        }

        return new ResponseEntity<>(userList, HttpStatus.OK);

    }

    // 팔로워 목록 보기(나를 팔로우 하는)
    @GetMapping("/followers")
    public ResponseEntity<UserList> getFollowers(@RequestParam int userId) {
        // userId를 통해서 해당 유저가 팔로우 하는 followers 목록을 가져옵니다
        UserList userList = UserList.builder().userList(followService.selectFollowerList(userId)).build();
        if (userList.getUserList().size() == 0) {
            System.out.println("비어있습니다.");
            return new ResponseEntity<>(userList, HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<>(userList, HttpStatus.OK);
    }

    @GetMapping("/followcheck")
    public ResponseEntity<Boolean> followCheck(@RequestParam int fromUserId, @RequestParam int toUserId) {
        // fromUserId와 toUserId를 체크해서
        // 두 값을 만족하면 true, 실패하면 false를 반환해주자
        boolean check = false;
        if (followService.selectUser(fromUserId, toUserId)) {
            check = true;
            return new ResponseEntity<>(check, HttpStatus.OK);
        }
        return new ResponseEntity<>(check, HttpStatus.NO_CONTENT);
    }
}