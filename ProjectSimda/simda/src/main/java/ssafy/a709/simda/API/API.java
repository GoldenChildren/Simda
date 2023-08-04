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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.net.URI;

public class API {
    public static int bardApi(String content){
        System.out.println("ApiController - BardApi 호출");
        // 게시글의 Content를 받아서 Ptyhon의 Bard API로 정보를 전달한다
        int emotion = 0; // 감정 기본 값은 0으로 고정
        try {
        // test 1 - 절대 경로 실행
//            ProcessBuilder pb = new ProcessBuilder("C:\\Users\\SSAFY\\AppData\\Local\\Programs\\Python\\Python311\\python",
//                    "C:\\Users\\SSAFY\\Desktop\\Project\\S09P12A709\\ProjectSimda\\simda\\src\\main\\java\\ssafy\\a709\\simda\\api\\bard.py",
//                    content);
//
        // test 2 - 경로찾기로 실행
//            ProcessBuilder pb = new ProcessBuilder("C:\\Users\\SSAFY\\AppData\\Local\\Programs\\Python\\Python311\\python",
//                    System.getProperty("user.dir")+"\\src\\main\\java\\ssafy\\a709\\simda\\api\\bard.py",
//                    content);
//            System.out.println(System.getProperty("user.dir"));
//
//            // test 3 - 돚거에서 실행
//            ProcessBuilder pb = new ProcessBuilder("/usr/bin/python3.9",
//                    System.getProperty("user.dir")+"\\src\\main\\java\\ssafy\\a709\\simda\\api\\bard.py",
//                    content);
//            System.out.println(System.getProperty("user.dir")+"/api/bard.py");
//
//            Process p = pb.start();
//            BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream(), "UTF-8"));
//
//            // 출력 값을 확인해 보는 코드
//            String line = " ";
//            String output = "";
//            while (line != null) {
//                output += line;
//                line = br.readLine();
//                output += "\n";
//            }
            AIClient client = new GoogleBardClient("Ygj5yW4U7eHBq5WAD5CPYQlzJ-Bi0nrNSdAkri99eP1VIqXc4gzGainsORoV0sgLpsolPw.");
            Answer answer = client.ask(content+"(이)라는 문장은 다음 보기 중 어디에 가장 가까워? 0 : 행복, 1 : 기쁨, 2 : 평온, 3 : 화남, 4 : 슬픔. 대답은 다음과 같은 형식으로만 대답해. ex) 답 : 1");
            String output = answer.getChosenAnswer();
            System.out.println(output);

            // 0 : 행복, 1 : 기쁨, 2 : 평온, 3 : 화남, 4 : 슬픔
            if (output.contains("0")) {
                System.out.println("hello, 0 행복");
            } else if (output.contains("1")) {
                emotion = 1;
                System.out.println("hello, 1 기쁨");
            } else if (output.contains("2")) {
                emotion = 2;
                System.out.println("hello, 2 평온");
            } else if (output.contains("3")) {
                emotion = 3;
                System.out.println("hello, 3 화남");
            } else if (output.contains("4")) {
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
