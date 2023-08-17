package ssafy.a709.simda.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ssafy.a709.simda.dto.CommentDto;
import ssafy.a709.simda.dto.CommentList;
import ssafy.a709.simda.dto.FeedDto;
import ssafy.a709.simda.service.CommentService;
import ssafy.a709.simda.service.FeedService;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/comment")
public class CommentController {
    private static final String SUCCESS = "success";
    private static final String FAIL = "fail";
    @Autowired
    private CommentService commentService;
    @PostMapping("/")
    public ResponseEntity<String> addComment(@RequestBody CommentDto commentDto) {
        log.debug("method = POST, url=\"/comment\"");
        log.debug("addComment 메서드 시작: commentDto = {}", commentDto);
        if (commentService.createComment(commentDto)) {
            return new ResponseEntity<String>(SUCCESS, HttpStatus.OK);
        }
        return new ResponseEntity<String>(FAIL, HttpStatus.NO_CONTENT);
    }
    @GetMapping("/")
    public ResponseEntity<CommentList> getCommentListByMyAround(@RequestParam("feedId") int feedId) {
        log.debug("method = GET, url=\"/comment\"");
        log.debug("getCommentListByMyAround 메서드 시작: feedId = {}", feedId);
        CommentList commentList = CommentList.builder().commentList(commentService.selectCommentList(feedId)).build();
        return new ResponseEntity<CommentList>(commentList, HttpStatus.OK);
    }
    @DeleteMapping("/")
    public ResponseEntity<String> removeComment(@RequestHeader("commentId") int commentId) {
        log.debug("method = DELETE, url=\"/comment\"");
        log.debug("removeComment 메서드 시작: commentId = {}", commentId);
        if (commentService.deleteComment(commentId)) {
            return new ResponseEntity<String>(SUCCESS, HttpStatus.OK);
        }
        return new ResponseEntity<String>(FAIL, HttpStatus.NO_CONTENT);
    }
}
