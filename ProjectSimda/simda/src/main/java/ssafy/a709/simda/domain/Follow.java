package ssafy.a709.simda.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ssafy.a709.simda.dto.FollowDto;

import javax.persistence.*;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Data
@Entity
@Table
public class Follow {

    // Follow Id
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "follow_id")
    private int followId;

    // Many(From User Id) to One(User Id)
    @ManyToOne
    @JoinColumn(name = "from_user_id", referencedColumnName = "user_id")
    private User fromUserId;

    // Many(To User Id) to One(User Id)
    @ManyToOne
    @JoinColumn(name = "to_user_id", referencedColumnName = "user_id")
    private User toUserId;

    // FollowDto를 Follow(Entity)로 변환
    public static Follow changeToFollow(FollowDto followDto) {
        return Follow.builder()
                .followId(followDto.getFollowId())
                .fromUserId(User.changeToUser(followDto.getFromUserId()))
                .toUserId(User.changeToUser(followDto.getToUserId()))
                .build();
    }

}
