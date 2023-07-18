package ssafy.a709.dto;

import lombok.Builder;
import lombok.Data;
import ssafy.a709.domain.Chat;

@Data
@Builder
public class ChatDTO {

    public ChatDTO changeToFollowDto(Chat chat) {
        return ChatDTO.builder()
                .chatId(chat.getChatId())
                //.chatRoom(chat.getChatRoom())
                .build();
    }



    private int chatId;
    private ChatRoomDTO chatRoom;
    private int userId;
    private String userNickname;
    private String content;
    private String regDate;
    private boolean read;
}
