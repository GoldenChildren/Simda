package ssafy.a709.simda.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ObjectMetadata;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

//@Slf4j
@RequiredArgsConstructor    // final 멤버변수가 있으면 생성자 항목에 포함
//@Component
@Service
public class FileServiceImpl implements FileService{

    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    @Override
    public String uploadProfile(MultipartFile multipartFile) throws IOException {
        String dir = "img/profile";

        return uploadFile(multipartFile, dir);
    }

    @Override
    public String uploadFeed(MultipartFile multipartFile) throws IOException {
        String dir = "img/feed";

        return uploadFile(multipartFile, dir);
    }

    // S3에 업로드하는 메소드
    @Override
    public String uploadFile(MultipartFile multipartFile, String dir) throws IOException{
        // 파일명 UUID 로 설정
        String s3FileName = UUID.randomUUID() + "-" + multipartFile.getOriginalFilename();

//        String dir = "/img/profile";
        String bucketDir = bucket + dir;

        ObjectMetadata objMeta = new ObjectMetadata();

        objMeta.setContentLength(multipartFile.getInputStream().available());

//        multipartFile.getInputStream().close();

        amazonS3.putObject(bucketDir, s3FileName, multipartFile.getInputStream(), objMeta);

        multipartFile.getInputStream().close();

        return amazonS3.getUrl(bucketDir, s3FileName).toString();
    }

    @Override
    public String deleteFile() {
        return null;
    }
}
