package ssafy.a709.simda.service;

import lombok.extern.slf4j.Slf4j;
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

import javax.persistence.EntityNotFoundException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Slf4j
@Service
public class FeedServiceImpl implements FeedService{
    @Autowired
    private FeedRepository feedRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private CommentService commentService;

    @Override
    public boolean createFeed(FeedDto feedDto) {
        log.debug("createFeed 메서드 시작: feedDto = {}", feedDto);
        if(feedDto.getImg() == null ) {
            log.error("createFeed 메서드 오류: 피드 이미지가 없습니다.");
            return false;
        }
        feedRepository.save(Feed.changeToFeed(feedDto));
        return true;
    }

    @Override
    public List<FeedDto> selectAroundList(double lat, double lng, double zoomLevel) {
        log.debug("selectAroundList 메서드 시작: lat = {}, lng = {}", lat, lng);
        long oneDayInMillis = 24 * 60 * 60 * 1000;
        Date oneDayAgo = new Date(System.currentTimeMillis() - oneDayInMillis);
        List<Feed> list = new ArrayList<>();
        try {
            double len = 0.001;
            if (zoomLevel < 16){
                len *= Math.pow(2, 16 - zoomLevel);
            }
            list = feedRepository.findFeedAroundAndWithinOneDay(lat, lng, oneDayAgo, len * len);
        } catch(EntityNotFoundException e){
            log.error(e.getMessage(),e);
        }
        List<FeedDto> resList = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            User feedUser = userRepository.findByUserId(list.get(i).getUser().getUserId());
            List<CommentDto> commentDtos = commentService.getCommentDtos(list.get(i));
            FeedDto feeddto = FeedDto.changeToFeedDto(list.get(i), feedUser, commentDtos);
            resList.add(feeddto);
        }
        return resList;
    }
    @Override
    public List<FeedDto> selectFollowList(int userId) {
        log.debug("selectFollowList 메서드 시작: userId = {}", userId);
        List<FeedDto> resList = new ArrayList<>();
        List<Feed> list = new ArrayList<>();
        try {
            list = feedRepository.getListByMyId(userId);
        }catch (EntityNotFoundException e){
            log.error(e.getMessage(), e);
        }
        for (int i = 0; i < list.size(); i++) {
            User feedUser = userRepository.findByUserId(list.get(i).getUser().getUserId());
            List<CommentDto> commentDtos = commentService.getCommentDtos(list.get(i));
            FeedDto feeddto = FeedDto.changeToFeedDto(list.get(i), feedUser, commentDtos);
            resList.add(feeddto);
        }
        return resList;
    }
    @Override
    public List<FeedDto> selectMyFeedList(int userId) {
        log.debug("selectMyFeedList 메서드 시작: userId = {}", userId);
        List<FeedDto> resList = new ArrayList<>();
        List<Feed> list = feedRepository.findAllByUser_UserId(userId);
        for (int i = 0; i < list.size(); i++) {
            User feedUser = userRepository.findByUserId(list.get(i).getUser().getUserId());
            List<CommentDto> commentDtos = commentService.getCommentDtos(list.get(i));
            FeedDto feeddto = FeedDto.changeToFeedDto(list.get(i), feedUser, commentDtos);
            resList.add(feeddto);
        }
        return resList;
    }

    @Override
    public boolean hitLikePoint(int feedId) {
        log.debug("hitLikePoint 메서드 시작: feedId = {}", feedId);
        try {
            feedRepository.updateLike(feedId);
        }catch (Exception e){
            log.error(e.getMessage(), e);
            return false;
        }
        return true;
    }
    @Override
    public boolean updateFeed(FeedDto feedDto) {
        log.debug("updateFeed 메서드 시작: feedDto = {}", feedDto);
        try{
            Feed feed = feedRepository.findById(feedDto.getFeedId()).get();
            feed.update(feedDto);
            feedRepository.save(feed);
        }catch (Exception e){
            log.error(e.getMessage(),e);
            return false;
        }
        return true;
    }

    @Override
    public boolean deleteUserFeed(int userId) {
        log.debug("deleteUserFeed 메서드 시작: userId = {}", userId);
        try{
            feedRepository.deleteUserFeed(userId);
        }catch (Exception e){
            log.error(e.getMessage(), e);
            return false;
        }
        return true;
    }

    @Override
    public boolean deleteFeed(int feedId) {
        log.debug("deleteFeed 메서드 시작: feedId = {}", feedId);
        try {
            feedRepository.deleteById(feedId);
        }catch (Exception e){
            log.error(e.getMessage(), e);
            return false;
        }
        return true;
    }



}
