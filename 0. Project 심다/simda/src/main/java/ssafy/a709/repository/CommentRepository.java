package ssafy.a709.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssafy.a709.domain.Comment;
import ssafy.a709.domain.Feed;

public interface CommentRepository extends JpaRepository<Comment, Integer> {
}
