package ssafy.a709.simda.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
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

public class Chatroom {
    public static Chatroom chageToChatroom(ChatRoomDto chatRoomDto){

        UserDto user1 = new UserDto();
        user1.setUserId(chatRoomDto.getUser1Id());

        UserDto user2 = new UserDto();
        user2.setUserId(chatRoomDto.getUser2Id());

        ChatDto lChat = new ChatDto();
        lChat.setChatId(chatRoomDto.getLChatId());


        return Chatroom.builder()
                .chatroomId(chatRoomDto.getChatRoomId())
                .user1(User.changeToUser(user1))
                .user2(User.changeToUser(user2))
                .chat(Chat.chageToChat(lChat))
                .build();
    };
    public static Chatroom chageToChatroomForTrans(ChatRoomDto chatRoomDto){
        UserDto user1 = new UserDto();
        user1.setUserId(chatRoomDto.getUser1Id());
        UserDto user2 = new UserDto();
        user2.setUserId(chatRoomDto.getUser2Id());
        return Chatroom.builder()
                .chatroomId(chatRoomDto.getChatRoomId())
                .user1(User.changeToUser(user1))
                .user2(User.changeToUser(user2))
                .build();
    };



    // Chatroom Id
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "chatroom_id")
    private int chatroomId;

    // Many(User1 Id) to One(User Id)
    @ManyToOne
    @JoinColumn(name = "user1_id", referencedColumnName = "user_id")
    private User user1;

    // Many(User2 Id) to One(User Id)
    @ManyToOne
    @JoinColumn(name = "user2_id", referencedColumnName = "user_id")
    private User user2;

    // One(Last Chat Id) to One(Chat Id)
    @OneToOne
    @JoinColumn(name = "l_chat_id", nullable = true, referencedColumnName = "chat_id")
    private Chat chat;

    public void update(Chat chat){
        this.chat = chat;
    }
}
