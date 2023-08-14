import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:simda/main.dart';
import 'package:simda/models/CommentDto.dart';
import 'package:simda/models/FeedDto.dart';
import 'package:simda/models/UserDto.dart';
import 'package:simda/providers/comment_providers.dart';
import 'package:simda/providers/feed_providers.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<StatefulWidget> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  List<FeedDto> feed = [];
  FeedProviders feedProvider = FeedProviders();
  CommentProviders commentProviders = CommentProviders();
  String _commentContent = '';
  UserDto? _loginUser;
  List<int> _cur = [-1, -1];

  List<bool> isVisible = [];

  int size = -1;

  Future initFeed() async {
    var gps = await getCurrentLocation();
    feed = await feedProvider.getFeed(gps.latitude, gps.longitude);
    setState(() {
      isVisible = List.generate(feed.length, (index) => false);
      if (mounted) {
        isVisible = List.generate(feed.length, (index) => false);
      }
    });
    size = feed.length;
  }

  String formatDate(String regTime) {
    print(regTime);
    DateTime time = DateTime.parse(regTime);
    print(time);
    final now = DateTime.now().add(const Duration(hours: 9));
    print(now);
    final difference = now.difference(time);
    print(difference);
    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} 분전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} 시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} 일 전';
    } else {
      return regTime;
    }
  }

  Future<void> getValueFromSecureStorage() async {
    try {
      // String? storeEmail = await storage.read(key: "email");
      // String? storeProfileImg = await storage.read(key: "profileImg");
      // String? storeNickname = await storage.read(key: "nickname");
      // String? storeBio = await storage.read(key: "bio");
      // int storeUserId = int.parse((await storage.read(key: "userId"))!);
      // int storeUserRole = int.parse((await storage.read(key: "userRole"))!);

      var temp = UserDto(
          email: (await storage.read(key: 'email'))!,
          nickname: (await storage.read(key: 'nickname'))!,
          profileImg: (await storage.read(key: 'profileImg'))!,
          userId: int.parse((await storage.read(key: 'userId'))!),
          userRole: int.parse((await storage.read(key: 'userRole'))!));

      setState(() {
        _loginUser = temp;
      });
    } catch (e) {
      print("Error reading from secure storage: $e");
    }
  }

  late bool _isLoading;

  @override
  void initState() {
    _isLoading = true;
    initFeed();
    getValueFromSecureStorage();
    Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Skelton(
                          height: 30,
                          width: 160,
                          // width: MediaQuery.of(context).size.width - 40,
                        ),
                        SizedBox(height: 10),
                        Skelton(
                          height: 20,
                          width: 250,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Skelton(
                          height: 35,
                          width: 35,
                        ),
                        SizedBox(width: 5),
                        Skelton(
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Skelton(
                  height: 450,
                ),
                SizedBox(height: 10),
                Skelton(
                  height: 30,
                  width: 200,
                )
              ],
            ),
          )
        // ? const Center(child: Text('게시물이 없습니다.'))
        : ListView.separated(
            itemCount: feed.length,
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
                              Container(
                                width: MediaQuery.of(context).size.width /
                                    100 *
                                    73,
                                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Expanded(
                                  child: Text(
                                    feed[index].title,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    feed[index].nickname,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    feed[index].regDate,
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
                                  feed[index].likeCnt > 99
                                      ? "99+"
                                      : feed[index].likeCnt.toString(),
                                  style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  FeedDto feedDto = FeedDto(
                                      content: feed[index].content,
                                      emotion: feed[index].emotion,
                                      feedId: feed[index].feedId,
                                      img: feed[index].img,
                                      lat: feed[index].lat,
                                      likeCnt: feed[index].likeCnt + 1,
                                      lng: feed[index].lng,
                                      nickname: feed[index].nickname,
                                      regDate: feed[index].regDate,
                                      title: feed[index].title,
                                      userId: feed[index].userId);
                                  feedProvider.addLikes(feedDto);
                                  setState(() {
                                    feed[index].likeCnt++;
                                  });
                                },
                                child: Image(
                                    image: AssetImage(
                                        'assets/images/flower${feed[index].emotion}.png'),
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
                      child: Image(image: NetworkImage(feed[index].img)),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            feed[index].content,
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
                                isVisible[index] = !isVisible[index];
                                if (isVisible[index]) {
                                  _cur[0] = index;
                                  _cur[1] = -1;
                                }
                              })
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.all(0),
                            ),
                            child: Text(
                                isVisible[index]
                                    ? "댓글 ${feed[index].comments?.length ?? 0}개 닫기"
                                    : "댓글 ${feed[index].comments?.length ?? 0}개 보기",
                                style: const TextStyle(color: Colors.black45)),
                          ),
                        ),
                        Visibility(
                          visible: isVisible[index],
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: feed[index].comments?.length ?? 0,
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      feed[index]
                                                          .comments![i]
                                                          .userDto
                                                          .profileImg),
                                                  radius: 25,
                                                ),
                                                const SizedBox(
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
                                                  Row(
                                                    children: [
                                                      Text(
                                                        feed[index]
                                                            .comments![i]
                                                            .userDto
                                                            .nickname,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                          formatDate(feed[index]
                                                              .comments![i]
                                                              .regTime),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black45,
                                                          )),
                                                    ],
                                                  ),
                                                  Text(
                                                    // '짱구가 기분이 좋구나',
                                                    feed[index]
                                                        .comments![i]
                                                        .content,
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  TextButton(
                                                    onPressed: () => {
                                                      setState(() {
                                                        if (_cur[0] == index &&
                                                            _cur[1] == i) {
                                                          _cur[0] = -1;
                                                          _cur[1] = -1;
                                                        } else {
                                                          _cur[0] = index;
                                                          _cur[1] = i;
                                                        }
                                                      })
                                                    },
                                                    style: TextButton.styleFrom(
                                                      minimumSize: Size.zero,
                                                      padding: EdgeInsets.zero,
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                    ),
                                                    child: const Text(
                                                      '답글 달기',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  // 댓글
                                                  ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: feed[index]
                                                              .comments![i]
                                                              .cCommentList
                                                              ?.length ??
                                                          0,
                                                      itemBuilder:
                                                          (context, j) {
                                                        return Column(
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CircleAvatar(
                                                                  backgroundImage: NetworkImage(feed[
                                                                          index]
                                                                      .comments![
                                                                          i]
                                                                      .cCommentList![
                                                                          j]
                                                                      .userDto
                                                                      .profileImg),
                                                                  radius: 25,
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                Flexible(
                                                                  flex: 1,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            feed[index].comments![i].cCommentList![j].userDto.nickname,
                                                                            style:
                                                                                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 10),
                                                                          Text(
                                                                              formatDate(feed[index].comments![i].cCommentList![j].regTime),
                                                                              style: const TextStyle(
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black45,
                                                                              ))
                                                                        ],
                                                                      ),
                                                                      Text(
                                                                        // '응 좋아 좋아',
                                                                        feed[index]
                                                                            .comments![i]
                                                                            .cCommentList![j]
                                                                            .content,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                          ],
                                                        );
                                                      }),
                                                  // 댓글 출력 끝
                                                ],
                                              ),
                                            ),
                                          ]),
                                      Visibility(
                                        visible: isVisible[index] &&
                                            _cur[0] == index &&
                                            _cur[1] == i,
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 10),
                                          child: TextField(
                                            maxLines: null,
                                            style:
                                                const TextStyle(fontSize: 14.0),
                                            cursorColor: Colors.black12,
                                            cursorWidth: 1.0,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              suffixIcon: IconButton(
                                                  icon: const Icon(Icons.send),
                                                  color: Colors.black54,
                                                  onPressed: () async {
                                                    if (_commentContent
                                                        .isNotEmpty) {
                                                      CommentDto commentDto =
                                                          CommentDto(
                                                              cCommentList: [],
                                                              cmtId: 0,
                                                              content:
                                                                  _commentContent,
                                                              feedId:
                                                                  feed[index]
                                                                      .feedId,
                                                              pcmtId: feed[
                                                                      index]
                                                                  .comments![i]
                                                                  .cmtId,
                                                              regTime: '',
                                                              userDto:
                                                                  _loginUser!);
                                                      commentProviders
                                                          .postComment(
                                                              commentDto);
                                                      await initFeed();
                                                    }
                                                  }),
                                              hintText:
                                                  '${feed[index].comments![i].userDto.nickname}에게 답글 다는 중',
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                color: Colors.black12,
                                                width: 0.0,
                                              )),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                color: Colors.black12,
                                                width: 0.0,
                                              )),
                                              filled: true,
                                              fillColor: Colors.black12,
                                            ),
                                            onChanged: (text) {
                                              _commentContent = text;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isVisible[index],
                      // && _cur[0] == index && _cur[1] == -1,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextField(
                          maxLines: null,
                          style: const TextStyle(fontSize: 14.0),
                          cursorColor: Colors.black12,
                          cursorWidth: 1.0,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.send),
                                color: Colors.black54,
                                onPressed: () async {
                                  if (_commentContent != null &&
                                      _commentContent.isNotEmpty) {
                                    CommentDto commentDto = CommentDto(
                                        cCommentList: [],
                                        cmtId: 0,
                                        content: _commentContent,
                                        feedId: feed[index].feedId,
                                        pcmtId: null,
                                        regTime: '',
                                        userDto: _loginUser!);
                                    commentProviders.postComment(commentDto);
                                    await initFeed();
                                  }
                                }),
                            hintText:
                                '${_loginUser?.nickname ?? ''}(으)로 댓글 달기...',
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
                          onChanged: (text) {
                            _commentContent = text;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              height: 2.0,
              color: Colors.black45,
            ),
          );
  }
}

class LoadingSkelton {}

class Skelton extends StatelessWidget {
  const Skelton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.06),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
    );
  }
}
