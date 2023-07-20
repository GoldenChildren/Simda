package ssafy.a709.simda.service;

import ssafy.a709.simda.dto.CommentDto;
import ssafy.a709.simda.dto.FeedDto;

import java.util.List;

public interface CommentService {
    boolean writeComment(CommentDto commentDto);

    List<CommentDto> getCommentList(int feedId);

    boolean deleteComment(int commentId);

    boolean deleteCommentByFeedId(int feedId);
}
