package ssafy.a709.simda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import ssafy.a709.simda.domain.Feed;

import java.util.List;

public interface FeedRepository extends JpaRepository<Feed, Integer> {
    @Query("select f from Feed f where ((f.lat - :lat) * (f.lat - :lat) + (f.lng - :lng) * (f.lng - :lng)) between -1 and 1")
    List<Feed> getListAround(@Param("lat") double lat, @Param("lng") double lng);

    @Query("select distinct f from Feed f join Follow w on f.user.userId = w.toUserId.userId join User u on w.fromUserId.userId = w.fromUserId.userId where w.fromUserId.userId = :userId")
    List<Feed> getListByMyId(@Param("userId")int userId);
    List<Feed> findAllByUser_UserId(int userId);


    @Transactional
    @Modifying
    @Query("update Feed f set f.likeCnt = (f.likeCnt + 1) where f.feedId = :feedId")
    int updateLike(@Param("feedId") int feedId);

}
