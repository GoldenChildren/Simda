package ssafy.a709.simda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ssafy.a709.simda.domain.Chat;
import ssafy.a709.simda.domain.Chatroom;

import java.util.List;

@Repository
public interface ChatRepository extends JpaRepository<Chat, Integer> {
    //해당 채팅방에 해당되는 채팅을 전부 가져오기


    List<Chat> findByChatRoom(Chatroom chatRoom);
}
