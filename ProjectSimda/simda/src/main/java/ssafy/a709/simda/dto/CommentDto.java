package ssafy.a709.simda.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ssafy.a709.simda.domain.Comment;

import java.util.ArrayList;
import java.util.List;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class CommentDto {

    // Comment Id
    private int cmtId;

    private UserDto userDto;

    private int feedId;

    private int pCmtId;

    private String regTime;

    // Content
    private String content;
    private List<CommentDto> cCommentList;

    // Comment(Entity)를 CommentDto로 변환
    public static CommentDto changeToCommentDto(Comment comment){
        return CommentDto.builder()
                .cmtId(comment.getCmtId())
                .userDto(UserDto.changeToUserDto(comment.getUser()))
                .feedId(comment.getFeed().getFeedId())
                .pCmtId(comment.getPComment() == null ? -1 : comment.getPComment().getCmtId())
                .regTime(comment.getRegTime().toString())
                .content(comment.getContent())
                .build();
    }
}

