package ssafy.a709.simda.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import ssafy.a709.simda.domain.User;

@Builder
@NoArgsConstructor
@Data
public class UserDto {
    private int userId;

    // private String socialToken;

    // Social Type -> 이메일로 변경
    // private String socialType;
    private String email;

    private String nickname;

    private String profileImg;

    private int userRole;

    private String bio;

    public UserDto(int userId, String email, String nickname, String profileImg, int userRole, String bio) {
        this.userId = userId;
        this.email = email;

        if(userRole == 2) {
            this.nickname = "탈퇴한 사용자";
        } else {
            this.nickname = nickname;
        }

        this.profileImg = profileImg;

        this.userRole = userRole;

        this.bio = bio;
    }

    // User(Entity)를 UserDto로 변환
    public static UserDto changeToUserDto(User user) {
        if(user == null){
            return UserDto.builder()
                    .userId(-1)
                    .email("")
                    .nickname("탈퇴한 사용자")
                    .userRole(2)
                    .profileImg("https://simda.s3.ap-northeast-2.amazonaws.com/img/profile/noimg.jpg")
                    .build();
        }
        return UserDto.builder()
                .userId(user.getUserId())
                // .socialToken(user.getSocialToken())
                // .socialType(user.getSocialType())
                .email(user.getEmail())
                .nickname(user.getNickname())
                .profileImg(user.getProfileImg())
                 .userRole(user.getUserRole())
                .bio(user.getBio())
                .build();
    }


}
