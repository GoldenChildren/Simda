package ssafy.a709.simda.service;

import ssafy.a709.simda.domain.Comment;
import ssafy.a709.simda.domain.Feed;
import ssafy.a709.simda.dto.CommentDto;
import ssafy.a709.simda.dto.FeedDto;

import java.util.List;

public interface CommentService {
    boolean createComment(CommentDto commentDto);

    List<CommentDto> selectCommentList(int feedId);

    boolean deleteComment(int commentId);

    boolean deleteCommentByFeedId(int feedId);

    // feed로 댓글 리스트를 받아온다
    List<CommentDto> getCommentDtos(Feed feed);

    // comment로 대댓글 리스트를 받아온다
    List<CommentDto> getSubCommentDtos(Comment comment);
}
