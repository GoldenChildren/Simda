package ssafy.a709.service;

import org.springframework.stereotype.Service;
import ssafy.a709.dto.ChatRoomDTO;

import java.util.List;

@Service
public class ChatRoomServiceImpl implements ChatRoomService{
    //채팅방 목록가져오기
    @Override
    public List<ChatRoomDTO> allChatRoomList(int userId) {
        return null;
    }
    //채팅방생성
    @Override
    public int createChatRoom(int user1Id, int user2Id) {
        return 0;
    }







}
