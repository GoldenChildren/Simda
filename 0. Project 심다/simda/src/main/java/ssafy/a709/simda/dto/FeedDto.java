package ssafy.a709.simda.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ssafy.a709.simda.domain.Feed;
import ssafy.a709.simda.domain.User;

import java.sql.Timestamp;


@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class FeedDto {
    // Feed Id
    private int feedId;
    // Many(User Id) to One(User Id)
    private UserDto userDto;
    // Title
    private String title;
    // Emotion
    private int emotion;
    // Content
    private String content;
    // Image Address
    private String img;
    // Latitude
    private double lat;
    // Longitude
    private double lng;
    // Linke Point
    private int likeCnt;
    // Regist Date
    private String regDate;
    // Feed(Entity)를 FeedDto로 변환
    public static FeedDto changeToFeedDto(Feed feed, User user){
        return FeedDto.builder()
                .feedId(feed.getFeedId())
                .userDto(UserDto.changeToUserDto(user))
                .title(feed.getTitle())
                .emotion(feed.getEmotion())
                .content(feed.getContent())
                .img(feed.getImg())
                .lat(feed.getLat())
                .lng(feed.getLng())
                .likeCnt(feed.getLikeCnt())
                .regDate(feed.getRegDate().toString())
                .build();
    }
}
