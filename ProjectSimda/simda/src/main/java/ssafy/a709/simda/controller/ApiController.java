package ssafy.a709.simda.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.io.BufferedReader;
import java.io.InputStreamReader;

@RestController("/api")
public class ApiController {

    @PostMapping("/bard")
    public ResponseEntity<?> sendContent(@RequestBody String content) {
        System.out.println("ApiController - BardApi 호출");
        // 게시글의 Content를 받아서 Ptyhon의 Bard API로 정보를 전달한다

        int emotion = 0; // 감정 기본 값은 0으로 고정

        try {
            // test 1 - 절대 경로 실행
//            ProcessBuilder pb = new ProcessBuilder("C:\\Users\\SSAFY\\AppData\\Local\\Programs\\Python\\Python311\\python",
//                    "C:\\Users\\SSAFY\\Desktop\\Project\\S09P12A709\\ProjectSimda\\simda\\src\\main\\java\\ssafy\\a709\\simda\\api\\bard.py",
//                    content);

            // test 2 - 경로찾기로 실행
//            ProcessBuilder pb = new ProcessBuilder("C:\\Users\\SSAFY\\AppData\\Local\\Programs\\Python\\Python311\\python",
//                    System.getProperty("user.dir")+"\\src\\main\\java\\ssafy\\a709\\simda\\api\\bard.py",
//                    content);
//            System.out.println(System.getProperty("user.dir"));

            // test 3 - 돚거에서 실행
            ProcessBuilder pb = new ProcessBuilder("/usr/bin/python3.9",
                    System.getProperty("user.dir")+"\\src\\main\\java\\ssafy\\a709\\simda\\api\\bard.py",
                    content);
            System.out.println(System.getProperty("user.dir")+"\\api\\bard.py");

            Process p = pb.start();
            BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream(), "UTF-8"));

            // 출력 값을 확인해 보는 코드
            String line = " ";
            String output = "";
            while (line != null) {
                output += line;
                line = br.readLine();
                output += "\n";
            }
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
            return new ResponseEntity<Integer>(-1, HttpStatus.NOT_ACCEPTABLE);
        }
        // 전송 성공이면 0 ~ 4 값 반환
        return new ResponseEntity<Integer>(emotion, HttpStatus.OK);

    }

}
