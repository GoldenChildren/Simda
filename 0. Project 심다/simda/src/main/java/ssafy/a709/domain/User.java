package ssafy.a709.domain;

import lombok.*;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

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
    private UserRole useRole;
}
