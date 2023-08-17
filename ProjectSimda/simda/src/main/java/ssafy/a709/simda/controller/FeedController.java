package ssafy.a709.simda.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ssafy.a709.simda.API.API;
import ssafy.a709.simda.dto.FeedList;
import org.springframework.web.multipart.MultipartFile;
import ssafy.a709.simda.service.CommentService;
import ssafy.a709.simda.service.FeedService;
import ssafy.a709.simda.dto.FeedDto;
import ssafy.a709.simda.service.FileService;

import java.io.IOException;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("/feed")
public class FeedController {
    private static final String SUCCESS = "success";
    private static final String FAIL = "fail";
    @Autowired
    private FeedService feedService;
    @Autowired
    private CommentService commentService;
    @Autowired
    private FileService fileService;

    @PostMapping("/")
    public ResponseEntity<String> addFeed(@RequestBody FeedDto feedDto) {
        log.debug("method = POST, url = \"/feed\"");
        log.debug("addFeed 메서드 시작: feedDto = {}", feedDto);
        if (feedService.createFeed(feedDto)) {
            return new ResponseEntity<String>(SUCCESS, HttpStatus.OK);
        }
        return new ResponseEntity<String>(FAIL, HttpStatus.NO_CONTENT);
    }

   // 내 lat, lng로 주변의 피드목록 가져오기
    @GetMapping("/")
    public ResponseEntity<FeedList> getFeedListByMyAround(@RequestParam("lat") double lat, @RequestParam("lng") double lng,@RequestParam("zoomLevel") double zoomLevel ) {
        log.debug("method = GET, url = \"/feed\"");
        log.debug("getFeedListByMyAround 메서드 시작: lat = {}, lng = {}", lat, lng);
        FeedList feedList = FeedList.builder().feedList(feedService.selectAroundList(lat, lng,zoomLevel)).build();
        return new ResponseEntity<FeedList>(feedList, HttpStatus.OK);
    }

    // 내 Id로 내가 팔로우 한 사람들의 피드목록 가져오기
    @GetMapping("/follow")
    public ResponseEntity<FeedList> getFollowFeedListByUser(@RequestParam("userId") int userId) {
        log.debug("method = GET, url = \"/feed/follow\"");
        log.debug("getFollowFeedListByUser 메서드 시작: userId = {}", userId);
        FeedList feedList = FeedList.builder().feedList(feedService.selectFollowList(userId)).build();
        return new ResponseEntity<FeedList>(feedList, HttpStatus.OK);
    }

    // 내 Id로 내 피드목록 가져오기
    @GetMapping("/{userId}")
    public ResponseEntity<FeedList> getArticleInfo(@PathVariable("userId") int userId){
        log.debug("method = GET, url = \"/feed/{userId}\"");
        log.debug("getArticleInfo 메서드 시작: userId = {}", userId);
        FeedList feedList = FeedList.builder().feedList(feedService.selectMyFeedList(userId)).build();
        return new ResponseEntity<FeedList>(feedList, HttpStatus.OK);
    }
    @PutMapping("/like")
    public ResponseEntity<String> hitLikePoint(@RequestBody FeedDto feedDto) {
        log.debug("method = PUT, url = \"/feed/like\"");
        log.debug("hitLikePoint 메서드 시작: feedDto = {}", feedDto);
        if (feedService.hitLikePoint(feedDto.getFeedId())) {
            return new ResponseEntity<String>(SUCCESS, HttpStatus.OK);
        }
        return new ResponseEntity<String>(FAIL, HttpStatus.NO_CONTENT);
    }
    @PutMapping("/")
    public ResponseEntity<String> modifyFeed(@RequestBody FeedDto feedDto) {
        log.debug("method = PUT, url = \"/feed\"");
        log.debug("modifyFeed 메서드 시작: feedDto = {}", feedDto);
        if (feedService.updateFeed(feedDto)) {
            return new ResponseEntity<String>(SUCCESS, HttpStatus.OK);
        }
        return new ResponseEntity<String>(FAIL, HttpStatus.NO_CONTENT);
    }
    @DeleteMapping("/")
    public ResponseEntity<String> removeFeed(@RequestHeader("feedId") int feedId) {
        log.debug("method = DELETE, url = \"/feed\"");
        log.debug("removeFeed 메서드 시작: feedId = {}", feedId);
        if (commentService.deleteCommentByFeedId(feedId) && feedService.deleteFeed(feedId)) {
            return new ResponseEntity<String>(SUCCESS, HttpStatus.OK);
        }
        return new ResponseEntity<String>(FAIL, HttpStatus.NO_CONTENT);
    }
}
