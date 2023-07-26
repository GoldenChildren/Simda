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
import ssafy.a709.simda.dto.FollowDto;
import ssafy.a709.simda.dto.TokenDto;
import ssafy.a709.simda.dto.UserDto;
import ssafy.a709.simda.service.FollowService;
import ssafy.a709.simda.service.UserService;

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
        if (userService.checkNickname(nickname)) {
            return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
        }
        return new ResponseEntity<>(FAIL, HttpStatus.NOT_ACCEPTABLE);
    }

    // 유저 - 검색 keyword를 통해 1명의 유저를 검색해서 선택하는 Get요청
    @GetMapping("/search")
    public ResponseEntity<List<UserDto>> searchUsers(@RequestParam String keyword) {

        // 키워드를 포함하는 닉네임을 받아올 유저들의 리스트 생성
        List<UserDto> userDtoList = userService.selectUsers(keyword);

        // 만약 userDtoList의 size가 0이라면, 검색 결과가 없는 것이므로, notFound 반환
        if (userDtoList.size() == 0) {
            return ResponseEntity.notFound().build();
        }

        // 정보가 있다면 user 반환
        return new ResponseEntity<>(userDtoList, HttpStatus.OK);
    }

    // 유저 정보 수정하는 Post 요청
    @PutMapping("/")
    public ResponseEntity<String> updateUser(@RequestBody UserDto userDto) {

        if (userService.modifyUser(userDto)) {
            return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
        }

        return new ResponseEntity<>(FAIL, HttpStatus.NO_CONTENT);
    }

    // 팔로우 요청
    @PostMapping("/followers")
    public ResponseEntity<String> followUser(@RequestBody FollowDto followDto) {
        System.out.println(1);
        // fromUserId와 toUserId를 받기 위해 FollowDto 객체를 RequestBody로 받아온다

        // 그럼 FollowService에서는 FollowDto를 Entity로 저장해준다
        if (followService.follow(followDto)) {
            return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
        }

        return new ResponseEntity<>(FAIL, HttpStatus.NO_CONTENT);
    }

    // 언팔로우
    @DeleteMapping("/followers")
    public ResponseEntity<String> unFollowUser(@RequestBody FollowDto followDto) {
        // 내가 다른 유저를 unfollow 할 경우,
        // fromUserId와 내가 일치하는 것만 삭제하면 된다!
        if (followService.unfollow(followDto)) {
            return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
        }

        return new ResponseEntity<>(FAIL, HttpStatus.NO_CONTENT);
    }


    // 유저 프로필 보기 -> 한 명의 유저를 선택하는 API
    @GetMapping("/profile")
    public ResponseEntity<UserDto> searchUser(@RequestParam int userId) {

        // 검색한 userId를 바탕으로 유저 하나 가져오기
        UserDto userDto = userService.selectOneUser(userId);

        // 만약 user가 null이라면, notFound 반환
        if (userDto == null) {
            return ResponseEntity.notFound().build();
        }

        // 정보가 있다면 user 반환
        return new ResponseEntity<>(userDto, HttpStatus.OK);
    }

    // 팔로잉 목록 보기(내가 팔로우 하는)
    @GetMapping("/followings")
    public ResponseEntity<List<UserDto>> searchFollowings(@RequestParam int userId) {
        // userId를 통해서 해당 유저가 팔로우 하는 following 목록을 가져옵니다
        List<UserDto> userList = followService.searchFollow(userId);

        // UserList의 size가 0이라면?
        if (userList.size() == 0) {
            System.out.println("비어있습니다");
            return ResponseEntity.notFound().build();
        }

        return new ResponseEntity<>(userList, HttpStatus.OK);

    }

    // 팔로워 목록 보기(나를 팔로우 하는)
    @GetMapping("/followers")
    public ResponseEntity<List<UserDto>> searchFollowers(@RequestParam int userId) {
        // userId를 통해서 해당 유저가 팔로우 하는 followers 목록을 가져옵니다
        List<UserDto> userList = followService.searchFollower(userId);

        if (userList.size() == 0) {
            System.out.println("비어있습니다.");
            return ResponseEntity.notFound().build();
        }
        return new ResponseEntity<>(userList, HttpStatus.OK);
    }

    // 유저 정보를 가져오는 testCode
//    @GetMapping("/users")
//    public ResponseEntity<Object> getUsers() throws ExecutionException, InterruptedException {
//        List<UserDto> list = userService.testUser();
//        return new ResponseEntity<>(list, HttpStatus.OK);
//    }

    @PostMapping("/login/kakao")
    public ResponseEntity<String> loginUser(@RequestBody TokenDto tokenDto) throws Exception {

        RestTemplate restTemplate = new RestTemplate();

        // Prepare request headers
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        headers.setBearerAuth(tokenDto.getAccessToken());
        headers.add("Accept", "application/json");

        // Prepare request parameters
        MultiValueMap<String, String> parameters = new LinkedMultiValueMap<>();
//        parameters.add("property_keys", "[kakao_account.email]");

        // Create the request entity with headers and parameters
        HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(parameters, headers);

        // Set the API endpoint URLg
        String url = "https://kapi.kakao.com/v2/user/me";

        // Make the POST request
        ResponseEntity<String> responseEntity = restTemplate.exchange(url, HttpMethod.GET, requestEntity, String.class);

        if (responseEntity != null) {
            ObjectMapper mapper = new ObjectMapper();
            System.out.println(responseEntity);
            JsonNode newNode = mapper.readTree(responseEntity.getBody());
            ObjectNode node = ((ObjectNode) newNode).put("Authentication", "Successful");
            String email = node.get("kakao_account").get("email").toString().replaceAll("\"","");
            System.out.println(email);


            // DB에 email 비교해서 가입했는지, 안했는지 확인
            if(userService.checkEmail(email)){
                System.out.println("로그인 성공!");
                return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
            }else{
                System.out.println("회원가입으로!");
                return new ResponseEntity<>(email, HttpStatus.NOT_FOUND);
            }
        }
        return new ResponseEntity<>(FAIL, HttpStatus.NO_CONTENT);
    }

    @PostMapping("/")
    public ResponseEntity<String> registUser(@RequestBody UserDto userDto) throws Exception {
        System.out.println(userDto);

        userService.createUser(userDto);

        System.out.println("회원가입 성공!");

        return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
    }

}
