package ssafy.a709.simda.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ssafy.a709.simda.dto.UserDto;
import ssafy.a709.simda.service.FollowService;
import ssafy.a709.simda.service.UserService;

@RestController
@RequestMapping("/user")
public class UserController {

    private static final String SUCCESS = "success";
    private static final String FAIL = "fail";

    @Autowired
    UserService us;

    @Autowired
    FollowService fs;

    /*
    Follow Controller를 따로 만드는 대신
    User Controller에서 둘 다 관리하는 것으로 하자
    Why? API 명세서에 다 /user로 시작하기 때문에 굳이 안나눠도 될 것 같아
    Follow는 다 User 화면과 관련되어 있기 때문에... 데이터를 가공하는 Service만 나눴구요
    */

    // 검색 keyword를 통해 1명의 유저를 검색해서 선택하는 Get요청
//    @GetMapping("/search")
//    public ResponseEntity<UserDto> searchUser(@RequestParam String keyword) {
//
//        // 검색한 keyword를 바탕으로 유저 하나 가져오기
//        UserDto userDto = us.selectOneUser(keyword);
//
//        // 만약 user가 null이라면, notFound 반환
//        if(userDto == null) {
//            return ResponseEntity.notFound().build();
//        }
//
//        // 정보가 있다면 user 반환
//        return new ResponseEntity<>(userDto, HttpStatus.OK);
//    }

    // 유저 정보 수정하는 Post 요청
    @PutMapping("/")
    public ResponseEntity<String> updateUser(@RequestBody UserDto userDto) {
        UserDto nowUser = userDto;

        return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
    }


}
