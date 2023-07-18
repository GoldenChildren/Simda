package ssafy.a709.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssafy.a709.domain.Chatroom;
import ssafy.a709.domain.User;

import java.util.Optional;

public interface ChatRoomRepository extends JpaRepository<Chatroom, Integer> {
    Optional<Chatroom> findByUser1IdOrUser2Id(int userId1, int userId2);

}
