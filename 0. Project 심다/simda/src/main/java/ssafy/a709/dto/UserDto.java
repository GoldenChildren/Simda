package ssafy.a709.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ssafy.a709.domain.User;
import ssafy.a709.domain.UserRole;

import javax.persistence.*;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class UserDto {
    private int userId;

    // Social Token
    private String socialToken;

    // Social Type
    private String socialType;

    // Nickname
    private String nickname;

    // Profile Image Address
    private String profileImg;

    // userRole
    private UserRole userRole;

    // User(Entity)를 UserDto로 변환
    public static UserDto changeToUserDto(User user) {
        return UserDto.builder()
                .userId(user.getUserId())
                .socialToken(user.getSocialToken())
                .socialType(user.getSocialType())
                .nickname(user.getNickname())
                .profileImg(user.getProfileImg())
                .userRole(user.getUserRole())
                .build();
    }

}
