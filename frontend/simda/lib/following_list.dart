import 'package:flutter/material.dart';
import 'friend_profile.dart';

class FollowingListPage extends StatelessWidget {
  const FollowingListPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Row(
              children: [
                const SizedBox(width: 10),
                SizedBox(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 28,
                  ),
                ),
                const Text(
                  '팔로잉 목록',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(height: 2, color: Colors.purple),
          Expanded(
            flex: 1,
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: followingProfiles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // 친구 프로필 화면으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendProfilePage(
                          nickname: followingProfiles[index].nickname,
                          bio: followingProfiles[index].bio,
                          profileImage: followingProfiles[index].profileImage,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage(followingProfiles[index].profileImage),
                      radius: 26,
                    ),
                    title: Text(followingProfiles[index].nickname),
                    subtitle: Text(followingProfiles[index].bio),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

List<UserProfile> followingProfiles = [
  UserProfile(
    nickname: '유리',
    bio: '💙',
    profileImage: 'assets/images/yuri.jpg',
  ),
  UserProfile(
    nickname: '짱아',
    bio: '짱아 일기장',
    profileImage: 'assets/images/zzanga.png',
  ),
  UserProfile(
    nickname: '김짱구',
    bio: '부리부리부리부리',
    profileImage: 'assets/images/shin.jpg',
  ),
  UserProfile(
    nickname: '유리',
    bio: '💙',
    profileImage: 'assets/images/yuri.jpg',
  ),
  UserProfile(
    nickname: '짱아',
    bio: '짱아 일기장',
    profileImage: 'assets/images/zzanga.png',
  ),
  UserProfile(
    nickname: '김짱구',
    bio: '부리부리부리부리',
    profileImage: 'assets/images/shin.jpg',
  ),
  UserProfile(
    nickname: '유리',
    bio: '💙',
    profileImage: 'assets/images/yuri.jpg',
  ),
  UserProfile(
    nickname: '짱아',
    bio: '짱아 일기장',
    profileImage: 'assets/images/zzanga.png',
  ),
  UserProfile(
    nickname: '김짱구',
    bio: '부리부리부리부리',
    profileImage: 'assets/images/shin.jpg',
  ),
  UserProfile(
    nickname: '유리',
    bio: '💙',
    profileImage: 'assets/images/yuri.jpg',
  ),
  UserProfile(
    nickname: '짱아',
    bio: '짱아 일기장',
    profileImage: 'assets/images/zzanga.png',
  ),
  UserProfile(
    nickname: '김짱구',
    bio: '부리부리부리부리',
    profileImage: 'assets/images/shin.jpg',
  ),
  // 여기에 더 많은 사용자 정보를 추가할 수 있습니다.
];

class UserProfile {
  final String nickname;
  final String bio;
  final String profileImage;

  UserProfile({
    required this.nickname,
    required this.bio,
    required this.profileImage,
  });
}
