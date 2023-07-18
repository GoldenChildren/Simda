package ssafy.a709.domain;

import lombok.*;
import ssafy.a709.dto.ChatDTO;
import ssafy.a709.dto.ChatRoomDTO;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.Date;


@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class Chat {

    public static Chat chageToChat(ChatDTO chatDTO){
        return Chat.builder()
                .chatId(chatDTO.getChatId())
                .chatRoom(Chatroom.chageToChatroom(chatDTO.getChatRoom()))
                .user(User.changeToUser(chatDTO.getUser()))
                .content(chatDTO.getContent())
                .regDate(chatDTO.getRegDate())
                .read(chatDTO.getRead())
                .build();
    };


    // Chat Id
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "chat_id")
    private int chatId;

    // Many(Chatroom Id) to One(Chatroom Id)
    @ManyToOne
    @JoinColumn(name = "chatroom_id",nullable = false, referencedColumnName = "chatroom_id")
    private Chatroom chatRoom;

    // Many(User Id) to One(User Id)
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    private User user;

    // Content
    @Column(name = "content", nullable = false, columnDefinition = "text")
    private String content;

    // Regist Date
    @Column(name = "reg_date", nullable = false, columnDefinition = "timestamp")
    private String regDate;

    // Read Flag
    @Column(name = "read", nullable = false, columnDefinition = "boolean")
    private int read;
}
