package ssafy.a709.simda.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ssafy.a709.simda.dto.ChatRoomDto;
import ssafy.a709.simda.service.ChatRoomService;
import ssafy.a709.simda.service.ChatRoomServiceImpl;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/simda")
public class ChatRoomController {

    @Autowired
    ChatRoomService chatRoomService;
//     채팅방 목록 가져오기
//     "/simda/chat/rooms/{userId}"
    @GetMapping("/chat/rooms/{userId}")
    public ResponseEntity<?> getChatRooms(@PathVariable int userId){
        log.debug("method = GET, url = \"/chat/rooms/{userId}\"");
        log.debug("getChatRooms 메서드 시작: userId = {}", userId);
        //서비스에서 받는 부분 작성
        List<ChatRoomDto> resultList = chatRoomService.selectAllChatRoomList(userId);
        //return new ResponseEntity<>();
        if(resultList.size()==0){
            String msg="채팅방이 없습니다";
            log.warn("getChatRooms 메서드 경고: 채팅방이 없습니다.");
            return new ResponseEntity<String>(msg, HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<ChatRoomDto>>(resultList, HttpStatus.OK);
    }
    // 채팅방 생성하기
    // "/simda/chat/rooms/"
    @PostMapping("/chat/rooms")
    public ResponseEntity<?> addChatRoom(@RequestBody ChatRoomDto chatRoomDto){
        log.debug("method = POST, url = \"/chat/rooms\"");
        log.debug("addChatRoom 메서드 시작: charRoomDto = {}", chatRoomDto);
        //서비스에서 채팅방 생성하는 부분
        int result = chatRoomService.createChatRoom(chatRoomDto.getUser1Id(), chatRoomDto.getUser2Id());

        if(result == 0) {
            //실패
            String msg = "채팅방 생성 실패";
            log.error("addChatRoom 메서드 오류: 채팅방 생성 실패");
            return new ResponseEntity<String>(msg, HttpStatus.NO_CONTENT);
        }else {
            //성공
            String msg ="채팅방 생성 성공";
            return new ResponseEntity<String>(msg, HttpStatus.OK);
        }

    }
}
