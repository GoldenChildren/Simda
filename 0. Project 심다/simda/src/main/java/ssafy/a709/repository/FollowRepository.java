package ssafy.a709.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ssafy.a709.domain.Follow;

@Repository
public interface FollowRepository extends JpaRepository<Follow, Integer> {
}
