package ssafy.a709.simda.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import ssafy.a709.simda.dto.TokenDto;

public interface ApiService {

    // Kakao AccessToken을 통해 email을 반환받는 함수
    String getEmailByAccessToken(TokenDto tokenDto) throws JsonProcessingException;

    //
    int bardApi(String caption, String title, String content);

    String imageCaptioningApi(String imageUrl);

}
