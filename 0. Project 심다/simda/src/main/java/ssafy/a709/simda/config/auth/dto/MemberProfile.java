package ssafy.a709.simda.config.auth.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MemberProfile {
    private String name;
    private String email;
    private String provider;
    private String nickname;

    public Member toMember() {
        return Member.builder()
                     .name(name)
                     .email(email)
                     .provider(provider)
                     .build();
    }

}