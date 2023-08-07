package ssafy.a709.simda;

import java.io.*;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import okhttp3.*;
import java.net.URI;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import org.json.JSONObject;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.test.context.SpringBootTest;
import ssafy.a709.simda.controller.FeedController;
import ssafy.a709.simda.domain.*;
import ssafy.a709.simda.dto.CommentDto;
import ssafy.a709.simda.dto.FeedDto;
import ssafy.a709.simda.dto.FollowDto;
import ssafy.a709.simda.repository.CommentRepository;
import ssafy.a709.simda.repository.FeedRepository;
import ssafy.a709.simda.repository.UserRepository;
import ssafy.a709.simda.service.CommentService;
import ssafy.a709.simda.service.FeedService;
import ssafy.a709.simda.service.FollowService;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.SQLOutput;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


@SpringBootTest
class SimdaApplicationTests {
//    @Test
//    void contextLoads() throws IOException {
//        System.out.println(1);
//        OkHttpClient client = new OkHttpClient().newBuilder()
//                .build();
//        MediaType mediaType = MediaType.parse("text/plain");
//        RequestBody body = new MultipartBody.Builder().setType(MultipartBody.FORM)
//                .addFormDataPart("url", "http://hive-public.s3.amazonaws.com/demo_request/gun1.jpg")
//                .build();
//        Request request = new Request.Builder()
//                .url("https://api.thehive.ai/api/v2/task/sync")
//                .method("POST", body)
//                .addHeader("accept", "application/json")
//                .addHeader("authorization", "ZRb0om5O9maqyTwU2jxHP1ySuWWmc473")
//                .build();
//        Response response = client.newCall(request).execute();
//        System.out.println(response.body().string());
//        System.out.println(2);
//    }
//    @Test
//    void test2(){
//
//    }

//	@Autowired
//	UserRepository userRepository;
//	@Autowired
//	FeedRepository feedRepository;
//	@Autowired
//	CommentRepository commentRepository;
//	@Autowired
//	FeedService feedService;
//	@Autowired
//	FollowService followService;
//	@Autowired
//	CommentService commentService;
//	@Test
//	void contextLoads() {
//		User user = User.builder()
//				.nickname("LJM")
////				.socialToken("77777")
////				.socialType("KAKAO")
//		.build();
//		System.out.println(user.toString());
//		userRepository.save(user);
//	}
//	@Test
//	void writeFeed(){
//		User user = userRepository.findByUserId(4);
//		User user2 = userRepository.findByUserId(4);
//		Feed feed = Feed.builder()
//				.user(user)
//				.img("이미지11")
//				.emotion(1)
//				.content("내용11")
//				.lat(129.11111)
//				.lng(38.83334)
//				.likeCnt(0)
//				.build();
//		Feed feed2 = Feed.builder()
//				.user(user2)
//				.img("이미지12")
//				.emotion(2)
//				.content("내용12")
//				.lat(129.11111)
//				.lng(38.83334)
//				.likeCnt(0)
//				.build();
//		feedRepository.save(feed);
//		feedRepository.save(feed2);
//	}
//	@Test
//	void selectTest(){
////		List<FeedDto> list = feedService.getListAround(128.1, 37.8);
////		List<FeedDto> list = feedService.getMyFeedList(2);
//		List<FeedDto> list = feedService.selectFollowList(4);
//		for (int i = 0; i < list.size(); i++) {
//			System.out.println(list.get(i));
//		}
//
//	}
//	@Test
//	void likeHit(){
//		System.out.println(feedService.hitLikePoint(6));
//		System.out.println(feedService.hitLikePoint(7));
//		System.out.println(feedService.hitLikePoint(8));
//		feedRepository.updateLike(9);
//	}
//	@Test
//	void Modify(){
//		FeedDto fd = FeedDto.builder()
//				.feedId(5)
//				.content("전현태 수정")
//				.emotion(1)
//				.img("이미지 저장소")
//				.lat(218)
//				.lng(18)
//				.build();
//		feedService.updateFeed(fd);
//	}
//	@Test
//	void Delete(){
//		commentService.deleteCommentByFeedId(3);
//		feedService.deleteFeed(3);
//	}
//	@Test
//	void CommentTest(){
//		// Write
////		CommentDto commentDto = CommentDto.builder().pCmtId(5).userId(4).feedId(2).content("대댓글 테스트1").build();
////		Feed nowFeed = feedRepository.findById(commentDto.getFeedId()).get();
////		User nowUser = userRepository.findById(commentDto.getUserId()).get();
////		Optional<Comment> opComment = commentRepository.findById(commentDto.getPCmtId());
////		Comment pComment = opComment.isPresent() ? opComment.get() : null;
////		Comment newComment = Comment.changeToComment(commentDto, nowUser, nowFeed, pComment);
////		commentRepository.save(newComment);
//
//
//		// Select
////		List<Comment> list = commentRepository.findByFeed_FeedIdAndByComment_PCntIdIsNull(3);
////		List<CommentDto> reslist = new ArrayList<>();
////		for (int i = 0; i < list.size(); i++) {
////			System.out.println("=============댓글" + CommentDto.changeToCommentDto(list.get(i)));
////			reslist.add(CommentDto.changeToCommentDto(list.get(i)));
////			List<Comment> clist = commentRepository.findByComment_PCommentId(list.get(i).getCmtId());
////			List<CommentDto> creslist = new ArrayList<>();
////			for (int j = 0; j < clist.size(); j++) {
////				System.out.println(CommentDto.changeToCommentDto(clist.get(j)));
////				creslist.add(CommentDto.changeToCommentDto(clist.get(j)));
////			}
////			reslist.get(i).setCCommentList(creslist);
////		}
////		System.out.println(reslist);
//
//		//Delete
////		commentService.deleteComment(1);
//	}
//	@Test
//	void LoginTest() throws FirebaseAuthException {
//		String uid = "L3nWeUbcXghB8uFTepumAXKAQIx2";
//		UserRecord userRecord = FirebaseAuth.getInstance().getUser(uid);
//		// 사용자 정보를 가져와서 처리합니다.
//		String displayName = userRecord.getDisplayName();
//		String email = userRecord.getEmail();
//		String phoneNumber = userRecord.getPhoneNumber();
//		// 여기서 uid와 email을 이용하여 사용자 정보를 가져와서 처리합니다.
//		// 예를 들어, 사용자 정보를 로그에 출력하여 확인합니다.
//		System.out.println("User ID: " + uid);
//		System.out.println("Email: " + email);
//		System.out.println(displayName);
//		System.out.println(phoneNumber);
//
//	}


}


