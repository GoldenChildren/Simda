package ssafy.a709.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssafy.a709.domain.Chat;
import ssafy.a709.domain.Chatroom;
import ssafy.a709.domain.User;

import java.util.Optional;

public interface ChatRepository extends JpaRepository<Chat, Integer> {
    //해당 채팅방에 해당되는 채팅을 전부 가져오기
    Optional<Chat> findAllByChatRoom(Chatroom chatroom);
}
