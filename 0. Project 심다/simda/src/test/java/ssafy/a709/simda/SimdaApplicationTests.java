package ssafy.a709.simda;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.context.SpringBootTest;
import ssafy.a709.simda.domain.User;
import ssafy.a709.simda.domain.UserRole;
import ssafy.a709.simda.repository.UserRepository;
import ssafy.a709.simda.service.UserService;

@SpringBootTest

class SimdaApplicationTests {
	@Autowired
	UserService userService;
	@Autowired
	UserRepository userRepository;
	@Test
	void contextLoads() {
		System.out.println(1);
		User user = User.builder()
						.nickname("123")
				.socialToken("12345")
				.socialType("kakao")
						.profileImg("1234")
				.userRole(UserRole.GENERAL)
						.build();
		System.out.println(2);
		userRepository.save(user);
		System.out.println(3);
		userService.checkNickname("1234");
		System.out.println(4);
	}

}
