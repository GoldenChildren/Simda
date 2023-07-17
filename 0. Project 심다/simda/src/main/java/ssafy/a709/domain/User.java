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
    @Column(columnDefinition = "int")
    private int userId;

    // Social Token
    @Column(columnDefinition = "varchar(200)", unique=true)
    @NotNull
    private String socialToken;

    // Social Type
    @Column(columnDefinition = "varchar(50)")
    @NotNull
    private String socialType;

    // Nickname
    @Column(columnDefinition = "varchar(50)", unique=true)
    @NotNull
    private String nickname;

    // Profile Img Address
    @Column(columnDefinition = "varchar(100)")
    private String profileImg;

    // userRole
    @Column
    @Enumerated(EnumType.ORDINAL)
    @NotNull
    @ColumnDefault("2")
    private UserRole userRole;
}
