package ssafy.a709.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ssafy.a709.domain.Feed;
import ssafy.a709.dto.FeedDto;

import java.util.List;

public interface FeedRepository extends JpaRepository<Feed, Integer> {
    @Query("select f.* from feed f where (f.lat - :lat) * (f.lat - :lat) + (f.lng - :lng) * (f.lng - :lng) between -1 and 1")
    List<Feed> getListAround(double lat, double lng);
    @Query("select f.* from feed f join user u on f.user_id = u.user_id join follow w on u.user_id = w.from_user_id where w.from_user_id = :userId")
    List<Feed> getListByMyId(int userId);
    List<Feed> findAllByUserId(int userId);

    Feed findByFeedId(int feedId);
}
