package ssafy.a709.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.Id;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class Comment {
    @Id
    private int cmtId;

    private int userId;
    private int feedId;
    private int pCmtId;
    private String content;
}
