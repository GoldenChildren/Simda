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
public class Follow {

    // FollowId
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "follow_id")
    private int followId;

    // Many(From UserId) to One(UserId)
    @ManyToOne(fetch = FetchType.LAZY) // 지연로딩이 더 효율적(관련 정보도 다 가져오려 하기 때문에)
    @JoinColumn(name = "from_user_id", referencedColumnName = "user_id")
    private User fromUserId;

    // Many(To UserId) to One(UserId)
    @ManyToOne(fetch = FetchType.LAZY) // 지연로딩이 더 효율적(관련 정보도 다 가져오려 하기 때문에)
    @JoinColumn(name = "to_user_id", referencedColumnName = "user_id")
    private User toUserId;

    public static Follow changeToFollow(FollowDto followDto) {
        return Follow.builder()
                .followId(followDto.getFollowId())
                .fromUserId(User.changeToUser(followDto.getFromUser()))
                .toUserId(User.changeToUser(followDto.getToUser()))
                .build();
    }

}
