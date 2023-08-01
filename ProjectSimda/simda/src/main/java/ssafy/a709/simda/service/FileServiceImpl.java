package ssafy.a709.simda.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Service
public class FileServiceImpl implements FileService{

    @Value("${upload.img.dir}")
    private String imgPath;

    @Override
    public String createFile(MultipartFile profileImg) {
        try {
            // profile img 를 경로에 저장해준다.
            if (!profileImg.isEmpty()) {
//            System.out.println(imgPath);
                // 저장할 디렉토리 생성
                String uploadDir = "/img/profile/";

                // 업로드 디렉토리가 없으면 생성
                File directory = new File(imgPath + uploadDir);

                if (!directory.exists()) {
                    directory.mkdirs();
                }

                // 파일명 설정 (예시: 프로필 이미지 파일명에 유저 아이디 또는 랜덤한 값을 사용하는 것이 일반적)
                String fileName = UUID.randomUUID() + "_" + profileImg.getOriginalFilename();

                // 파일을 업로드 디렉토리로 저장
                File destFile = new File(directory, fileName);
                profileImg.transferTo(destFile);

                return uploadDir + fileName;
            }
        }catch (IOException e){
            System.out.println(e);
            return null;
        }
        return null;
    }

    @Override
    public String deleteFile() {
        return null;
    }
}
