package ssafy.a709.simda.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssafy.a709.simda.domain.Comment;
import ssafy.a709.simda.domain.Feed;
import ssafy.a709.simda.domain.User;
import ssafy.a709.simda.dto.CommentDto;
import ssafy.a709.simda.repository.CommentRepository;
import ssafy.a709.simda.repository.FeedRepository;
import ssafy.a709.simda.repository.UserRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class CommentServiceImpl implements CommentService{

    @Autowired
    UserRepository userRepository;
    @Autowired
    FeedRepository feedRepository;
    @Autowired
    private CommentRepository commentRepository;
    @Override
    public boolean createComment(CommentDto commentDto) {
        try {
            Feed nowFeed = feedRepository.findById(commentDto.getFeedId()).get();
            User nowUser = userRepository.findById(commentDto.getUserId()).get();
            Optional<Comment> opComment = commentRepository.findById(commentDto.getPCmtId());
            Comment pComment = opComment.isPresent() ? null : opComment.get();
            Comment newComment = Comment.changeToComment(commentDto, nowUser, nowFeed, pComment);
            commentRepository.save(newComment);
        }catch (Exception e){
            return false;
        }
        return true;
    }

    @Override
    public List<CommentDto> selectCommentList(int feedId) {
        List<Comment> list = commentRepository.findByFeed_FeedIdAndByComment_PCntIdIsNull(feedId);
        List<CommentDto> reslist = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            reslist.add(CommentDto.changeToCommentDto(list.get(i)));
            List<Comment> clist = commentRepository.findByComment_PCommentId(list.get(i).getCmtId());
            List<CommentDto> creslist = new ArrayList<>();
            for (int j = 0; j < clist.size(); j++) {
                creslist.add(CommentDto.changeToCommentDto(clist.get(j)));
            }
            reslist.get(i).setCCommentList(creslist);
        }
        return reslist;
    }

    @Override
    public boolean deleteComment(int commentId) {
        try{
            List<Comment> list = commentRepository.findByComment_PCommentId(commentId);
            for (int i = 0; i < list.size(); i++) {
                commentRepository.deleteById(list.get(i).getCmtId());
            }
            commentRepository.deleteById(commentId);
        }catch (Exception e){
            return false;
        }
        return false;
    }

    @Override
    public boolean deleteCommentByFeedId(int feedId) {
        try{
            List<Comment> list = commentRepository.findByFeed_FeedIdAndByComment_PCntIdIsNull(feedId);
            for (int i = 0; i < list.size(); i++) {
                deleteComment(list.get(i).getCmtId());
            }
        }catch (Exception e){
            return false;
        }
        return false;
    }
}
