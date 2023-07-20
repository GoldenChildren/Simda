package ssafy.a709.simda.domain;

import lombok.*;

import javax.persistence.*;
import java.sql.Timestamp;


@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class Chat {

    // Chat Id
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "chat_id")
    private int chatId;

    // Many(Chatroom Id) to One(Chatroom Id)
    @ManyToOne
    @JoinColumn(name = "chatroom_id",nullable = false, referencedColumnName = "chatroom_id")
    private Chatroom chatroom;

    // Many(User Id) to One(User Id)
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    private User user;

    // Content
    @Column(name = "content", nullable = false, columnDefinition = "text")
    private String content;

    // Regist Date
    @Column(name = "reg_date", nullable = false, columnDefinition = "timestamp")
    private Timestamp regDate;

    // Read Flag
    @Column(name = "read_flag", nullable = false, columnDefinition = "boolean")
    private boolean read_flag;
}
