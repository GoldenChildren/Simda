package ssafy.a709.simda.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ssafy.a709.simda.domain.User;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class UserDto {
    private int userId;

    // private String socialToken;

    // Social Type -> 이메일로 변경
    // private String socialType;
    private String email;

    private String nickname;

    private String profileImg;

    private int userRole;

    // User(Entity)를 UserDto로 변환
    public static UserDto changeToUserDto(User user) {
        return UserDto.builder()
                .userId(user.getUserId())
                // .socialToken(user.getSocialToken())
                // .socialType(user.getSocialType())
                .email(user.getEmail())
                .nickname(user.getNickname())
                .profileImg(user.getProfileImg())
                // .userRole(user.getUserRole())
                .build();
    }


}
