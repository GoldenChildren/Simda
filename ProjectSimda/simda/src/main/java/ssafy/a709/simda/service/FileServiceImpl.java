package ssafy.a709.simda.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ObjectMetadata;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import ssafy.a709.simda.domain.User;
import ssafy.a709.simda.dto.UserDto;
import ssafy.a709.simda.repository.UserRepository;

import java.io.IOException;
import java.io.InputStream;
import java.util.UUID;

@Slf4j
@RequiredArgsConstructor    // final 멤버변수가 있으면 생성자 항목에 포함
//@Component
@Service
public class FileServiceImpl implements FileService{

    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    @Override
    public String uploadProfile(MultipartFile multipartFile) throws IOException {
        log.debug("uploadProfile 메서드 시작");
        String dir = "/img/profile";

        return uploadFile(multipartFile, dir);
    }

    @Override
    public String uploadFeed(MultipartFile multipartFile) throws IOException {
        log.debug("uploadFeed 메서드 시작");
        String dir = "/img/feed";

        return uploadFile(multipartFile, dir);
    }


    // S3에 업로드하는 메소드
    @Override
    public String uploadFile(MultipartFile multipartFile, String dir) throws IOException{
        log.debug("uploadFile 메서드 시작: dir = {}", dir);
        // 파일명 UUID 로 설정
        String s3FileName = UUID.randomUUID() + "-" + multipartFile.getOriginalFilename();

        String bucketDir = bucket + dir;

        ObjectMetadata objMeta = new ObjectMetadata();
        objMeta.setContentLength(multipartFile.getSize());
        objMeta.setContentType(multipartFile.getContentType());

        try(InputStream inputStream = multipartFile.getInputStream()){
            amazonS3.putObject(bucketDir, s3FileName, inputStream, objMeta);
        }catch (Exception e){
            log.error(e.getMessage(), e);
            return null;
        }

        return amazonS3.getUrl(bucketDir, s3FileName).toString();
    }

    // 프로필 이미지 수정
    public String updateProfile(MultipartFile multipartFile, String originPath) throws IOException{
        log.debug("updateProfile 메서드 시작");
        String dir = "/img/profile";

        return updateFile(multipartFile, dir, originPath);
    }

    // 피드 이미지 수정
    public String updateFeed(MultipartFile multipartFile, String originPath) throws IOException{
        log.debug("updateFeed 메서드 시작");
        String dir = "/img/feed";

        return updateFile(multipartFile, dir, originPath);
    }


    // S3에 올라간 파일을 수정하는 메소드
    @Override
    public String updateFile(MultipartFile multipartFile, String dir, String originPath) throws IOException{
        log.debug("updateFile 메서드 시작: dir = {}, originPath = {}", dir, originPath);
        // 파일명을 파싱
        String[] parse = originPath.split("/");
        String s3FileName = parse[parse.length-1];

        String bucketDir = bucket + dir;

        log.debug("bucket 경로 = {}", bucketDir);

        ObjectMetadata objMeta = new ObjectMetadata();
        objMeta.setContentLength(multipartFile.getSize());
        objMeta.setContentType(multipartFile.getContentType());

        try(InputStream inputStream = multipartFile.getInputStream()){
            amazonS3.putObject(bucketDir, s3FileName, inputStream, objMeta);
        }catch (Exception e){
            log.error(e.getMessage(), e);
            return null;
        }

        return originPath;
    }
    @Override
    public String deleteFile() {
        return null;
    }
}
