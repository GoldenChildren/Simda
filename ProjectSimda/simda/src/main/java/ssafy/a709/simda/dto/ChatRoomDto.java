package ssafy.a709.simda.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ssafy.a709.simda.domain.Chatroom;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ChatRoomDto{

    public static ChatRoomDto changeToChatRoomDto(Chatroom chatRoom) {
        return ChatRoomDto.builder()
                .chatRoomId(chatRoom.getChatroomId())
                .user1(UserDto.changeToUserDto(chatRoom.getUser1()))
                .user1Id(chatRoom.getUser1().getUserId())
                .user1nickName(chatRoom.getUser1().getNickname())
                .user2(UserDto.changeToUserDto(chatRoom.getUser2()))
                .user2Id(chatRoom.getUser2().getUserId())
                .user2nickName(chatRoom.getUser2().getNickname())
                .lChat(ChatDto.changeToChatDto(chatRoom.getChat()))
                .build();
    }
    private int chatRoomId;
    private UserDto user1;
    private int user1Id;
    private String user1nickName;
    private UserDto user2;
    private int user2Id;
    private String user2nickName;
    private ChatDto lChat;

}
