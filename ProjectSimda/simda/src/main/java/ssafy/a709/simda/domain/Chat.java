package ssafy.a709.simda.domain;

import lombok.*;
import ssafy.a709.simda.dto.ChatDto;
import ssafy.a709.simda.dto.ChatRoomDto;
import ssafy.a709.simda.dto.UserDto;

import javax.persistence.*;


@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Table
public class Chat {

    public static Chat chageToChat(ChatDto chatDto){
        System.out.println("chageToChat 시작");
        ChatRoomDto  chatRoomDto = new ChatRoomDto();
        chatRoomDto.setChatRoomId(chatDto.getChatRoomId());
        UserDto user = new UserDto();
        user.setUserId(chatDto.getUserId());

        return Chat.builder()
                .chatId(chatDto.getChatId())
                .chatRoom(Chatroom.chageToChatroom(chatRoomDto))
                .user(User.changeToUser(user))
                .content(chatDto.getContent())
                .regDate(chatDto.getRegDate())
                .readFlag(chatDto.getReadFlag())
                .build();
    };
    public static Chat chageToChatForTrans(ChatDto chatDto){
        System.out.println("chageToChat 시작");

        ChatRoomDto  chatRoomDto = new ChatRoomDto();
        chatRoomDto.setChatRoomId(chatDto.getChatRoomId());
        UserDto user = new UserDto();
        user.setUserId(chatDto.getUserId());
        return Chat.builder()
                .chatId(chatDto.getChatId())
                .chatRoom(Chatroom.chageToChatroomForTrans(chatRoomDto))
                .user(User.changeToUser(user))
                .content(chatDto.getContent())
                .regDate(chatDto.getRegDate())
                .readFlag(chatDto.getReadFlag())
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
