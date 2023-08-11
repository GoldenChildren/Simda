import 'package:flutter/material.dart';
import 'package:simda/models/FeedDto.dart';
import 'package:simda/providers/comment_providers.dart';
import 'package:simda/providers/feed_providers.dart';
import 'package:simda/providers/user_providers.dart';
import 'main.dart';
import 'models/CommentDto.dart';
import 'models/UserDto.dart';

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
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  int _userId = 0;
  UserProviders userProvider = UserProviders();

  List<FeedDto> feed = [];
  bool isLoading = true;

  FeedProviders feedProvider = FeedProviders();
  CommentProviders commentProviders = CommentProviders();
  String _commentContent = '';
  UserDto? _loginUser;
  List<int> _cur = [-1, -1];

  List<bool> isVisible = [];

  Future initFeed() async {
    feed = await feedProvider.getUserFeedList(_userId);
    setState(() {
      isVisible = List.generate(feed.length, (reversedIndex) => false);
    });
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

  @override
  void initState() {
    super.initState();
    _userId = 0;
    getValueFromSecureStorage();
  }

  Future<void> getValueFromSecureStorage() async {
    try {
      int storeUserId = int.parse((await storage.read(key: "userId"))!);
      var temp = UserDto(
          email: (await storage.read(key: 'email'))!,
          nickname: (await storage.read(key: 'nickname'))!,
          profileImg: (await storage.read(key: 'profileImg'))!,
          userId: int.parse((await storage.read(key: 'userId'))!),
          userRole: int.parse((await storage.read(key: 'userRole'))!));
      setState(() {
        _userId = storeUserId;
        _loginUser = temp;
      });
      initFeed();
    } catch (e) {
      print("Error reading from secure storage: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
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
                            if (!isVisible[reversedIndex]) {
                              _cur[0] = reversedIndex;
                              _cur[1] = -1;
                            }
                          })
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(0),
                        ),
                        child: Text(
                            isVisible[reversedIndex]
                                ? "댓글 ${feed[reversedIndex].comments?.length ?? 0}개 닫기"
                                : "댓글 ${feed[reversedIndex].comments?.length ?? 0}개 보기",
                            style: const TextStyle(color: Colors.black45)),
                      ),
                    ),
                    Visibility(
                      visible: isVisible[reversedIndex],
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: feed[reversedIndex].comments?.length ?? 0,
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
                                                feed[reversedIndex]
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
                                                  feed[reversedIndex]
                                                      .comments![i]
                                                      .userDto
                                                      .nickname,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                    formatDate(
                                                        feed[reversedIndex]
                                                            .comments![i]
                                                            .regTime),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black45,
                                                    )),
                                              ],
                                            ),
                                            Text(
                                              // '짱구가 기분이 좋구나',
                                              feed[reversedIndex]
                                                  .comments![i]
                                                  .content,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            const SizedBox(width: 20),
                                            TextButton(
                                              onPressed: () => {
                                                setState(() {
                                                  if (_cur[0] ==
                                                          reversedIndex &&
                                                      _cur[1] == i) {
                                                    _cur[0] = -1;
                                                    _cur[1] = -1;
                                                  } else {
                                                    _cur[0] = reversedIndex;
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
                                                    color: Colors.black45),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: feed[reversedIndex]
                                                        .comments![i]
                                                        .cCommentList
                                                        ?.length ??
                                                    0,
                                                itemBuilder: (context, j) {
                                                  return Column(children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(feed[
                                                                      reversedIndex]
                                                                  .comments![i]
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
                                                                    feed[reversedIndex]
                                                                        .comments![
                                                                            i]
                                                                        .cCommentList![
                                                                            j]
                                                                        .userDto
                                                                        .nickname,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Text(
                                                                      formatDate(feed[reversedIndex]
                                                                          .comments![
                                                                              i]
                                                                          .cCommentList![
                                                                              j]
                                                                          .regTime),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .black45,
                                                                      ))
                                                                ],
                                                              ),
                                                              Text(
                                                                // '응 좋아 좋아',
                                                                feed[reversedIndex]
                                                                    .comments![
                                                                        i]
                                                                    .cCommentList![
                                                                        j]
                                                                    .content,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                  ]);
                                                }),
                                          ],
                                        ),
                                      ),
                                    ]),
                                Visibility(
                                  visible: isVisible[reversedIndex] &&
                                      _cur[0] == reversedIndex &&
                                      _cur[1] == i,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: TextField(
                                      maxLines: null,
                                      style: const TextStyle(fontSize: 14.0),
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
                                              if (_commentContent.isNotEmpty) {
                                                CommentDto commentDto =
                                                    CommentDto(
                                                        cCommentList: [],
                                                        cmtId: 0,
                                                        content:
                                                            _commentContent,
                                                        feedId:
                                                            feed[reversedIndex]
                                                                .feedId,
                                                        pcmtId:
                                                            feed[reversedIndex]
                                                                .comments![i]
                                                                .cmtId,
                                                        regTime: '',
                                                        userDto: _loginUser!);
                                                commentProviders
                                                    .postComment(commentDto);
                                                await initFeed();
                                              }
                                            }),
                                        hintText:
                                            '${feed[reversedIndex].comments![i].userDto.nickname}에게 답글 다는 중',
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
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Visibility(
                  visible: isVisible[reversedIndex],
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextField(
                      maxLines: null,
                      style: const TextStyle(fontSize: 14.0),
                      cursorColor: Colors.black12,
                      cursorWidth: 1.0,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            color: Colors.black54,
                            onPressed: () async {
                              if (_commentContent.isNotEmpty) {
                                CommentDto commentDto = CommentDto(
                                    cCommentList: [],
                                    cmtId: 0,
                                    content: _commentContent,
                                    feedId: feed[reversedIndex].feedId,
                                    pcmtId: null,
                                    regTime: '',
                                    userDto: _loginUser!);
                                commentProviders.postComment(commentDto);
                                await initFeed();
                              }
                            }),
                        hintText: '${_loginUser?.nickname ?? ''}(으)로 댓글 달기...',
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
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 2.0,
          color: Colors.black45,
        ),
      ),
    );
  }
}
