package ssafy.a709.simda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import ssafy.a709.simda.domain.Feed;

import java.util.Date;
import java.util.List;

public interface FeedRepository extends JpaRepository<Feed, Integer> {
    @Query("SELECT f FROM Feed f WHERE ((f.lat - :lat) * (f.lat - :lat) + (f.lng - :lng) * (f.lng - :lng)) BETWEEN 0 AND 0.00001 AND f.regDate > :oneDayAgo")
    List<Feed> findFeedAroundAndWithinOneDay(@Param("lat") double lat, @Param("lng") double lng, @Param("oneDayAgo") Date oneDayAgo);

    @Query("select distinct f from Feed f join Follow w on f.user.userId = w.toUserId.userId join User u on w.fromUserId.userId = u.userId where w.fromUserId.userId = :userId")
    List<Feed> getListByMyId(@Param("userId")int userId);
    List<Feed> findAllByUser_UserId(int userId);


    @Transactional
    @Modifying
    @Query("update Feed f set f.likeCnt = (f.likeCnt + 1) where f.feedId = :feedId")
    int updateLike(@Param("feedId") int feedId);

}
