package ssafy.a709.simda.service;

import ssafy.a709.simda.dto.FeedDto;

import java.util.List;

public interface FeedService {
    boolean createFeed(FeedDto feedDto);
    List<FeedDto> selectAroundList(double lat, double lng);
    List<FeedDto> selectFollowList(int userId);
    List<FeedDto> selectMyFeedList(int userId);
    boolean hitLikePoint(int  feedId);
    boolean deleteFeed(int feedId);
    boolean updateFeed(FeedDto feedDto);
}
