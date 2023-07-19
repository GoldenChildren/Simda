package ssafy.a709.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ssafy.a709.domain.Follow;
import ssafy.a709.domain.User;

import java.util.List;

@Repository
public interface FollowRepository extends JpaRepository<Follow, Integer> {

    // FROM 나 TO 상대방
    // TO : 팔로'우' 하는 사람
    // FROM : 팔로'잉' 하는 사람

    // 나를 팔로우하는 유저들을 유저 엔티티 리스트 형태로 반환
    // ToUser에 내 닉네임이 있을 경우, 해당 User는 나를 팔로우 하는 사람이다.
    List<User> findByToUserId(int userId);

    // 내가 팔로우 하는 유저들을 유저 엔티티 리스트 형태로 반환
    // FromUser에 내 닉네임이 있는 경우 해당 toUser는 내가 팔로우 하는 사람이다.
    List<User> findByFromUserId(int userId);
    
    // FollowId를 찾아서 delete 하는 구문 실행
    void deleteByFollowId(int userId);



}
