package ssafy.a709.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class Chatroom {

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
