import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simda/models/UserDto.dart';
import 'friend_profile.dart';

class FollowingListPage extends StatelessWidget {
  final List<UserDto> userList;

  const FollowingListPage({required this.userList, super.key});

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
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // 친구 프로필 화면으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendProfilePage(
                          userDto: userList[index],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          userList[index].profileImg),
                      radius: 26,
                    ),
                    title: Text(userList[index].nickname),
                    subtitle: Text(userList[index].bio ?? ""),
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
