package ssafy.a709.simda.api;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

public class BardApi {
    public static void main(String[] args) throws IOException {
        ProcessBuilder pb = new ProcessBuilder("C:\\Users\\SSAFY\\AppData\\Local\\Programs\\Python\\Python311\\python",
                "C:\\Users\\SSAFY\\Desktop\\Project\\S09P12A709\\ProjectSimda\\simda\\src\\main\\java\\ssafy\\a709\\simda\\api\\bard.py", "아이고");
        Process p = pb.start();
        BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream(), "euc-kr"));

        String line = " ";
        String output = "";
        while(line != null) {
            output += line;
            line = br.readLine();
            output += "\n";
        }



        if(output.contains("4")) {
            System.out.println("hello, number 4");
        }
    }
}
