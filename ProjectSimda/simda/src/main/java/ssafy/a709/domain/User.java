package ssafy.a709.domain;

import lombok.*;

import javax.persistence.*;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class User {

    @Id @GeneratedValue
    @Column
    private int userId;

    @Column
    private String socialToken;

    @Column
    private String socialType;

    @Column
    private String nickname;

    @Column
    private String profileImg;

    @Column
    @Enumerated(EnumType.ORDINAL)
    private UserRole useRole;
}
