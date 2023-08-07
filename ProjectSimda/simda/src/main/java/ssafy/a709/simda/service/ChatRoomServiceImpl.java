package ssafy.a709.simda.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssafy.a709.simda.domain.Chat;
import ssafy.a709.simda.domain.Chatroom;
import ssafy.a709.simda.domain.User;
import ssafy.a709.simda.dto.ChatRoomDto;
import ssafy.a709.simda.dto.UserDto;
import ssafy.a709.simda.repository.ChatRoomRepository;

import java.util.ArrayList;
import java.util.List;

@Service
public class ChatRoomServiceImpl implements ChatRoomService{

    @Autowired
    ChatRoomRepository chatRoomRepository;

    //채팅방 목록가져오기
    @Override
    public List<ChatRoomDto> selectAllChatRoomList(int userId) {
        List<ChatRoomDto> responseList = new ArrayList<>();
        List<Chatroom> resultList = chatRoomRepository.findAllByUser1IdOrUser2Id(userId,userId);
        for (Chatroom chatRoom:resultList) {
            responseList.add(ChatRoomDto.changeToChatRoomDto(chatRoom));
        }
        return responseList;

    }
    //채팅방생성
    @Override
    public int createChatRoom(int user1Id, int user2Id) {
        try {
            UserDto user1 = new UserDto();
            user1.setUserId(user1Id);
            UserDto user2 = new UserDto();
            user2.setUserId(user2Id);

            Chatroom newChatroom = Chatroom.builder()
                    .user1(User.changeToUser(user1))
                    .user2(User.changeToUser(user2))
                    .build();

            chatRoomRepository.save(newChatroom);
        }catch (Exception e){
            //실패!
            return 0;
        }
        //성공
        return 1;
    }







}
