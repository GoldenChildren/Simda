package ssafy.a709.dto;

import lombok.Data;

@Data
public class ChatRoomDTO{
    private int chatRoomId;
    private int user1Id;
    private String user1Nickname;
    private int user2Id;
    private String user2Nickname;
    private int lChatId;
    private String lChatContent;
    private String lChatRegDate;
}
