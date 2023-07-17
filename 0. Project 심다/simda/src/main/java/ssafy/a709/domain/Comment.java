package ssafy.a709.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cmt_id")
    private int cmtId;
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    private User user;
    @ManyToOne
    @JoinColumn(name = "feed_id", referencedColumnName = "feed_id")
    private Feed feed;
    @ManyToOne
    @JoinColumn(name = "p_cmt_id", referencedColumnName = "cmt_id")
    private Comment comment;
    @Column(name = "content", nullable = false, columnDefinition = "text")
    private String content;
}
