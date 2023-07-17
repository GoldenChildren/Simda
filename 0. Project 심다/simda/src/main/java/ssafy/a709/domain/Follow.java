package ssafy.a709.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Entity
public class Follow {

    @Id @GeneratedValue
    @Column
    private int followId;

    @Column
    private int fromUserId;

    @Column
    private int toUserId;
}
