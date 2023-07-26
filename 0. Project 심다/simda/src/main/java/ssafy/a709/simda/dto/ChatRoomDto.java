package ssafy.a709.simda.dto;

import lombok.Builder;
import lombok.Data;
import ssafy.a709.simda.domain.Chatroom;

@Data
@Builder
public class ChatRoomDto{

    public static ChatRoomDto changeToChatRoomDto(Chatroom chatRoom) {
        return ChatRoomDto.builder()
                .chatRoomId(chatRoom.getChatroomId())
                .user1(UserDto.changeToUserDto(chatRoom.getUser1()))
                .user2(UserDto.changeToUserDto(chatRoom.getUser2()))
                .lChat(ChatDto.changeToChatDto(chatRoom.getChat()))
                .build();
    }
    private int chatRoomId;
    private UserDto user1;
    private UserDto user2;
    private ChatDto lChat;

}
