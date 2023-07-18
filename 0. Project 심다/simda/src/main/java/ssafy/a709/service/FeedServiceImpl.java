package ssafy.a709.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssafy.a709.domain.Feed;
import ssafy.a709.dto.FeedDto;
import ssafy.a709.repository.CommentRepository;
import ssafy.a709.repository.FeedRepository;

import java.util.ArrayList;
import java.util.List;
@Service
public class FeedServiceImpl implements FeedService{
    @Autowired
    FeedRepository feedRepository;
    @Autowired
    CommentRepository commentRepository;
    @Override
    public List<FeedDto> getListAround(double lat, double lng) {
        List<Feed> list = feedRepository.getListAround(lat, lng);
        List<FeedDto> resList = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            resList.add(FeedDto.changeToFeedDto(list.get(i)));
        }
        return resList;
    }
    @Override
    public List<FeedDto> getListFollow(int userId) {
        List<FeedDto> resList = new ArrayList<>();
        List<Feed> list = feedRepository.getListByMyId(userId);
        for (int j = 0; j < list.size(); j++) {
            resList.add(FeedDto.changeToFeedDto(list.get(j)));
        }
        return resList;
    }
    @Override
    public List<FeedDto> getMyFeedList(int userId) {
        List<FeedDto> resList = new ArrayList<>();
        List<Feed> list = feedRepository.findAllByUserId(userId);
        for (int j = 0; j < list.size(); j++) {
            resList.add(FeedDto.changeToFeedDto(list.get(j)));
        }
        return resList;
    }
    @Override
    public boolean writeFeed(FeedDto feedDto) {
        if(feedDto.getImg() == null )
            return false;
        feedRepository.save(Feed.changeToFeed(feedDto));
        return true;
    }

    @Override
    public boolean hitLikePoint(int feedId) {
        try {
            Feed feed = feedRepository.findByFeedId(feedId);
            feed.setLike(feed.getLike() + 1);
            feedRepository.save(feed);
        }catch (Exception e){
            return false;
        }
        return true;
    }

    @Override
    public boolean delete(int feedId) {
        return false;
    }
}
