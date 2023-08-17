package ssafy.a709.simda.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssafy.a709.simda.domain.Follow;
import ssafy.a709.simda.domain.User;
import ssafy.a709.simda.dto.FollowDto;
import ssafy.a709.simda.dto.UserDto;
import ssafy.a709.simda.repository.FollowRepository;

import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
public class FollowServiceImpl implements FollowService{

    // FollowRepository 가져오기, Entity Type 가져오기
    @Autowired
    FollowRepository followRepository;

    // follow 신청하기
    @Override
    public boolean createFollow(FollowDto followDto) {
        log.debug("createFollow 메서드 시작: followDto = {}", followDto);
        try {
            // Dto Type의 객체를 Entity화 해주기
            Follow follow = Follow.changeToFollow(followDto);
            // followDto를 받아오면, 두 개의 id를 entity화 하여 저장해주기
            followRepository.save(follow);
        } catch (Exception e) {
            log.error(e.getMessage(), e);
            return false;
        }
        return true;
    }

    // follow 끊기
    @Override
    @Transactional
    public boolean deleteFollow(int fromUserId, int toUserId) {
        // 받아온 FollowDto에서 int형의 follow Id를 가져와서
        // Repo로 보내서 id가 일치하는 녀석을 Delete 해준다
        log.debug("deleteFollow 메서드 시작: fromUserId = {} , toUserId = {}", fromUserId, toUserId);
        try {
            // followId를 통해 entity 삭제
            followRepository.deleteFollowByFromUserIdAndToUserId(fromUserId, toUserId);
        } catch(Exception e) {
            log.error(e.getMessage(), e);
            return false;
        }
        return true;
    }

    // '내가' Follow하는 사람들 검색
    @Override
    public List<UserDto> selectFollowList(int userId) {
        // 받아온 int형의 userId를 통해서 fromUserId와 비교해서
        // 일치하는 사람들의 객체 Entity를 가져온다
        // UserDto의 List형태로 변환하여 반환한다
        log.debug("selectFollowList 메서드 시작: userId = {}", userId);
        List<UserDto> userDtoList = new ArrayList<>();

        try {
            // User Type Entity에서 userId와 FromUserId를 통해 User List 가져오기
            List<User> userList = followRepository.findByFromUserId(userId);

            // Entity를 Dto Type으로 변환
            for(User u : userList) {
                userDtoList.add(UserDto.changeToUserDto(u));
            }
        } catch(Exception e) {
            log.error(e.getMessage(), e);
        }

        return userDtoList;
    }

    // '나를' Follow하는 사람들 검색
    @Override
    public List<UserDto> selectFollowerList(int userId) {
        // 받아온 int형의 id를 통해서 toUserId와 비교
        // 일치하는 사람들의 Entity를 가져온다
        // UserDto의 List 형태로 변환하여 반환한다
        log.debug("selectFollowerList 메서드 시작: userId = {}", userId);
        List<UserDto> userDtoList = new ArrayList<>();
        
        try {
            // User Type Entity에서 userId와 toUserId를 통해서 User List 가져오기
            List<User> userList = followRepository.findByToUserId(userId);
            log.debug("user 수 = {}", userList.size());
            // Entity를 Dto Type으로 변환
            for(User u : userList) {
                userDtoList.add(UserDto.changeToUserDto(u));
            }
        } catch(Exception e) {
            log.error(e.getMessage(), e);
        }

        return userDtoList;
    }

    @Override
    public boolean selectUser(int fromUserId, int toUserId) {
        log.debug("selectUser 메서드 시작: fromUserId = {}, toUserId = {}", fromUserId, toUserId);
        boolean check = false;
        try {
            // toUser,fromUser id를 통해서 값을 가져와야한다
            if(followRepository.findByToUserIdAndFromUserId(fromUserId, toUserId) != 0) {
                check = true;
            }
        } catch(Exception e) {
            log.error(e.getMessage(), e);
        }

        return check;
    }

    @Override
    public boolean deleteUserFollow(int userId) {
        log.debug("deleteUserFollow 메서드 시작: userId = {}", userId);
        try{
            followRepository.deleteFollowByFromUserId(userId);
            followRepository.deleteFollowByToUserId(userId);
            return true;
        }catch (Exception e){
            log.error(e.getMessage(), e);
        }
        return false;
    }
}
