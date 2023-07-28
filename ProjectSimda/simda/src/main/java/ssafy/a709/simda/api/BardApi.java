package ssafy.a709.simda.api;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

public class BardApi {
    public static void main(String[] args) throws IOException {
        ProcessBuilder pb = new ProcessBuilder("C:\\Users\\SSAFY\\AppData\\Local\\Programs\\Python\\Python311\\python",
                "C:\\Users\\SSAFY\\Desktop\\Project\\S09P12A709\\ProjectSimda\\simda\\src\\main\\java\\ssafy\\a709\\simda\\api\\bard.py",
                "아이고");
        Process p = pb.start();
        BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream(), "utf-8"));

        String line = " ";
        String output = "";
        while(line != null) {
            output += line;
            line = br.readLine();
            output += "\n";
        }
        // 0 : 행복, 1 : 기쁨, 2 : 평온, 3 : 화남, 4 : 슬픔
        if(output.contains("0")) {
            System.out.println("hello, 0 행복");
        } else if(output.contains("1")) {
            System.out.println("hello, 1 기쁨");
        } else if(output.contains("2")) {
            System.out.println("hello, 2 평온");
        } else if(output.contains("3")) {
            System.out.println("hello, 3 화남");
        } else if(output.contains("4")) {
            System.out.println("hello, 4 슬픔");
        } else {
            System.out.println("변환 실패, 기본 값으로 설정");
        }
    }
}
