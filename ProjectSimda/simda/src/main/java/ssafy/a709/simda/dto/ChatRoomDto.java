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
        if(chatRoom.getChat() == null){
            return ChatRoomDto.builder()
                    .chatRoomId(chatRoom.getChatroomId())
//                    .user1(UserDto.changeToUserDto(chatRoom.getUser1()))
                    .user1Id(chatRoom.getUser1().getUserId())
                    .user1nickName(chatRoom.getUser1().getNickname())
                    .user1Img(chatRoom.getUser1().getProfileImg())
//                    .user2(UserDto.changeToUserDto(chatRoom.getUser2()))
                    .user2Id(chatRoom.getUser2().getUserId())
                    .user2Img(chatRoom.getUser2().getProfileImg())
                    .user2nickName(chatRoom.getUser2().getNickname())
                    .build();
        }
        return ChatRoomDto.builder()
                .chatRoomId(chatRoom.getChatroomId())
//                .user1(UserDto.changeToUserDto(chatRoom.getUser1()))
                .user1Id(chatRoom.getUser1().getUserId())
                .user1nickName(chatRoom.getUser1().getNickname())
                .user1Img(chatRoom.getUser1().getProfileImg())
//                .user2(UserDto.changeToUserDto(chatRoom.getUser2()))
                .user2Id(chatRoom.getUser2().getUserId())
                .user2Img(chatRoom.getUser2().getProfileImg())
                .user2nickName(chatRoom.getUser2().getNickname())
                .lChatContent(chatRoom.getChat().getContent())
                .lChatUserId(chatRoom.getChat().getUser().getUserId())
                .lChatId(chatRoom.getChat().getChatId())
                .build();
    }
    private int chatRoomId;
    //user1정보
    private int user1Id;
    private String user1nickName;
    private String user1Img;
    //user2 정보
    private int user2Id;
    private String user2nickName;
    private String user2Img;
    //마지막 채팅정보
    private String lChatContent;
    private int lChatUserId;
    private int lChatId;
    //dto들
//    private UserDto user1;
//    private UserDto user2;
//    private ChatDto lChat;
}
