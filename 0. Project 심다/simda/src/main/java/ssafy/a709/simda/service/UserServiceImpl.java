package ssafy.a709.simda.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssafy.a709.simda.dto.UserDto;
import ssafy.a709.simda.repository.FollowRepository;
import ssafy.a709.simda.repository.UserRepository;

import java.util.List;

@Service
public class UserServiceImpl implements UserService{

    @Autowired
    UserRepository userRepository;

    @Autowired
    FollowRepository followRepository;

    @Override
    public List<UserDto> searchAllUser() {
        return null;
    }

    @Override
    public List<UserDto> searchUsers(String keyword) {
        return null;
    }

    @Override
    public UserDto modifyUser(UserDto userDto) {
        return null;
    }

    @Override
    public boolean follow(UserDto userDto) {
        return false;
    }

    @Override
    public boolean unfollow(UserDto userDto) {
        return false;
    }

    @Override
    public UserDto searchUser() {
        return null;
    }

    @Override
    public List<UserDto> searchFollow() {
        return null;
    }

    @Override
    public List<UserDto> searchFollower() {
        return null;
    }
}
