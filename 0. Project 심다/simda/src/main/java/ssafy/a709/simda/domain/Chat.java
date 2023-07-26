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
        System.out.println("chageToChat 시작");
        return Chat.builder()
                .chatId(chatDTO.getChatId())
                .chatRoom(Chatroom.chageToChatroom(chatDTO.getChatRoom()))
                .user(User.changeToUser(chatDTO.getUser()))
                .content(chatDTO.getContent())
                .regDate(chatDTO.getRegDate())
                .readFlag(chatDTO.getReadFlag())
                .build();
    };
    public static Chat chageToChatForTrans(ChatDTO chatDTO){
        System.out.println("chageToChat 시작");
        return Chat.builder()
                .chatId(chatDTO.getChatId())
                .chatRoom(Chatroom.chageToChatroomForTrans(chatDTO.getChatRoom()))
                .user(User.changeToUser(chatDTO.getUser()))
                .content(chatDTO.getContent())
                .regDate(chatDTO.getRegDate())
                .readFlag(chatDTO.getReadFlag())
                .build();
    };



    // Chat Id
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "chat_id")
    private int chatId;

    // Many(Chatroom Id) to One(Chatroom Id)
    @ManyToOne(fetch = FetchType.LAZY)
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
    @Column(name = "read_flag", nullable = false, columnDefinition = "boolean")
    private int readFlag;



}
