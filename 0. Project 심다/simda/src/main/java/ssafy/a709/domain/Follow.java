package ssafy.a709.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ssafy.a709.dto.FollowDto;

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
    @ManyToOne
    @JoinColumn(name = "from_user_id", referencedColumnName = "user_id")
    private User fromUser;

    // Many(To UserId) to One(UserId)
    @ManyToOne
    @JoinColumn(name = "to_user_id", referencedColumnName = "user_id")
    private User toUser;

    public static Follow changeToFollow(FollowDto followDto) {
        return Follow.builder()
                .followId(followDto.getFollowId())
                .fromUser(User.changeToUser(followDto.getFromUser()))
                .toUser(User.changeToUser(followDto.getToUser()))
                .build();
    }

}
