package ssafy.a709.dto;

import lombok.Builder;
import lombok.Data;
import ssafy.a709.domain.Chat;

@Data
@Builder
public class ChatDTO {

    public static ChatDTO changeToChatDto(Chat chat) {
        return ChatDTO.builder()
                .chatId(chat.getChatId())
                .chatRoom(ChatRoomDTO.changeToChatRoomDto(chat.getChatRoom()))
                .user(UserDto.changeToUserDto(chat.getUser()))
                .content(chat.getContent())
                .regDate(chat.getRegDate())
                .build();
    }



    private int chatId;
    private ChatRoomDTO chatRoom;
    private UserDto user;
    private String content;
    private String regDate;
    private int read;
}
