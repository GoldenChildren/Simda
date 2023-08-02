import 'package:flutter/material.dart';
import 'package:simda/chat_with_friend.dart';
import 'package:simda/main.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '채팅 목록',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(onPressed: () {},
                      icon: const Icon(Icons.add), iconSize: 28,),
                    ],
                  ),
                ),
                Container(height: 2, color: Colors.purple),
                const Expanded(
                    child: ListViewBuilder()),
              ],
            ),
          ),
        ),
      );
  }
}

final List<String> friends = <String>['맹구', '철수', '유리', '짱아', '맹구', '철수', '유리', '짱아', '맹구', '철수', '유리', '짱아', '맹구', '철수', '유리', '짱아'];

class ListViewBuilder extends StatefulWidget {
  const ListViewBuilder({super.key});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: friends.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatWithFriend(index)),
            );
            isVisible = !isVisible;
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/yuri.jpg'),
                  radius: 30,
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            friends[index],
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          const Text('내일 축구 안할거야?',
                          style: TextStyle(fontSize: 15),),
                        ],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('오후 4:30'),
                            const SizedBox(height: 5),
                            Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '10',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 2.0,
        color: Colors.black45,
      ),
    );
  }
}
