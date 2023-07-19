package ssafy.a709.simda.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ssafy.a709.simda.domain.Chat;
import ssafy.a709.simda.dto.ChatDTO;
import ssafy.a709.simda.repository.ChatRepository;
import ssafy.a709.simda.repository.ChatRoomRepository;

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
            chatRepository.save(Chat.chageToChat(chatDTO));
            //채팅방의 마지막 채팅을 업로드함
            chatRoomRepository.getById(chatDTO.getChatRoom().getChatRoomId()).update(Chat.chageToChat(chatDTO));

        }catch (Exception e){
            return 0;
        }
        return 1;
    }
}
