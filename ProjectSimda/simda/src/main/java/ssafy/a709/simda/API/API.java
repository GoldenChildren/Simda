package ssafy.a709.simda.API;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.pkslow.ai.AIClient;
import com.pkslow.ai.GoogleBardClient;
import com.pkslow.ai.domain.Answer;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import java.net.URI;

public class API {
    public static int bardApi(String content){
        System.out.println("ApiController - BardApi 호출");
        // 게시글의 Content를 받아서 Ptyhon의 Bard API로 정보를 전달한다
        int emotion = 0; // 감정 기본 값은 0으로 고정
        try {
            System.out.println(content);
            content = content.replaceAll("(\r\n|\r|\n|\n\r)", " ");
            AIClient client = new GoogleBardClient("Ygj5yW4U7eHBq5WAD5CPYQlzJ-Bi0nrNSdAkri99eP1VIqXc4gzGainsORoV0sgLpsolPw.");
            Answer answer = client.ask("다음 사진이 있는 게시글의 전체 분위기를 형식에 맞춰서 반환해. \""+content+"\"이야. 다음 보기 중 어떤 감정에 가장가까워? 0 : 행복, 1 : 기쁨, 2 : 평온, 3 : 화남, 4 : 슬픔. 다음의 형식을 반드시 지켜서 대답해. ex) 답 : 1");
            String output = answer.getChosenAnswer();
            System.out.println(output);

            // 0 : 행복, 1 : 기쁨, 2 : 평온, 3 : 화남, 4 : 슬픔

            if (output.contains("0") || output.contains("행복")) {
                System.out.println("hello, 0 행복");
            } else if (output.contains("1") || output.contains("기쁨")) {
                emotion = 1;
                System.out.println("hello, 1 기쁨");
            } else if (output.contains("2") || output.contains("평온")) {
                emotion = 2;
                System.out.println("hello, 2 평온");
            } else if (output.contains("3")|| output.contains("화남")) {
                emotion = 3;
                System.out.println("hello, 3 화남");
            } else if (output.contains("4")|| output.contains("슬픔")) {
                emotion = 4;
                System.out.println("hello, 4 슬픔");
            } else {
                System.out.println("변환 실패, 기본 값으로 설정");
            }
        } catch (Exception e) {
            System.out.println("Bard API 전송 오류");
            // 전송 오류면 -1 값 반환
            return -1;
        }
        // 전송 성공이면 0 ~ 4 값 반환
        return emotion;
    }

    //image captioning
    public static String imageCaptioningApi(String imageUrl){
        HttpClient httpclient = HttpClients.createDefault();
        // 결과 문자열
        StringBuilder res = new StringBuilder();
        try
        {
            URIBuilder builder = new URIBuilder("https://jeonhyeontae.cognitiveservices.azure.com/computervision/imageanalysis:analyze?api-version=2023-04-01-preview");
            builder.setParameter("features", "denseCaptions");
            builder.setParameter("language", "en");
            URI uri = builder.build();
            HttpPost request = new HttpPost(uri);
            request.setHeader("Content-Type", "application/json");
            request.setHeader("Ocp-Apim-Subscription-Key", "7605c7b097ad4a2aa24d401bc43b8812");
            // Request body - 이미지url을 json형태로 변환후 전송
            StringEntity reqEntity = new StringEntity("{\"url\" : \"" + imageUrl + "\"}");
            request.setEntity(reqEntity);
            HttpResponse response = httpclient.execute(request);
            HttpEntity entity = response.getEntity();

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
            System.out.println(e.getMessage());
            return null;
        }
        return res.toString();
    }
}
