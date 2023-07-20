package ssafy.a709.simda.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ssafy.a709.simda.dto.ChatDTO;
import ssafy.a709.simda.dto.ChatRoomDTO;
import ssafy.a709.simda.service.ChatServiceImpl;

import java.util.List;

@RestController
@RequestMapping("/simda")
public class ChatController {

    @Autowired
    ChatServiceImpl chatService;

    //해당 채팅방에 입장하였을 때 채팅목록 가져오기
    @GetMapping("/chat/{roomId}")
    public ResponseEntity<?> chatList(@PathVariable int roomId){
        //서비스에서 받는 부분 작성
        List<ChatDTO> resultList =chatService.chatList(roomId);
        //return new ResponseEntity<>();
        if(resultList.size()==0){
            String msg="채팅방이 없습니다";
            return new ResponseEntity<String>(msg, HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<ChatDTO>>(resultList, HttpStatus.OK);
    }

    //채팅 보내는거 (채팅 생성)
    @PostMapping("/chat")
    public ResponseEntity<?> createChat(@RequestBody ChatDTO chatDTO){
//        System.out.println(chatDTO);
        int result = chatService.chatTransfer(chatDTO);

        if (result==0){
            String msg="채팅 전송 실패";
            return new ResponseEntity<String>(msg, HttpStatus.NO_CONTENT);
        }else{
            String msg = "채팅 전송 성공";
            return new ResponseEntity<String>(msg, HttpStatus.OK);

        }


    }



}
