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
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "chatroom_id")
    private int chatroomId;
    @ManyToOne
    @JoinColumn(name = "user1_id", referencedColumnName = "user_id")
    private User user1;
    @ManyToOne
    @JoinColumn(name = "user2_id", referencedColumnName = "user_id")
    private User user2;
    @OneToOne
    @JoinColumn(name = "l_chat_id", referencedColumnName = "chat_id")
    private Chat chat;
}
