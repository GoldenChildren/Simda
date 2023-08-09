package ssafy.a709.simda.domain;

import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import ssafy.a709.simda.dto.CommentDto;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Entity
public class Comment {

    // Comment Id
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cmt_id")
    private int cmtId;

    // Many(User Id) to One(User Id)
    @ManyToOne (fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    private User user;

    // Many(Feed Id) to One(Feed Id)
    @ManyToOne (fetch = FetchType.LAZY)
    @JoinColumn(name = "feed_id", referencedColumnName = "feed_id")
    private Feed feed;

    // Content
    @Column(name = "content", nullable = false, columnDefinition = "text")
    private String content;

    // Many(Parent Comment Id) to One(User Commet)
    @ManyToOne (fetch = FetchType.LAZY)
    @JoinColumn(name = "p_cmt_id", referencedColumnName = "cmt_id")
    private Comment pComment;

    @CreationTimestamp
    @Column(name = "reg_time", nullable = false, columnDefinition = "timestamp DEFAULT CURRENT_TIMESTAMP")
    private Timestamp regTime;

    // CommentDto를 Comment(Entity)로 변환
    public static Comment changeToComment(CommentDto commentDto, User user, Feed feed, Comment pComment){
        return Comment.builder()
                .cmtId(commentDto.getCmtId())
                .user(user)
                .feed(feed)
                .pComment(pComment)
                .content(commentDto.getContent())
                .build();
    }

    // 부모 댓글 수정
    public void updateParent(Comment pComment){
        this.pComment = pComment;
    }
}
