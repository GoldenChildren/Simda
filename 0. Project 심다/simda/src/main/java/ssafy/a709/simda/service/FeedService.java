package ssafy.a709.simda.service;

import ssafy.a709.simda.dto.FeedDto;

import java.util.List;

public interface FeedService {
    boolean writeFeed(FeedDto feedDto);
    List<FeedDto> getListAround(double lat, double lng);
    List<FeedDto> getListFollow(int userId);
    List<FeedDto> getMyFeedList(int userId);
    boolean hitLikePoint(int  feedId);
    boolean deleteFeed(int feedId);
    boolean modifyFeed(FeedDto feedDto);
}
