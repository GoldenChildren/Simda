import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simda/friend_profile.dart';

class FollowersListPage extends StatelessWidget {
  const FollowersListPage({Key? key});

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
                  '팔로워 목록',
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
              itemCount: followerProfiles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // 친구 프로필 화면으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendProfilePage(
                          nickname: followerProfiles[index].nickname,
                          bio: followerProfiles[index].bio,
                          profileImage: followerProfiles[index].profileImage,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                      AssetImage(followerProfiles[index].profileImage.path),
                      radius: 26,
                    ),
                    title: Text(followerProfiles[index].nickname),
                    subtitle: Text(followerProfiles[index].bio),
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

List<UserProfile> followerProfiles = [
  UserProfile(
    nickname: '유리',
    bio: '💙',
    profileImage: XFile('assets/images/yuri.jpg'),
  ),
  UserProfile(
    nickname: '짱아',
    bio: '짱아 일기장',
    profileImage: XFile('assets/images/zzanga.png'),
  ),
  UserProfile(
    nickname: '김짱구',
    bio: '부리부리부리부리',
    profileImage: XFile('assets/images/shin.jpg'),
  ),
  // 여기에 더 많은 사용자 정보를 추가할 수 있습니다.
];

class UserProfile {
  final String nickname;
  final String bio;
  final XFile profileImage;

  UserProfile({
    required this.nickname,
    required this.bio,
    required this.profileImage,
  });
}
