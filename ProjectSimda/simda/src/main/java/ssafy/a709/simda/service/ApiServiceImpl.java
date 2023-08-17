package ssafy.a709.simda.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.pkslow.ai.AIClient;
import com.pkslow.ai.GoogleBardClient;
import com.pkslow.ai.domain.Answer;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import ssafy.a709.simda.dto.TokenDto;

import java.net.URI;

@Slf4j
@Service
public class ApiServiceImpl implements ApiService{
    @Value("${google.bard}")
    private String bardToken;
    @Value("${caption.uri}")
    private String imageCaptionUri;
    @Value("${caption.key}")
    private String imageCaptionKey;

    // 카카오 서버에서 API를 요청한다.
    @Override
    public String getEmailByAccessToken(TokenDto tokenDto) throws JsonProcessingException {
        log.debug("getEmailByAccessToken 메서드 시작: tokenDto = {}", tokenDto);
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
        if (responseEntity == null) {
            log.warn("getEmailByAccessToken 메서드 경고: KAKAO 요청 결과가 null 입니다.");
            return null;
        }

        // TODO : responseEntity 의 응답이 success가 아닌 경우 예외 처리
        log.debug("getEmailByAccessToken 메서드 결과: response");

        // json 파싱 후 email 얻기
        ObjectMapper mapper = new ObjectMapper();
        JsonNode newNode = mapper.readTree(responseEntity.getBody());
        ObjectNode node = ((ObjectNode) newNode).put("Authentication", "Successful");
        String email = node.get("kakao_account").get("email").toString().replaceAll("\"", "");
        log.debug("getEmailByAccessToken 메서드 결과: email = {}", email);

        return email;
    }

    // 바드 API 호출
    @Override
    public int bardApi(String caption, String title, String content){
        log.debug("bardApi 메서드 시작: caption = {}, title = {}, content = {}", caption, title, content);
        // 게시글의 Content를 받아서 Ptyhon의 Bard API로 정보를 전달한다
        int emotion = 0; // 감정 기본 값은 0으로 고정
        try {
            caption = caption.replaceAll("(\r\n|\r|\n|\n\r)", " ");
            title = title.replaceAll("(\r\n|\r|\n|\n\r)", " ");
            content = content.replaceAll("(\r\n|\r|\n|\n\r)", " ");

            AIClient client = new GoogleBardClient(bardToken);

            String query = "다음 게시글의 전체 분위기를 형식에 맞춰서 대답해. 게시글은 이미지와 제목, 내용으로 이루어져 있어. 게시한 이미지는 영어로 설명할게. 이미지 설명 : \""
                    +caption+
                    "\" 게시글 제목 : \""
                    +title+
                    "\" 게시글 내용 : \""
                    +content+
                    "\" 위 게시글의 게시자의 감정은 다음 보기 중 어디에 가장 가까워? 0 : 행복, 1 : 기쁨, 2 : 평온, 3 : 화남, 4 : 슬픔. 대답은 꼭 다음과 같은 형식으로만 대답해야해. ex) 답 : 1";
            log.debug("bardApi 메서드 : query = {}", query);
            Answer answer = client.ask(query);
            String output = answer.getChosenAnswer();
            log.debug("bardApi 메서드 : output = {}", output);

            // 0 : 행복, 1 : 기쁨, 2 : 평온, 3 : 화남, 4 : 슬픔
            if (output.contains("0")) {
            } else if (output.contains("1")) {
                emotion = 1;
            } else if (output.contains("2")) {
                emotion = 2;
            } else if (output.contains("3")) {
                emotion = 3;
            } else if (output.contains("4")) {
                emotion = 4;
            } else {
                log.warn("bardApi 메서드 경고: 변환 실패, 기본 값으로 설정");
            }
        } catch (Exception e) {
            log.error("bardApi 메서드 오류: {}",e.getMessage());
            // 전송 오류면 -1 값 반환
            return -1;
        }
        log.debug("bardApi 메서드 결과: 감정 = {}", emotion);
        // 전송 성공이면 0 ~ 4 값 반환
        return emotion;
    }

    //image captioning API
    @Override
    public String imageCaptioningApi(String imageUrl){
        log.debug("imageCaptioningApi 메서드 시작: imageUrl = {}", imageUrl);
        HttpClient httpclient = HttpClients.createDefault();
        // 결과 문자열
        StringBuilder res = new StringBuilder();
        try
        {
            URIBuilder builder = new URIBuilder(imageCaptionUri);
            builder.setParameter("features", "denseCaptions");
            builder.setParameter("language", "en");
            URI uri = builder.build();
            HttpPost request = new HttpPost(uri);
            request.setHeader("Content-Type", "application/json");
            request.setHeader("Ocp-Apim-Subscription-Key", imageCaptionKey);
            // Request body - 이미지url을 json형태로 변환후 전송
            StringEntity reqEntity = new StringEntity("{\"url\" : \"" + imageUrl + "\"}");
            request.setEntity(reqEntity);
            HttpResponse response = httpclient.execute(request);
            org.apache.http.HttpEntity entity = response.getEntity();

            if (entity != null)
            {
                // API호출로 받은 데이터 entity -> string -> json 후 파싱
                String json = EntityUtils.toString(entity);
                ObjectMapper objectMapper = new ObjectMapper();
                JsonNode root = objectMapper.readTree(json);
                JsonNode denseCaptionsResult = root.get("denseCaptionsResult");
                JsonNode values = denseCaptionsResult.get("values");
                //필요한 값들만 따로 잘라서 res에 추가
                for (JsonNode value : values) {
                    String text = value.get("text").asText();
                    res.append(text).append("\n");
                }
            }
        }
        catch (Exception e)
        {
            log.error("imageCaptioningApi 메서드 오류: error = {}", e.getMessage());
            return null;
        }
        return res.toString();
    }
}
