package ssafy.a709.simda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ssafy.a709.simda.domain.Follow;
import ssafy.a709.simda.domain.User;

import java.util.List;

@Repository
public interface FollowRepository extends JpaRepository<Follow, Integer> {

    // FROM 나 TO 상대방
    // TO : 팔로'우' 하는 사람
    // FROM : 팔로'잉' 하는 사람

    // 나를 팔로우하는 유저들을 유저 엔티티 리스트 형태로 반환
    // ToUser에 내 닉네임이 있을 경우, 해당 User는 나를 팔로우 하는 사람이다.
    @Query("SELECT u FROM User u JOIN Follow f on f.fromUserId.userId = u.userId WHERE f.toUserId.userId = :toUserId")
    List<User> findByToUserId(@Param("toUserId") int toUserId);

    // 내가 팔로우 하는 유저들을 유저 엔티티 리스트 형태로 반환
    // FromUser에 내 닉네임이 있는 경우 해당 toUser는 내가 팔로우 하는 사람이다.
    @Query("SELECT u FROM User u JOIN Follow f on f.toUserId.userId = u.userId WHERE f.fromUserId.userId = :fromUserId")
    List<User> findByFromUserId(@Param("fromUserId")int userId);
    
    // FollowId를 찾아서 delete 하는 구문 실행
    void deleteById(int userId);

    @Query("SELECT COUNT(*) FROM Follow f WHERE f.fromUserId.userId = :fromUserId AND f.toUserId.userId = :toUserId")
    int findByToUserIdAndFromUserId(@Param("fromUserId")int fromUserId, @Param("toUserId")int toUserId);



}
