package ssafy.a709.simda.domain;

import lombok.*;
import ssafy.a709.simda.dto.UserDto;

import javax.persistence.*;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Table
public class User {

    // User Id
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private int userId;

    // Social Token
    @Column(name = "social_token", nullable = false, unique = true, length = 200)
    private String socialToken;

    // Social Type
    @Column(name = "social_type", nullable = false, length = 50)
    private String socialType;

    // Nickname
    @Column(name = "nickname", nullable = false, unique = true, length = 50)
    private String nickname;

    // Profile Image Address
    @Column(name = "profile_img", nullable = false,  length = 100)
    private String profileImg;

    // userRole
    @Enumerated(EnumType.STRING)
    @Column(name ="user_role", length = 2)
    private UserRole userRole;

    // UserDto를 User(Entity)로 변환
    public static User changeToUser(UserDto userDto) {
        return User.builder()
                .userId(userDto.getUserId())
                .socialToken(userDto.getSocialToken())
                .socialType(userDto.getSocialType())
                .nickname(userDto.getNickname())
                .profileImg(userDto.getProfileImg())
                .userRole(userDto.getUserRole())
                .build();
    }


}
