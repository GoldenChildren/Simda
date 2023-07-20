package ssafy.a709.simda;


import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import ssafy.a709.simda.domain.User;
import ssafy.a709.simda.domain.UserRole;
import ssafy.a709.simda.repository.CommentRepository;
import ssafy.a709.simda.repository.FeedRepository;
import ssafy.a709.simda.repository.UserRepository;


@SpringBootTest
class SimdaApplicationTests {
	@Autowired
	UserRepository userRepository;
	@Autowired
	FeedRepository feedRepository;
	@Autowired
	CommentRepository commentRepository;
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
}
