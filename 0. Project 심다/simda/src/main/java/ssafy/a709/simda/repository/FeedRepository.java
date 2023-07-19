package ssafy.a709.simda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ssafy.a709.simda.domain.Feed;

import java.util.List;

public interface FeedRepository extends JpaRepository<Feed, Integer> {
//    @Query("select f.* from feed f where (f.lat - :lat) * (f.lat - :lat) + (f.lng - :lng) * (f.lng - :lng) between -1 and 1")
//    List<Feed> getListAround(@Param("lat") double lat, @Param("lng") double lng);
//    @Query("select f.* from feed f join user u on f.user_id = u.user_id join follow w on u.user_id = w.from_user_id where w.from_user_id = :userId")
//    List<Feed> getListByMyId(int userId);
//    List<Feed> findAllByUserId(int userId);
//
//    Feed findByFeedId(int feedId);
//
//    @Modifying
//    @Query("update feed f set f.like = f.like + 1 where f.feed_id = :feedId")
//    int updateLike(@Param("feedId") int feedId);

}
