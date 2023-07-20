package ssafy.a709.simda;


import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import ssafy.a709.simda.domain.Feed;
import ssafy.a709.simda.domain.Follow;
import ssafy.a709.simda.domain.User;
import ssafy.a709.simda.domain.UserRole;
import ssafy.a709.simda.dto.FeedDto;
import ssafy.a709.simda.dto.FollowDto;
import ssafy.a709.simda.repository.CommentRepository;
import ssafy.a709.simda.repository.FeedRepository;
import ssafy.a709.simda.repository.UserRepository;
import ssafy.a709.simda.service.FeedService;
import ssafy.a709.simda.service.FollowService;

import java.util.List;


@SpringBootTest
class SimdaApplicationTests {
	@Autowired
	UserRepository userRepository;
	@Autowired
	FeedRepository feedRepository;
	@Autowired
	CommentRepository commentRepository;
	@Autowired
	FeedService feedService;
	@Autowired
	FollowService followService;
	@Test
	void contextLoads() {
		User user = User.builder()
				.nickname("SSAFY")
				.socialToken("1234")
				.socialType("KAKAO")
		.build();
		System.out.println(user.toString());
		userRepository.save(user);
	}
	@Test
	void writeFeed(){
		User user = userRepository.findByUserId(4);
		User user2 = userRepository.findByUserId(4);
		Feed feed = Feed.builder()
				.user(user)
				.img("이미지11")
				.emotion(1)
				.content("내용11")
				.lat(129.11111)
				.lng(38.83334)
				.likeCnt(0)
				.build();
		Feed feed2 = Feed.builder()
				.user(user2)
				.img("이미지12")
				.emotion(2)
				.content("내용12")
				.lat(129.11111)
				.lng(38.83334)
				.likeCnt(0)
				.build();
		feedRepository.save(feed);
		feedRepository.save(feed2);
	}
	@Test
	void selectTest(){
//		List<FeedDto> list = feedService.getListAround(128.1, 37.8);
//		List<FeedDto> list = feedService.getMyFeedList(2);
		List<FeedDto> list = feedService.getListFollow(4);
		for (int i = 0; i < list.size(); i++) {
			System.out.println(list.get(i));
		}

	}
	@Test
	void likeHit(){
		System.out.println(feedService.hitLikePoint(3));
		System.out.println(feedService.hitLikePoint(2));
		System.out.println(feedService.hitLikePoint(3));
		feedRepository.updateLike(3);
	}
	@Test
	void Modify(){
		FeedDto fd = FeedDto.builder()
				.feedId(5)
				.content("전현태 수정")
				.emotion(1)
				.img("이미지 저장소")
				.lat(218)
				.lng(18)
				.build();
		feedService.modifyFeed(fd);
	}
	@Test
	void Delete(){
		feedService.deleteFeed(1);
	}
}


