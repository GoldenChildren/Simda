package ssafy.a709.simda.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssafy.a709.simda.domain.Comment;
import ssafy.a709.simda.domain.User;
import ssafy.a709.simda.dto.CommentDto;
import ssafy.a709.simda.repository.CommentRepository;
import ssafy.a709.simda.repository.FeedRepository;
import ssafy.a709.simda.domain.Feed;
import ssafy.a709.simda.dto.FeedDto;
import ssafy.a709.simda.repository.UserRepository;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
@Service
public class FeedServiceImpl implements FeedService{
    @Autowired
    private FeedRepository feedRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private CommentRepository commentRepository;

    @Override
    public boolean createFeed(FeedDto feedDto) {
        if(feedDto.getImg() == null )
            return false;
        System.out.println(feedDto);
        feedRepository.save(Feed.changeToFeed(feedDto));
        return true;
    }

    @Override
    public List<FeedDto> selectAroundList(double lat, double lng) {
        long oneDayInMillis = 24 * 60 * 60 * 1000;
        Date oneDayAgo = new Date(System.currentTimeMillis() - oneDayInMillis);
        List<Feed> list = feedRepository.findFeedAroundAndWithinOneDay(lat, lng, oneDayAgo);
        List<FeedDto> resList = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            User feedUser = userRepository.findByUserId(list.get(i).getUser().getUserId());
            List<CommentDto> commentDtos = getCommentDtos(list.get(i));
            FeedDto feeddto = FeedDto.changeToFeedDto(list.get(i), feedUser, commentDtos);
            resList.add(feeddto);
        }
        return resList;
    }
    @Override
    public List<FeedDto> selectFollowList(int userId) {
        List<FeedDto> resList = new ArrayList<>();
        List<Feed> list = feedRepository.getListByMyId(userId);
        for (int i = 0; i < list.size(); i++) {
            User feedUser = userRepository.findByUserId(list.get(i).getUser().getUserId());
            List<CommentDto> commentDtos = getCommentDtos(list.get(i));
            FeedDto feeddto = FeedDto.changeToFeedDto(list.get(i), feedUser, commentDtos);
            resList.add(feeddto);
        }
        return resList;
    }
    @Override
    public List<FeedDto> selectMyFeedList(int userId) {
        List<FeedDto> resList = new ArrayList<>();
        List<Feed> list = feedRepository.findAllByUser_UserId(userId);
        for (int i = 0; i < list.size(); i++) {
            User feedUser = userRepository.findByUserId(list.get(i).getUser().getUserId());
            List<CommentDto> commentDtos = getCommentDtos(list.get(i));
            FeedDto feeddto = FeedDto.changeToFeedDto(list.get(i), feedUser, commentDtos);
            resList.add(feeddto);
        }
        return resList;
    }

    @Override
    public boolean hitLikePoint(int feedId) {
        try {
            feedRepository.updateLike(feedId);
        }catch (Exception e){
            return false;
        }
        return true;
    }
    @Override
    public boolean updateFeed(FeedDto feedDto) {
        try{
            Feed feed = feedRepository.findById(feedDto.getFeedId()).get();
            feed.update(feedDto);
            feedRepository.save(feed);
        }catch (Exception e){
            return false;
        }
        return true;
    }

    @Override
    public boolean deleteFeed(int feedId) {
        try {
            feedRepository.deleteById(feedId);
        }catch (Exception e){
            return false;
        }
        return true;
    }

    // feed로 댓글 리스트를 받아온다
    private List<CommentDto> getCommentDtos(Feed feed) {
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
    private List<CommentDto> getSubCommentDtos(Comment comment) {
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

}
