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

    // Comment Id
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cmt_id")
    private int cmtId;

    // Many(User Id) to One(User Id)
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    private User user;

    // Many(Feed Id) to One(Feed Id)
    @ManyToOne
    @JoinColumn(name = "feed_id", referencedColumnName = "feed_id")
    private Feed feed;

    // Many(Parent Comment Id) to One(User Commet)
    @ManyToOne
    @JoinColumn(name = "p_cmt_id", referencedColumnName = "cmt_id")
    private Comment comment;

    // Content
    @Column(name = "content", nullable = false, columnDefinition = "text")
    private String content;
}
