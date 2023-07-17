package ssafy.a709.domain;

import lombok.*;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import java.sql.Timestamp;
import java.util.Date;



@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class Chat {
    @Id
    @GeneratedValue
    private int chatId;

    private int roomId;

    private int userId;

    private String content;

    private Timestamp regDate;

    private boolean read;
}
