package ssafy.a709.simda.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ssafy.a709.simda.dto.CommentDto;
import ssafy.a709.simda.dto.FeedDto;
import ssafy.a709.simda.service.CommentService;
import ssafy.a709.simda.service.FeedService;

import java.util.List;

@RestController
@RequestMapping("/comment")
public class CommentController {
    private static final String SUCCESS = "success";
    private static final String FAIL = "fail";
    @Autowired
    private CommentService commentService;
    @PostMapping("/")
    public ResponseEntity<String> addComment(@RequestBody CommentDto commentDto) {
        if (commentService.createComment(commentDto)) {
            return new ResponseEntity<String>(SUCCESS, HttpStatus.OK);
        }
        return new ResponseEntity<String>(FAIL, HttpStatus.NO_CONTENT);
    }
    @GetMapping("/")
    public ResponseEntity<List<CommentDto>> getCommentListByMyAround(@RequestParam("feedId") int feedId) {
        return new ResponseEntity<List<CommentDto>>(commentService.selectCommentList(feedId), HttpStatus.OK);
    }
    @DeleteMapping("/")
    public ResponseEntity<String> removeComment(@RequestHeader("commentId") int commentId) {
        if (commentService.deleteComment(commentId)) {
            return new ResponseEntity<String>(SUCCESS, HttpStatus.OK);
        }
        return new ResponseEntity<String>(FAIL, HttpStatus.NO_CONTENT);
    }
}
