package ssafy.a709.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ssafy.a709.domain.Follow;
import ssafy.a709.dto.UserDto;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class FollowDto {

    // FollowId
    private int followId;
    // Many(From User Id) to One(User Id)
    private UserDto fromUser;
    // Many(To User Id) to One(User Id)
    private UserDto toUser;

    // Follow(Entity)를 FollowDto로 변환
    public static FollowDto changeToFollowDto(Follow follow) {
        return FollowDto.builder()
                .followId(follow.getFollowId())
                .fromUser(UserDto.changeToUserDto(follow.getFromUser()))
                .toUser(UserDto.changeToUserDto(follow.getToUser()))
                .build();
    }

}
