package ssafy.a709.simda.controller;

import com.pkslow.ai.AIClient;
import com.pkslow.ai.GoogleBardClient;
import com.pkslow.ai.domain.Answer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ssafy.a709.simda.dto.FeedDto;
import ssafy.a709.simda.service.ApiService;
import ssafy.a709.simda.service.FeedService;
import ssafy.a709.simda.service.FileService;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

@RestController("/api")
public class ApiController {

    @Autowired
    private FeedService feedService;

    @Autowired
    private FileService fileService;

    @Autowired
    private ApiService apiService;


    @PostMapping(path ="/bard", consumes = "multipart/form-data")
    public ResponseEntity<FeedDto> sendContent(@RequestPart(value = "imgfile", required = false) MultipartFile imgfile,
                                         @ModelAttribute FeedDto feedDto) throws IOException {
        System.out.println("ApiController - BardApi 호출");
        // 게시글의 Content를 받아서 Ptyhon의 Bard API로 정보를 전달한다

        int emotion = 0; // 감정 기본 값은 0으로 고정

        // 이미지 파일 저장
        try{
            // 경로 저장
            String img = fileService.uploadFeed(imgfile);
            feedDto.setImg(img);
        }catch(IOException e){
            System.out.println("피드 바드 분석 시 이미지 저장 실패");
            System.out.println(e);
        }

        try {
            // 경로
            String caption = apiService.imageCaptioningApi(feedDto.getImg());
            emotion = apiService.bardApi(caption, feedDto.getTitle(), feedDto.getContent());
        } catch (Exception e) {
            System.out.println("Bard API 전송 오류");
            feedDto.setEmotion(-1);
            // 전송 오류면 -1 값 반환
            return new ResponseEntity<FeedDto>(feedDto, HttpStatus.NOT_ACCEPTABLE);
        }
        feedDto.setEmotion(emotion);
        // 전송 성공이면 0 ~ 4 값 반환
        return new ResponseEntity<FeedDto>(feedDto, HttpStatus.OK);

    }

}
