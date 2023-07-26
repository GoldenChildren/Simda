import 'package:flutter/material.dart';

import 'main.dart';

class ChatWithFriend extends StatefulWidget {
  final int idx;

  const ChatWithFriend(this.idx, {super.key});

  @override
  State<ChatWithFriend> createState() => _ChatWithFriendState();
}

class _ChatWithFriendState extends State<ChatWithFriend> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          Row(
            children: [
              const SizedBox(width: 10),
              SizedBox(
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    isVisible = !isVisible;
                  },
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 28,
                ),
              ),
              Text(
                friends[widget.idx],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(height: 2, color: Colors.purple),
          Expanded(child: ListViewBuilder(widget.idx)),
          const TextField(
            style: TextStyle(fontSize: 14.0),
            cursorColor: Colors.black12,
            cursorWidth: 1.0,
            decoration: InputDecoration(
              contentPadding:
              EdgeInsets.fromLTRB(20, 0, 10, 0),
              suffixIcon:
              Icon(Icons.send, color: Colors.black54),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black12,
                    width: 0.0,
                  )),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black12,
                    width: 0.0,
                  )),
              filled: true,
              fillColor: Colors.black12,
            ),
          ),
        ]),
      ),
    );
  }
}

final List<String> friends = <String>[
  '맹구',
  '철수',
  '유리',
  '짱아',
  '맹구',
  '철수',
  '유리',
  '짱아',
  '맹구',
  '철수',
  '유리',
  '짱아',
  '맹구',
  '철수',
  '유리',
  '짱아'
];

class ListViewBuilder extends StatefulWidget {
  final int index;
  const ListViewBuilder(this.index, {super.key});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

final List<String> arr = <String>[
  '오늘은 기분이 좋아',
  '랄랄라 랄랄랄랄라',
  '저 하늘 높이',
  '날개를 펴고',
  '날아갈 것 같아요',
  '오늘은 기분이 좋아',
  '랄랄라 랄랄랄랄라',
  '마음 속 깊이',
  '간직한 꿈이',
  '이루어질 것 같아요',
  '꽃들이 너무 예뻐요',
  '이 세상 모두가 눈이 부셔요',
  '착한 마음으로 세상을 보면',
  '모두가 아름다워요',
  '오늘은 기분이 좋아',
  '랄랄라 랄랄랄랄라',
  '오래전부터',
  '바라던 꿈이',
  '이루어질 것 같아요',
  '미안해 솔직하지 못한 내가',
  '지금 이 순간이 꿈이라면',
  '살며시 너에게로 다가가',
  '모든걸 고백할텐데',
  '전화도 할 수 없는 밤이 오면',
  '자꾸만 설레이는 내 마음',
  '동화속 마법의 세계로',
  '손짓하는 저 달빛',
  '밤하늘 저 멀리서 빛나고 있는',
  '꿈결같은 우리의 사랑',
  '수없이 많은 별들 중에서',
  '당신을 만날 수 있는건',
  '결코 우연이라 할 수 없어',
  '기적의 세일러문'
];

class _ListViewBuilderState extends State<ListViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: arr.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(children: [
              const Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/yuri.jpg'),
                    radius: 26,
                  ),
                  SizedBox(height: 10),
                ],
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 23,
                      child: Text(
                        friends[widget.index],
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade200,
                          borderRadius: const BorderRadius.only(
                              // topLeft: Radius.circular(5),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Text(
                          arr[index],
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '오후 4: 30',
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          );
        });
  }
}
