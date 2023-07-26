package ssafy.a709.simda.domain;

import lombok.*;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;
import ssafy.a709.simda.dto.UserDto;

import javax.persistence.*;

@DynamicInsert
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class User {

    // User Id
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id" , nullable = false)
    private int userId;

    // Social Token
//    @Column(name = "social_token", nullable = false, unique=true, columnDefinition = "varchar(200)")
//    private String socialToken;

    // Social Type
//    @Column(name = "social_type", nullable = false, columnDefinition = "varchar(50)")
//    private String socialType;
    @Column(name = "email", nullable = false, columnDefinition = "varchar(50)")
    private String email;

    // Nickname
    @Column(name = "nickname", nullable = false, unique=true, columnDefinition = "varchar(50)")
    private String nickname;

    // Profile Image Address
    @Column(name = "profile_img", columnDefinition = "varchar(100)")
    private String profileImg;

    // userRole
    @Builder.Default
    @Column(name ="user_role", nullable = false, columnDefinition = "int default 1")
    private int userRole = 1;

    // UserDto를 User(Entity)로 변환
    public static User changeToUser(UserDto userDto) {
        return User.builder()
                .userId(userDto.getUserId())
//                .socialToken(userDto.getSocialToken())
//                .socialType(userDto.getSocialType())
                .email(userDto.getEmail())
                .nickname(userDto.getNickname())
                .profileImg(userDto.getProfileImg())
//                .userRole(userDto.getUserRole())
                .build();
    }
}
