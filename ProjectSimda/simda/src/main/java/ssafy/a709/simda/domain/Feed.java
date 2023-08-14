package ssafy.a709.simda.domain;

import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.Where;
import ssafy.a709.simda.dto.FeedDto;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.List;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Entity
@Where(clause = "user_id is not null")
public class Feed {

    // Feed Id
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "feed_id")
    private int feedId;

    // Many(User Id) to One(User Id)
    @ManyToOne (fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false, referencedColumnName = "user_id")
    private User user;

    // Title
    @Column(name = "title", nullable = false, columnDefinition = "varchar(50)")
    private String title;

    // Emotion
    @Column(name = "emotion", nullable = false, columnDefinition = "int")
    private int emotion;

    // Content
    @Column(name = "content", columnDefinition = "text ")
    private String content;

    // Image Address
    @Column(name = "img", nullable = false, columnDefinition = "varchar(200)")
    private String img;

    // Latitude
    @Column(name = "lat", nullable = false, columnDefinition = "double")
    private double lat;

    // Longitude
    @Column(name = "lng", nullable = false, columnDefinition = "double")
    private double lng;

    // Linke Point
    @Column(name = "like_cnt", nullable = false, columnDefinition = "int")
    private int likeCnt;

    // Regist Date
    @CreationTimestamp
    @Column(name = "reg_date", nullable = false, columnDefinition = "timestamp DEFAULT CURRENT_TIMESTAMP")
    private Timestamp regDate;

    // 피드 내용 (내용, 감정, 이미지) 수정
    public void update(FeedDto feedDto){
        this.title = feedDto.getTitle();
        this.content = feedDto.getContent();
        this.emotion = feedDto.getEmotion();
        this.img = feedDto.getImg();
    }
    // FeedDto를 Feed(Entity)로 변환
    public static Feed changeToFeed(FeedDto feedDto){
        return Feed.builder()
                .feedId(feedDto.getFeedId())
                .user(User.builder().userId(feedDto.getUserId()).nickname(feedDto.getNickname()).build())
                .title(feedDto.getTitle())
                .emotion(feedDto.getEmotion())
                .content(feedDto.getContent())
                .img(feedDto.getImg())
                .lat(feedDto.getLat())
                .lng(feedDto.getLng())
                .likeCnt(feedDto.getLikeCnt())
                .build();
    }
}
