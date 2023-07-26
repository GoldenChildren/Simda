package ssafy.a709.simda.service;

import ssafy.a709.simda.dto.CommentDto;
import ssafy.a709.simda.dto.FeedDto;

import java.util.List;

public interface CommentService {
    boolean createComment(CommentDto commentDto);

    List<CommentDto> selectCommentList(int feedId);

    boolean deleteComment(int commentId);

    boolean deleteCommentByFeedId(int feedId);
}
