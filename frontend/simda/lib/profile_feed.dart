import 'package:flutter/material.dart';
import 'package:simda/models/FeedDto.dart';
import 'package:simda/providers/feed_providers.dart';
import 'package:simda/providers/user_providers.dart';
import 'main.dart';

class ProfileFeedPage extends StatefulWidget {
  const ProfileFeedPage({Key? key}) : super(key: key);

  @override
  State<ProfileFeedPage> createState() => _ProfileFeedState();
}

class _ProfileFeedState extends State<ProfileFeedPage> {
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

class ListViewBuilder extends StatefulWidget {
  const ListViewBuilder({super.key});

  @override
  State<ListViewBuilder> createState() => ListViewBuilderState();
}

class ListViewBuilderState extends State<ListViewBuilder> {
  int _userId = 0;
  UserProviders userProvider = UserProviders();

  List<FeedDto> feed = [];
  bool isLoading = true;

  FeedProviders feedProvider = FeedProviders();

  List<bool> isVisible = [];
  List<bool> writeComment = [];

  Future initFeed() async {
    feed = await feedProvider.getUserFeedList(_userId);
    setState(() {
      isVisible = List.generate(feed.length, (reversedIndex) => true);
      writeComment = List.generate(feed.length, (reversedIndex) => true);
    });
  }

  @override
  void initState() {
    super.initState();
    _userId = 0;
    getValueFromSecureStorage();
  }

  Future<void> getValueFromSecureStorage() async {
    try {
      int storeUserId = int.parse((await storage.read(key: "userId"))!);
      setState(() {
        _userId = storeUserId;
      });
      initFeed();
    } catch (e) {
      print("Error reading from secure storage: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        key: const PageStorageKey("피드"),
        // scrollDirection: Axis.,
        itemCount: feed.length,
        itemBuilder: (context, int index) {
          int reversedIndex = feed.length - index - 1;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            width: MediaQuery.of(context).size.width,
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
                          Container(
                            width: MediaQuery.of(context).size.width / 100 * 73,
                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    feed[reversedIndex].title,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                feed[reversedIndex].nickname,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                feed[reversedIndex].regDate,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black45),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                              feed[reversedIndex].likeCnt > 99
                                  ? "99+"
                                  : feed[reversedIndex].likeCnt.toString(),
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              FeedDto feedDto = FeedDto(
                                  content: feed[reversedIndex].content,
                                  emotion: feed[reversedIndex].emotion,
                                  feedId: feed[reversedIndex].feedId,
                                  img: feed[reversedIndex].img,
                                  lat: feed[reversedIndex].lat,
                                  likeCnt: feed[reversedIndex].likeCnt + 1,
                                  lng: feed[reversedIndex].lng,
                                  nickname: feed[reversedIndex].nickname,
                                  regDate: feed[reversedIndex].regDate,
                                  title: feed[reversedIndex].title,
                                  userId: feed[reversedIndex].userId);
                              feedProvider.addLikes(feedDto);
                              setState(() {
                                feed[reversedIndex].likeCnt++;
                              });
                            },
                            child: Image(
                                image: AssetImage(
                                    'assets/images/flower${feed[reversedIndex].emotion}.png'),
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
                  child: Image(image: NetworkImage(feed[reversedIndex].img)),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        feed[reversedIndex].content,
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                    const SizedBox(width: 20),
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
                            isVisible[reversedIndex] =
                                !isVisible[reversedIndex];
                          })
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(0),
                        ),
                        child: Text(
                            isVisible[reversedIndex] ? "댓글 2개 닫기" : "댓글 2개 보기",
                            style: const TextStyle(color: Colors.black45)),
                      ),
                    ),
                    Visibility(
                      visible: isVisible[reversedIndex],
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
                                        backgroundImage: AssetImage(
                                            'assets/images/yuri.jpg'),
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
                                              writeComment[reversedIndex] =
                                                  !writeComment[reversedIndex];
                                            })
                                          },
                                          style: TextButton.styleFrom(
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text('9시간 전',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black45,
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
                              visible: writeComment[reversedIndex],
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
                              visible: !writeComment[reversedIndex],
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
        // separatorBuilder: (BuildContext context, int index) => const Divider(
        //   height: 2.0,
        //   color: Colors.black45,
        // ),
      ),
    );
  }
}
