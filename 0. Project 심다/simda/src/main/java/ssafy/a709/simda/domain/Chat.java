package ssafy.a709.simda.domain;

import lombok.*;
import ssafy.a709.simda.dto.ChatDTO;

import javax.persistence.*;


@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Table
public class Chat {

    public static Chat chageToChat(ChatDTO chatDTO){
        return Chat.builder()
                .chatId(chatDTO.getChatId())
                .chatRoom(Chatroom.chageToChatroom(chatDTO.getChatRoom()))
                .user(User.changeToUser(chatDTO.getUser()))
                .content(chatDTO.getContent())
                .regDate(chatDTO.getRegDate())
                .readFlag(chatDTO.getRead())
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
    @Column(name = "readFlag", nullable = false, columnDefinition = "boolean")
    private int readFlag;



}
