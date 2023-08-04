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
                .chatRoom(ChatRoomDto.changeToChatRoomDto(chat.getChatRoom()))
                .user(UserDto.changeToUserDto(chat.getUser()))
                .content(chat.getContent())
                .regDate(chat.getRegDate())
                .userId(chat.getUser().getUserId())
                .nickName(chat.getUser().getNickname())
                .build();
    }



    private int chatId;
    private ChatRoomDto chatRoom;
    private UserDto user;
    private int userId;
    private String nickName;
    private String content;
    private String regDate;
    private int readFlag;
}
