package ssafy.a709.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ssafy.a709.domain.User;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    // 전체 유저를 가져오기
    @Override
    List<User> findAll();

    // 검색 닉네임이 포함된 유저들을 모두 가져오기
    List<User> findByNicknameLike(String nickname);

    // 닉네임으로 단 한명의 유저를 가져오기
    User findByNickname(String nickname);

}
