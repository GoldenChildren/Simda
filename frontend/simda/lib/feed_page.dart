import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<StatefulWidget> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int visit = 0;

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(child: ListViewBuilder()),
          ],
        ),
      ),
    );
  }
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

class ListViewBuilder extends StatefulWidget {
  const ListViewBuilder({super.key});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  List<bool> isVisible = List.filled(arr.length, false);
  List<bool> writeComment = List.filled(arr.length, false);
  List<int> likes = List.filled(arr.length, 0);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // scrollDirection: Axis.,
      itemCount: arr.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              arr[index],
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Row(
                          children: [
                            Text(
                              '김짱구',
                              style: TextStyle(fontSize: 10),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '2023년 7월 21일 15:54',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.black45),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(likes[index].toString(),
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              likes[index]++;
                            });
                          },
                          child: const Image(
                              image:
                                  AssetImage('assets/images/flower-purple.png'),
                              height: 30),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                alignment: Alignment.center,
                child:
                    const Image(image: AssetImage('assets/images/think.png')),
              ),
              const SizedBox(height: 15),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                        '이곳에 글의 내용이 들어갈 예정입니다. 글이 길어지면 어떻게 되는지 보기 위해 긴 글을 작성하고 있습니다. 이 곳은 글이 들어갈 자리입니다.',
                    style: TextStyle(height: 1.5),),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextButton(
                      onPressed: () => {
                        setState(() {
                          isVisible[index] = !isVisible[index];
                        })
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text(isVisible[index] ? "댓글 2개 닫기" : "댓글 2개 보기",
                          style: const TextStyle(color: Colors.black45)),
                    ),
                  ),
                  Visibility(
                    visible: isVisible[index],
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/images/yuri.jpg'),
                                      radius: 25,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Text(
                                            '유리',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 10),
                                          Text('10시간 전',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black45,
                                              )),
                                        ],
                                      ),
                                      const Text(
                                        // '짱구가 기분이 좋구나',
                                        '짱구가 기분이 좋구나 짱구가 기분이 좋구나 짱구가 기분이 좋구나 짱구가 기분이 좋구나 짱구가 기분이 좋구나',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 20),
                                      TextButton(
                                        onPressed: () => {
                                          setState(() {
                                            writeComment[index] =
                                                !writeComment[index];
                                          })
                                        },
                                        style: TextButton.styleFrom(
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: const Text(
                                          '답글 달기',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black45),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/shin.jpg'),
                                            radius: 25,
                                          ),
                                          SizedBox(width: 10),
                                          Flexible(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '김짱구',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text('9시간 전',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black45,
                                                        ))
                                                  ],
                                                ),
                                                Text(
                                                  // '응 좋아 좋아',
                                                  '짱구 기분 짱! 짱구 기분 짱! 짱구 기분 짱! 짱구 기분 짱! 짱구 기분 짱! 짱구 기분 짱! 짱구 기분 짱!',
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                SizedBox(height: 10),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ]),
                          Visibility(
                            visible: writeComment[index],
                            child: const TextField(
                              style: TextStyle(fontSize: 14.0),
                              cursorColor: Colors.black12,
                              cursorWidth: 1.0,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 0, 10, 0),
                                suffixIcon:
                                    Icon(Icons.send, color: Colors.black54),
                                prefixText: '@유리 ',
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
                          ),
                          Visibility(
                            visible: !writeComment[index],
                            child: TextField(
                              style: const TextStyle(fontSize: 14.0),
                              cursorColor: Colors.black12,
                              cursorWidth: 1.0,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.send),
                                    color: Colors.black54,
                                    onPressed: () {}),
                                hintText: '신짱구(으)로 댓글 달기...',
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.black12,
                                  width: 0.0,
                                )),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.black12,
                                  width: 0.0,
                                )),
                                filled: true,
                                fillColor: Colors.black12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
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
