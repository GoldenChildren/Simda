package ssafy.a709.simda.service;

import ssafy.a709.simda.dto.ChatDto;

import java.util.List;
public interface ChatService {

    // 해당 채팅방의 채팅목록을 모두 가져와!
    public List<ChatDto> selectChatList(int chatRoomId);


    // 유저한테 채팅을 보내!
    public int createChat(ChatDto chatDto);
}
