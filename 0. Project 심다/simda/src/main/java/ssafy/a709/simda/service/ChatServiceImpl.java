package ssafy.a709.simda.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ssafy.a709.simda.domain.Chat;
import ssafy.a709.simda.domain.Chatroom;
import ssafy.a709.simda.dto.ChatDTO;
import ssafy.a709.simda.repository.ChatRepository;
import ssafy.a709.simda.repository.ChatRoomRepository;

import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;
@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {


    private final ChatRepository chatRepository;
    private final ChatRoomRepository chatRoomRepository;

    @Override
    public List<ChatDTO> chatList(int chatRoomId) {
        List<ChatDTO> responseList = new ArrayList<>();
//        List<Chat> resultList = chatRepository.findAllByChatRoom(chatRoomRepository.getById(chatRoomId));
//        for (Chat chat:resultList) {
//            responseList.add(ChatDTO.changeToChatDto(chat));
//        }
        return responseList;
    }

    @Override
    public int chatTransfer(ChatDTO chatDTO) {
        try{
            //채팅을 등록함
            System.out.println("chatTransfer 실행 중");
            Chat newChat = Chat.chageToChatForTrans(chatDTO);

            newChat=chatRepository.save(newChat);
            System.out.println(newChat);
            //채팅방의 마지막 채팅을 업로드함
           Chatroom updateChatRoom = chatRoomRepository.findById(chatDTO.getChatRoom().getChatRoomId()).get();
            updateChatRoom.update(newChat);
            chatRoomRepository.save(updateChatRoom);
        }catch (Exception e){
            System.out.println("exception : "+e.getMessage());
            return 0;
        }
        return 1;
    }
}
