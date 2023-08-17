package ssafy.a709.simda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ssafy.a709.simda.domain.Chatroom;

import java.util.List;

@Repository
public interface ChatRoomRepository extends JpaRepository<Chatroom, Integer> {
    @Query("select c from Chatroom c where c.user1.userId= :userId1 or c.user2.userId = :userId2")
    List<Chatroom> findAllByUser1IdOrUser2Id(@Param("userId1")int userId1, @Param("userId2")int userId2);

}
