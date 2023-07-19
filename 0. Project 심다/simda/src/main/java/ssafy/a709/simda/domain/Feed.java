package ssafy.a709.simda.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import javax.persistence.*;
import java.sql.Timestamp;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Table
public class Feed {

    // Feed Id
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "feed_id")
    private int feedId;

    // Many(User Id) to One(User Id)
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false, referencedColumnName = "user_id")
    private User user;

    // Emotion
    @Column(name = "emotion", nullable = false, columnDefinition = "int")
    private int emotion;

    // Content
    @Column(name = "content", columnDefinition = "text ")
    private String content;

    // Image Address
    @Column(name = "img", nullable = false, columnDefinition = "varchar(100)")
    private String img;

    // Latitude
    @Column(name = "lat", nullable = false, columnDefinition = "double")
    private double lat;

    // Longitude
    @Column(name = "lng", nullable = false, columnDefinition = "double")
    private double lng;

    // Like Point
    @Column(name = "like", nullable = false, columnDefinition = "int 0")
    private int like;

    // Regist Date
    @Column(name = "reg_date", nullable = false, columnDefinition = "timestamp")
    private Timestamp regDate;
}
