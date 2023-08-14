package ssafy.a709.simda.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ssafy.a709.simda.domain.Comment;
import ssafy.a709.simda.domain.Feed;
import ssafy.a709.simda.domain.User;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.TimeZone;


@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class FeedDto {
    // Feed Id
    private int feedId;
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
    //Writer Nick
    private String nickname;
    //Writer id
    private int userId;
    // Comment
    private List<CommentDto> comments;
    // Feed(Entity)를 FeedDto로 변환
    public static FeedDto changeToFeedDto(Feed feed, User user, List<CommentDto> comments){
        if (comments == null) {
            comments = new ArrayList<>(); // 댓글이 없는 경우 빈 리스트 생성
        }

        return FeedDto.builder()
                .feedId(feed.getFeedId())
                .title(feed.getTitle())
                .emotion(feed.getEmotion())
                .nickname(user==null?"탈퇴한 유저입니다.":user.getNickname())
                .userId(user==null?null:user.getUserId())
                .content(feed.getContent())
                .img(feed.getImg())
                .lat(feed.getLat())
                .lng(feed.getLng())
                .likeCnt(feed.getLikeCnt())
                .regDate(convertUtcToSeoul(feed.getRegDate()))
                .comments(comments)
                .build();
    }

    private static String convertUtcToSeoul(Timestamp regDate){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul")); // UTC+9 타임존 설정

        return sdf.format(regDate);
    }

}
