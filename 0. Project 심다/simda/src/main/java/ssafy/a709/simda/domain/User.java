package ssafy.a709.simda.domain;

import lombok.*;
import org.hibernate.annotations.ColumnDefault;
import ssafy.a709.simda.dto.UserDto;

import javax.persistence.*;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class User {

    // User Id
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private int userId;

    // Social Token
    @Column(name = "social_token",  unique=true, columnDefinition = "varchar(200)")
    private String socialToken;

    // Social Type
    @Column(name = "social_type",  columnDefinition = "varchar(50)")
    private String socialType;

    // Nickname
    @Column(name = "nickname",  unique=true, columnDefinition = "varchar(50)")
    private String nickname;

    // Profile Image Address
    @Column(name = "profile_img",  columnDefinition = "varchar(100)")
    private String profileImg;

    // userRole
    @Column(name ="user_role", columnDefinition = "Integer")
    private int userRole;

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
