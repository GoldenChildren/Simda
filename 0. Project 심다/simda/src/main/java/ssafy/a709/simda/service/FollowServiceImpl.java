package ssafy.a709.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssafy.a709.dto.UserDto;
import ssafy.a709.repository.FollowRepository;

import java.util.List;

@Service
public class FollowServiceImpl implements FollowService{

    // FollowRepository 가져오기, Entity Type 가져오기
    @Autowired
    FollowRepository followRepository;

    // follow 신청하기
    @Override
    public boolean follow(UserDto userDto) {
        return false;
    }

    // follow 끊기
    @Override
    public boolean unfollow(UserDto userDto) {
        return false;
    }

    // '내가' Follow하는 사람들 검색
    @Override
    public List<UserDto> searchFollow() {
        return null;
    }

    // '나를' Follow하는 사람들 검색
    @Override
    public List<UserDto> searchFollower() {
        return null;
    }
}
