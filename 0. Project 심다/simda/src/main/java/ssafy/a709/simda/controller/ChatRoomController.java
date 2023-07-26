package ssafy.a709.simda.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ssafy.a709.simda.dto.ChatRoomDTO;
import ssafy.a709.simda.service.ChatRoomServiceImpl;

import java.util.List;

@RestController
@RequestMapping("/simda")
public class ChatRoomController {

    @Autowired
    ChatRoomServiceImpl chatRoomService;
    //채팅방 목록 가져오기
    //"/simda/chat/rooms/{userId}"
    @GetMapping("/chat/rooms/{userId}")
    public ResponseEntity<?> chatRooms(@PathVariable int userId){
        //서비스에서 받는 부분 작성
        List<ChatRoomDTO> resultList =chatRoomService.allChatRoomList(userId);
        //return new ResponseEntity<>();
        if(resultList.size()==0){
            String msg="채팅방이 없습니다";
            return new ResponseEntity<String>(msg, HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<ChatRoomDTO>>(resultList, HttpStatus.OK);
    }
    //채팅방 생성하기
    //"/simda/chat/rooms/"
    @PostMapping("/chat/rooms")
    public ResponseEntity<?> createChatRoom(@RequestBody ChatRoomDTO chatRoomDTO){
        //서비스에서 채팅방 생성하는 부분
        int result = chatRoomService.createChatRoom(chatRoomDTO.getUser1().getUserId(), chatRoomDTO.getUser2().getUserId());

        if(result ==0) {
            //실패
            String msg = "채팅방 생성 실패";
            return new ResponseEntity<String>(msg, HttpStatus.NO_CONTENT);
        }else {
            //성공
            String msg ="채팅방 생성 성공";
            return new ResponseEntity<String>(msg, HttpStatus.OK);
        }

    }
}
