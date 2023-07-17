package ssafy.a709.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import javax.persistence.*;
import java.sql.Timestamp;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class Feed {
    // Feed Id
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "feed_id")
    private int feedId;
    // User Id
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false, referencedColumnName = "user_id")
    private User user;
    @Column(name = "emotion", nullable = false, columnDefinition = "int")
    private int emotion;
    @Column(name = "content", columnDefinition = "text ")
    private String content;
    @Column(name = "img", nullable = false, columnDefinition = "varchar(100)")
    private String img;
    @Column(name = "lat", nullable = false, columnDefinition = "double")
    private double lat;
    @Column(name = "lng", nullable = false, columnDefinition = "double")
    private double lng;
    @Column(name = "like", nullable = false, columnDefinition = "int 0")
    private int like;
    @Column(name = "reg_date", nullable = false, columnDefinition = "timestamp")
    private Timestamp regDate;
}
