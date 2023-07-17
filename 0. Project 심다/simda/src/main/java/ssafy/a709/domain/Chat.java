package ssafy.a709.domain;

import lombok.*;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.Date;



@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class Chat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "chat_id")
    private int id;
    @Column(name = "room_id", nullable = false, columnDefinition = "int")
    private int roomId;
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    private User user;
    @Column(name = "content", nullable = false, columnDefinition = "text")
    private String content;
    @Column(name = "reg_date", nullable = false, columnDefinition = "timestamp")
    private Timestamp regDate;
    @Column(name = "read", nullable = false, columnDefinition = "boolean")
    private boolean read;
}
