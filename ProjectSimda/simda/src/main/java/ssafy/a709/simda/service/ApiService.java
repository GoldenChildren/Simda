package ssafy.a709.simda.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import ssafy.a709.simda.dto.TokenDto;

public interface ApiService {

    // AccessToken을 통해 email을 반환받는 함수
    String getEmailByAccessToken(TokenDto tokenDto) throws JsonProcessingException;

}
