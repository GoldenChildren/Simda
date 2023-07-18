package ssafy.a709.service;

import org.springframework.stereotype.Service;
import ssafy.a709.dto.FeedDto;
import ssafy.a709.dto.UserDto;

import java.util.List;

@Service
public interface FeedService {
    List<FeedDto> getListAround(double lat, double lng);

    List<FeedDto> getListFollow(int userId);

    List<FeedDto> getMyFeedList(int userId);

    boolean writeFeed(FeedDto feedDto);

    boolean hitLikePoint(int  feedId);

    boolean delete(int feedId);
}
