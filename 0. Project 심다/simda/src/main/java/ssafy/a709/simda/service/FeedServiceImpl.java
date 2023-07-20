package ssafy.a709.simda.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssafy.a709.simda.repository.FeedRepository;
import ssafy.a709.simda.domain.Feed;
import ssafy.a709.simda.dto.FeedDto;

import java.util.ArrayList;
import java.util.List;
@Service
public class FeedServiceImpl implements FeedService{
    @Autowired
    private FeedRepository feedRepository;
//    @Override
//    public List<FeedDto> getListAround(double lat, double lng) {
//        List<Feed> list = feedRepository.getListAround(lat, lng);
//        List<FeedDto> resList = new ArrayList<>();
//        for (int i = 0; i < list.size(); i++) {
//            resList.add(FeedDto.changeToFeedDto(list.get(i)));
//        }
//        return resList;
//    }
//    @Override
//    public List<FeedDto> getListFollow(int userId) {
//        List<FeedDto> resList = new ArrayList<>();
//        List<Feed> list = feedRepository.getListByMyId(userId);
//        for (int j = 0; j < list.size(); j++) {
//            resList.add(FeedDto.changeToFeedDto(list.get(j)));
//        }
//        return resList;
//    }
//    @Override
//    public List<FeedDto> getMyFeedList(int userId) {
//        List<FeedDto> resList = new ArrayList<>();
//        List<Feed> list = feedRepository.findAllByUserId(userId);
//        for (int j = 0; j < list.size(); j++) {
//            resList.add(FeedDto.changeToFeedDto(list.get(j)));
//        }
//        return resList;
//    }
//    @Override
//    public boolean writeFeed(FeedDto feedDto) {
//        if(feedDto.getImg() == null )
//            return false;
//        feedRepository.save(Feed.changeToFeed(feedDto));
//        return true;
//    }
//
//    @Override
//    public boolean hitLikePoint(int feedId) {
//        try {
//            feedRepository.updateLike(feedId);
//        }catch (Exception e){
//            return false;
//        }
//        return true;
//    }
//
//    @Override
//    public boolean delete(int feedId) {
//        return false;
//    }
}
