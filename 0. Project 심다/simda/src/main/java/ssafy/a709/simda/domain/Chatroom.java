package ssafy.a709.simda.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ssafy.a709.simda.dto.ChatRoomDto;

import javax.persistence.*;
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Table

public class Chatroom {
    public static Chatroom chageToChatroom(ChatRoomDto chatRoomDto){
        return Chatroom.builder()
                .chatroomId(chatRoomDto.getChatRoomId())
                .user1(User.changeToUser(chatRoomDto.getUser1()))
                .user2(User.changeToUser(chatRoomDto.getUser2()))
                .chat(Chat.chageToChat(chatRoomDto.getLChat()))
                .build();
    };
    public static Chatroom chageToChatroomForTrans(ChatRoomDto chatRoomDto){
        return Chatroom.builder()
                .chatroomId(chatRoomDto.getChatRoomId())
                .user1(User.changeToUser(chatRoomDto.getUser1()))
                .user2(User.changeToUser(chatRoomDto.getUser2()))
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
