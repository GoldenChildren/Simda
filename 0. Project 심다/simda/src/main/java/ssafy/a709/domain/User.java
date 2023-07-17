package ssafy.a709.domain;

import lombok.*;
import org.hibernate.annotations.ColumnDefault;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

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
    @Column(name = "social_token", nullable = false, unique=true, columnDefinition = "varchar(200)")
    private String socialToken;

    // Social Type
    @Column(name = "social_type", nullable = false, columnDefinition = "varchar(50)")
    private String socialType;

    // Nickname
    @Column(name = "nickname", nullable = false, unique=true, columnDefinition = "varchar(50)")
    private String nickname;

    // Profile Image Address
    @Column(name = "profile_img", nullable = false, columnDefinition = "varchar(100)")
    private String profileImg;

    // userRole
    @Enumerated(EnumType.ORDINAL)
    @Column(name ="user_role", columnDefinition = "EnumType 2")
    private UserRole userRole;
}
