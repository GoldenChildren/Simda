package ssafy.a709.simda.dto;

import lombok.Builder;
import lombok.Data;
import ssafy.a709.simda.domain.Chat;

@Data
@Builder
public class ChatDto {

    public static ChatDto changeToChatDto(Chat chat) {
        return ChatDto.builder()
                .chatId(chat.getChatId())
                .chatRoomId(chat.getChatRoom().getChatroomId())
                .user(UserDto.changeToUserDto(chat.getUser()))
                .content(chat.getContent())
                .regDate(chat.getRegDate())
                .build();
    }



    private int chatId;
    private int chatRoomId;
    private UserDto user;
    private String content;
    private String regDate;
    private int readFlag;
}
