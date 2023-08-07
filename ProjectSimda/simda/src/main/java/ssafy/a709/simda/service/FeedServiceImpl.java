package ssafy.a709.simda.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssafy.a709.simda.domain.User;
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

    @Override
    public boolean createFeed(FeedDto feedDto) {
        if(feedDto.getImg() == null )
            return false;
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
            FeedDto feeddto = FeedDto.changeToFeedDto(list.get(i), feedUser);
            resList.add(feeddto);
        }
        return resList;
    }
    @Override
    public List<FeedDto> selectFollowList(int userId) {
        List<FeedDto> resList = new ArrayList<>();
        List<Feed> list = feedRepository.getListByMyId(userId);
        for (int j = 0; j < list.size(); j++) {
            User feedUser = userRepository.findByUserId(list.get(j).getUser().getUserId());
            FeedDto feeddto = FeedDto.changeToFeedDto(list.get(j), feedUser);
            resList.add(feeddto);
        }
        return resList;
    }
    @Override
    public List<FeedDto> selectMyFeedList(int userId) {
        List<FeedDto> resList = new ArrayList<>();
        List<Feed> list = feedRepository.findAllByUser_UserId(userId);
        for (int j = 0; j < list.size(); j++) {
            User feedUser = userRepository.findByUserId(list.get(j).getUser().getUserId());
            FeedDto feeddto = FeedDto.changeToFeedDto(list.get(j), feedUser);
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

}
