package ssafy.a709.simda.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import ssafy.a709.simda.dto.TokenDto;

@Service
public class ApiServiceImpl implements ApiService{

    // 카카오 서버에서 API를 요청한다.
    @Override
    public String getEmailByAccessToken(TokenDto tokenDto) throws JsonProcessingException {
        RestTemplate restTemplate = new RestTemplate();

        // REST 요청의 헤더에 들어갈 내용 저장
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        headers.setBearerAuth(tokenDto.getAccessToken());
        headers.add("Accept", "application/json");

        // parameter로 들어갈 내용 저장
        MultiValueMap<String, String> parameters = new LinkedMultiValueMap<>();
        // parameters.add("property_keys", "[kakao_account.email]");    // property_keys 로 받으면 깔끔한데 방법을 모르겠음

        // headers and parameters로 request entity 생성
        HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(parameters, headers);

        // API endpoint URL 설정
        String url = "https://kapi.kakao.com/v2/user/me";

        // 카카오 서버로 GET 요청 보내기
        ResponseEntity<String> responseEntity = restTemplate.exchange(url, HttpMethod.GET, requestEntity, String.class);

        // responseEntity 자체가 null 이면 return null
        if (responseEntity == null) return null;

        // TODO : responseEntity 의 응답이 success가 아닌 경우 예외 처리

        // json 파싱 후 email 얻기
        ObjectMapper mapper = new ObjectMapper();
        System.out.println(responseEntity);
        JsonNode newNode = mapper.readTree(responseEntity.getBody());
        ObjectNode node = ((ObjectNode) newNode).put("Authentication", "Successful");
        String email = node.get("kakao_account").get("email").toString().replaceAll("\"", "");
        System.out.println(email);

        return email;
    }
}
