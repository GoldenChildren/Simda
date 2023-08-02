package ssafy.a709.simda.service;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface FileService {

    // 프로필 이미지 저장
    String uploadProfile(MultipartFile multipartFile) throws IOException;

    // 피드 이미지 저장
    String uploadFeed(MultipartFile multipartFile) throws IOException;

    // 파일 저장 기능
    String uploadFile(MultipartFile multipartFile, String dir) throws IOException;

    // 파일 삭제 기능
    String deleteFile();


}
