package ssafy.a709.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Entity
public class Follow {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(columnDefinition = "int")
    private int followId;

    // One(userId) to Many(fromUserId)
    @ManyToOne
    @JoinColumn(name = "user_id")
    @NotNull
    private User fromUserId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    @NotNull
    private User toUserId;
}
