package ssafy.a709.dto;

import lombok.Builder;
import lombok.Data;
import ssafy.a709.domain.Chat;
import ssafy.a709.domain.Chatroom;

@Data
@Builder
public class ChatRoomDTO{

    public static ChatRoomDTO changeToChatRoomDto(Chatroom chatRoom) {
        return ChatRoomDTO.builder()
                .chatRoomId(chatRoom.getChatroomId())
                .user1(UserDto.changeToUserDto(chatRoom.getUser1()))
                .user2(UserDto.changeToUserDto(chatRoom.getUser2()))
                .lChat(ChatDTO.changeToChatDto(chatRoom.getChat()))
                .build();
    }
    private int chatRoomId;
    private UserDto user1;
    private UserDto user2;
    private ChatDTO lChat;

}
