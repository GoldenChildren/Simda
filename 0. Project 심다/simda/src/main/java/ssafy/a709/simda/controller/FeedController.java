package ssafy.a709.simda.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ssafy.a709.simda.service.CommentService;
import ssafy.a709.simda.service.FeedService;
import ssafy.a709.simda.dto.FeedDto;

import java.util.List;

@RestController
@RequestMapping("/feed")
public class FeedController {
    private static final String SUCCESS = "success";
    private static final String FAIL = "fail";
    @Autowired
    private FeedService feedService;
    @Autowired
    private CommentService commentService;
    @PostMapping("")
    public ResponseEntity<String> writeFeed(@RequestBody FeedDto feedDto) {
        if (feedService.writeFeed(feedDto)) {
            return new ResponseEntity<String>(SUCCESS, HttpStatus.OK);
        }
        return new ResponseEntity<String>(FAIL, HttpStatus.NO_CONTENT);
    }

   // 내 lat, lng로 주변의 피드목록 가져오기
    @GetMapping("/")
    public ResponseEntity<List<FeedDto>> getFeedListByMyAround(@RequestParam("lat") double lat, @RequestParam("lng") double lng) {
        return new ResponseEntity<List<FeedDto>>(feedService.getListAround(lat, lng), HttpStatus.OK);
    }

    // 내 Id로 내가 팔로우 한 사람들의 피드목록 가져오기
    @GetMapping("/follow")
    public ResponseEntity<List<FeedDto>> getFollowFeedListByUser(@RequestParam("userId") int userId) {
        return new ResponseEntity<List<FeedDto>>(feedService.getListFollow(userId), HttpStatus.OK);
    }

    // 유저 Id로 내 피드목록 가져오기
    @GetMapping("/{userId}")
    public ResponseEntity<List<FeedDto>> getUserArticleList(@PathVariable("userId") int userId){
        return new ResponseEntity<List<FeedDto>>(feedService.getMyFeedList(userId), HttpStatus.OK);
    }
    @PutMapping("/like")
    public ResponseEntity<String> hitLikePoint(@RequestBody FeedDto feedDto) {
        if (feedService.hitLikePoint(feedDto.getFeedId())) {
            return new ResponseEntity<String>(SUCCESS, HttpStatus.OK);
        }
        return new ResponseEntity<String>(FAIL, HttpStatus.NO_CONTENT);
    }
    @PutMapping("/")
    public ResponseEntity<String> modifyFeed(@RequestBody FeedDto feedDto) {
        if (feedService.modifyFeed(feedDto)) {
            return new ResponseEntity<String>(SUCCESS, HttpStatus.OK);
        }
        return new ResponseEntity<String>(FAIL, HttpStatus.NO_CONTENT);
    }
    @DeleteMapping("/")
    public ResponseEntity<String> deleteFeed(@RequestHeader("feedId") int feedId) {

        if (commentService.deleteCommentByFeedId(feedId) && feedService.deleteFeed(feedId)) {
            return new ResponseEntity<String>(SUCCESS, HttpStatus.OK);
        }
        return new ResponseEntity<String>(FAIL, HttpStatus.NO_CONTENT);
    }
}
