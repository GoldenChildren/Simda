package ssafy.a709.simda.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssafy.a709.simda.domain.Chatroom;
import ssafy.a709.simda.domain.User;
import ssafy.a709.simda.dto.ChatRoomDto;
import ssafy.a709.simda.dto.UserDto;
import ssafy.a709.simda.repository.ChatRoomRepository;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
public class ChatRoomServiceImpl implements ChatRoomService{

    @Autowired
    ChatRoomRepository chatRoomRepository;

    //채팅방 목록가져오기
    @Override
    public List<ChatRoomDto> selectAllChatRoomList(int userId) {
        log.debug("selectAllChatRoomList 메서드 시작: userId = {}", userId);
        List<ChatRoomDto> responseList = new ArrayList<>();
        List<Chatroom> resultList = chatRoomRepository.findAllByUser1IdOrUser2Id(userId,userId);
        for (Chatroom chatRoom:resultList) {
            ChatRoomDto chatRoomDto = ChatRoomDto.changeToChatRoomDto(chatRoom);
            if(userId == chatRoom.getUser1().getUserId()){
                //1번이 자신일때
            }else{
                chatRoomDto.setUser1Id(chatRoom.getUser2().getUserId());
                chatRoomDto.setUser1nickName(chatRoom.getUser2().getNickname());
                chatRoomDto.setUser1Img(chatRoom.getUser2().getProfileImg());

                chatRoomDto.setUser2Id(chatRoom.getUser1().getUserId());
                chatRoomDto.setUser2nickName(chatRoom.getUser1().getNickname());
                chatRoomDto.setUser2Img(chatRoom.getUser1().getProfileImg());
            }
            responseList.add(chatRoomDto);
        }
        log.debug("selectAllChatRoomList 메서드 결과 수: {}", responseList.size());
        return responseList;

    }
    //채팅방생성
    @Override
    public int createChatRoom(int user1Id, int user2Id) {
        log.debug("createChatRoom 메서드 시작: user1Id = {}, user2Id = {}", user1Id, user2Id);
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
            log.error(e.getMessage(), e);
            return 0;
        }
        //성공
        return 1;
    }







}
