package ssafy.a709.simda.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssafy.a709.simda.domain.Chat;
import ssafy.a709.simda.domain.Chatroom;
import ssafy.a709.simda.dto.ChatDto;
import ssafy.a709.simda.repository.ChatRepository;
import ssafy.a709.simda.repository.ChatRoomRepository;

import javax.transaction.Transactional;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
@Service
public class ChatServiceImpl implements ChatService {

    @Autowired
    ChatRepository chatRepository;
    @Autowired
    ChatRoomRepository chatRoomRepository;

    @Override
    public List<ChatDto> selectChatList(int chatRoomId) {
        List<ChatDto> responseList = new ArrayList<>();
        List<Chat> resultList = chatRepository.findByChatRoom(chatRoomRepository.getById(chatRoomId));
        for (Chat chat:resultList) {
            responseList.add(ChatDto.changeToChatDto(chat));
        }
        return responseList;
    }

    @Override
    public int createChat(ChatDto chatDto) {
        try{
            //채팅을 등록함
            System.out.println("chatTransfer 실행 중");
            //현재 시간
            LocalDateTime now = LocalDateTime.now();
            String formatedNow = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            chatDto.setRegDate(now.toString());
            Chat newChat = Chat.chageToChatForTrans(chatDto);
            newChat=chatRepository.save(newChat);
            System.out.println(newChat);
            //채팅방의 마지막 채팅을 업로드함
            Chatroom updateChatRoom = chatRoomRepository.findById(chatDto.getChatRoomId()).get();
            updateChatRoom.update(newChat);
            chatRoomRepository.save(updateChatRoom);
        }catch (Exception e){
            System.out.println("exception : "+e.getMessage());
            return 0;
        }
        return 1;
    }
}
