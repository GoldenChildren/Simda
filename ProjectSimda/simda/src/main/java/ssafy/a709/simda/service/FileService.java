package ssafy.a709.simda.service;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface FileService {

    // 파일 저장 기능
    String createFile(MultipartFile profileImg) throws IOException;

    // 파일 삭제 기능
    String deleteFile();


}
