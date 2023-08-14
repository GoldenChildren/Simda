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
            User nowUser = userRepository.findById(commentDto.getUserDto().getUserId()).get();
            Optional<Comment> opComment = commentRepository.findById(commentDto.getPCmtId());
            Comment pComment = opComment.isPresent() ? opComment.get() : null;
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
            e.printStackTrace();
            return false;
        }
        return true;
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
        return true;
    }

    // feed로 댓글 리스트를 받아온다
    @Override
    public List<CommentDto> getCommentDtos(Feed feed) {
        // comments로 원 댓글 (대댓글이 아닌 댓글) 을 전부 불러온다.
        List<Comment> comments = commentRepository.findByFeed_FeedIdAndByComment_PCntIdIsNull(feed.getFeedId());
        // 댓글을 Dto로 바꿔서 저장할 리스트
        List<CommentDto> commentDtos = new ArrayList<>();
        // 각 댓글 별로 대댓글을 가져온다.
        for (Comment comment : comments) {
            // 대댓글을 Dto로 바꿔서 저장할 리스트
            List<CommentDto> subComments = getSubCommentDtos(comment);
            // 각 comment를 Dto로 바꾸는 과정
            CommentDto commentDto = CommentDto.changeToCommentDto(comment);
            // 대댓글 리스트를 commentDto에 저장한다.
            commentDto.setCCommentList(subComments);
            // 리턴해줄 commentDtos 배열에 완성된 하나의 commentDto를 add해준다.
            commentDtos.add(commentDto);
        }
        // 완성된 commentDtos를 리턴해준다.
        return commentDtos;
    }

    // comment로 대댓글 리스트를 받아온다
    @Override
    public List<CommentDto> getSubCommentDtos(Comment comment) {
        // 대댓글 리스트를 받아온다.
        List<Comment> subComments = commentRepository.findByComment_PCommentId(comment.getCmtId());
        // 대댓글 Dto를 넣어줄 리스트를 생성
        List<CommentDto> subCommentDtos = new ArrayList<>();
        // 각 대댓글을 Dto로 바꿔서 저장해주는 작업
        for (Comment subComment : subComments) {
            // 하나의 대댓글을 Dto로 바꾼다.
            CommentDto subCommentDto = CommentDto.changeToCommentDto(subComment);
            // 바뀐 Dto를 subCommentDtos에 넣어준다.
            subCommentDtos.add(subCommentDto);
        }
        // subCommentDto List를 리턴
        return subCommentDtos;
    }

    // 유저가 작성한 comment 전부 삭제 (userId null 처리)
    @Override
    public boolean deleteUserComment(int userId) {
        try{
            commentRepository.deleteUserComment(userId);
        }catch (Exception e){
            return false;
        }
        return true;
    }
}
