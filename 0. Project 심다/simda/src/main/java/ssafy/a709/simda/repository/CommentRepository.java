package ssafy.a709.simda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssafy.a709.simda.domain.Comment;

public interface CommentRepository extends JpaRepository<Comment, Integer> {
}
