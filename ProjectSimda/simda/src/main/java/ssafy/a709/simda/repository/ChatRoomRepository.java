package ssafy.a709.simda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ssafy.a709.simda.domain.Chatroom;

import java.util.List;

@Repository
public interface ChatRoomRepository extends JpaRepository<Chatroom, Integer> {
    List<Chatroom> findByUser1IdOrUser2Id(int userId1, int userId2);

}
