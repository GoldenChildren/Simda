package ssafy.a709.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ssafy.a709.dto.ChatRoomDTO;

@RestController
@RequestMapping("/simda")
public class ChatRoomController {

    //채팅방 목록 가져오기
    //"/simda/chat/rooms/{userId}"
    @GetMapping("/chat/rooms/{userId}")
    public ResponseEntity<?> chatRooms(@PathVariable int userId){
        //서비스에서 받는 부분 작성

        //return new ResponseEntity<>();
        return null;
    }
    //채팅방 생성하기
    //"/simda/chat/rooms/"
    @PostMapping("/chat/rooms")
    public ResponseEntity<?> createChatRoom(@RequestBody ChatRoomDTO chatRoomDTO){
        //서비스에서 채팅방 생성하는 부분

        //return  new ResponseEntity<>();
        return null;
    }
}
