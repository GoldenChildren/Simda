package ssafy.a709.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ssafy.a709.dto.CommentDto;
import ssafy.a709.dto.FeedDto;
import ssafy.a709.dto.UserDto;

import javax.persistence.*;

@Builder
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

    // CommentDto를 Comment(Entity)로 변환
    public static Comment changeToComment(CommentDto commentDto){
        return Comment.builder()
                .cmtId(commentDto.getCmtId())
                .user(User.changeToUser(commentDto.getUserDto()))
                .feed(Feed.changeToFeed(commentDto.getFeedDto()))
                .comment(Comment.changeToComment(commentDto.getCommentDto()))
                .content(commentDto.getContent())
                .build();
    }
}
