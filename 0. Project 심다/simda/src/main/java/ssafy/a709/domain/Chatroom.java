package ssafy.a709.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ssafy.a709.dto.ChatRoomDTO;

import javax.persistence.*;
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class Chatroom {
    public static Chatroom toEntity(ChatRoomDTO chatRoomDTO){
        return Chatroom.builder()
                .chatroomId(chatRoomDTO.getChatRoomId())
                //유저 써야뎀 .user1(chatRoomDTO.getUser1().toEntity())
                //.content(dto.getContent())
                //.writer(dto.getWriter())
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
    @JoinColumn(name = "l_chat_id", referencedColumnName = "chat_id")
    private Chat chat;
}
