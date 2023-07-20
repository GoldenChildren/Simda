package ssafy.a709.simda.controller;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class KakaoController {
        /* 소셜 로그인 기능 제작(JWT, oauth2 이용)
    카카오톡, 구글 소셜 로그인 기능
    OAuth2란? Open Authentication2의 약자로 인증 및 권한 획득을 위한 프로토콜
     */
    @GetMapping("/auth/kakao/callback")
    @ResponseBody
    public String kakaoCallback(String code) {

        // Http 요청을 편하게 해주는 라이브러리
        RestTemplate rt = new RestTemplate();

        // Header 생성
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-type", "application/x-www-form-unlencoded:charset=utf-8");

        // Body 생성
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", "N7NjPIM6q20N5jXkrgJM8jybInd7Xy1X");
        params.add("redirect_uri", "http://localhost:9090/auth/kakao/callback");
        params.add("code", code);

        // Header와 Body를 하나의 오브젝트로 담기
        HttpEntity<MultiValueMap<String, String>> kakaoTokenRequest =
                new HttpEntity<>(params, headers);

        // Http 요청 - Post 방식
        ResponseEntity<String> response = rt.exchange(
                "https://kauth.kakao.com/oauth/token", // 요청 주소
                HttpMethod.POST, // 요청 방식
                kakaoTokenRequest, // HttpBody와 헤더에 들어갈 것
                String.class // 응답 받을 방식
        );

        return "카카오 인증 완료" + response;

    }
}
