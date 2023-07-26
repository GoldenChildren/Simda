package ssafy.a709.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class Chatroom {

    @Id
    private int roomId;

    private int user1Id;

    private int user2Id;
    @Column(name = "l_chat_id")
    private int lChatId;
}
