import 'package:flutter/material.dart';
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

// final List<String> arr = <String>[
//   '오늘은 기분이 좋아',
//   '랄랄라 랄랄랄랄라',
//   '저 하늘 높이',
//   '날개를 펴고',
//   '날아갈 것 같아요',
//   '오늘은 기분이 좋아',
//   '랄랄라 랄랄랄랄라',
//   '마음 속 깊이',
//   '간직한 꿈이',
//   '이루어질 것 같아요',
//   '꽃들이 너무 예뻐요',
//   '이 세상 모두가 눈이 부셔요',
//   '착한 마음으로 세상을 보면',
//   '모두가 아름다워요',
//   '오늘은 기분이 좋아',
//   '랄랄라 랄랄랄랄라',
//   '오래전부터',
//   '바라던 꿈이',
//   '이루어질 것 같아요',
//   '미안해 솔직하지 못한 내가',
//   '지금 이 순간이 꿈이라면',
//   '살며시 너에게로 다가가',
//   '모든걸 고백할텐데',
//   '전화도 할 수 없는 밤이 오면',
//   '자꾸만 설레이는 내 마음',
//   '동화속 마법의 세계로',
//   '손짓하는 저 달빛',
//   '밤하늘 저 멀리서 빛나고 있는',
//   '꿈결같은 우리의 사랑',
//   '수없이 많은 별들 중에서',
//   '당신을 만날 수 있는건',
//   '결코 우연이라 할 수 없어',
//   '기적의 세일러문'
// ];

class ListViewBuilder extends StatefulWidget {
  const ListViewBuilder({super.key});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {

  double lat = 37.5013068;
  double lng = 127.0396597;
  List<FeedDto> feed = [];
  // List<List<CommentDto>> comments = [];
  bool isLoading = true;
  FeedProviders feedProvider = FeedProviders();
  CommentProviders commentProviders = CommentProviders();
  String _commentContent = '';
  UserDto? _loginUser;
  List<int> _cur = [-1,-1];

  List<bool> isVisible = [];
  List<bool> writeComment = [];

  // List<bool> isVisible = List.filled(feed.length, false);
  // List<bool> writeComment = List.filled(feed.length, false);

  Future initFeed() async {
    // feed = await feedProvider.getFeed(lat, lng);
    feed = await feedProvider.getFeed();
    setState(() {
      isVisible = List.generate(feed.length, (index) => false);
      writeComment = List.generate(feed.length, (index) => false);
    });
  }

  String formatDate(String regTime) {
    print(regTime);
    DateTime time = DateTime.parse(regTime);
    print(time);
    final now = DateTime.now().add(Duration(hours: 9));
    print(now);
    final difference = now.difference(time);
    print(difference);
    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} 분전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} 시간 전';
    } else if (difference.inDays < 7){
      return '${difference.inDays} 일 전';
    }else{
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
            nickname: (await storage.read(key:'nickname'))!,
            profileImg: (await storage.read(key:'profileImg'))!,
            userId: int.parse((await storage.read(key:'userId'))!),
            userRole: int.parse((await storage.read(key:'userRole'))!)
        );

        setState(() {
          _loginUser = temp;
        });
    } catch (e) {
      print("Error reading from secure storage: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    initFeed();
    getValueFromSecureStorage();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // scrollDirection: Axis.,
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
                        Row(
                          children: [
                            Text(
                              feed[index].title,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              feed[index].nickname,
                              style: const TextStyle(fontSize: 10),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              feed[index].regDate,
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.black45),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(feed[index].likeCnt.toString(),
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              feed[index].likeCnt++;
                            });
                          },
                          child: Image(
                              image:
                              AssetImage('assets/images/flower${feed[index].emotion}.png'),
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
                Image(image: NetworkImage(feed[index].img)),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      feed[index].content,
                      style: const TextStyle(height: 1.5),),
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
                          if(isVisible[index]) {
                            _cur[0] = index;
                            _cur[1] = -1;
                          }
                        })
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text(isVisible[index] ? "댓글 ${feed[index].comments?.length??0}개 닫기" : "댓글 ${feed[index].comments?.length??0}개 보기",
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
                        itemCount: feed[index].comments?.length??0,
                        itemBuilder: (context, i){
                        return Column(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                      NetworkImage(feed[index].comments![i].userDto.profileImg),
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
                                            feed[index].comments![i].userDto.nickname,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(formatDate(feed[index].comments![i].regTime),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black45,
                                              )),
                                        ],
                                      ),
                                      Text(
                                        // '짱구가 기분이 좋구나',
                                        feed[index].comments![i].content
                                        ,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 20),
                                      TextButton(
                                        onPressed: () => {
                                          setState(() {
                                            if(_cur[0] == index && _cur[1] == i){
                                              _cur[0] = -1;
                                              _cur[1] = -1;
                                            }else{
                                              _cur[0] = index;
                                              _cur[1] = i;
                                            }
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
                                      // 댓글
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                        itemCount: feed[index].comments![i].cCommentList?.length??0,
                                          itemBuilder: (context, j){
                                            return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                feed[index].comments![i].cCommentList![j].userDto.profileImg),
                                            radius: 25,
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
                                                      feed[index].comments![i].cCommentList![j].userDto.nickname,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(formatDate(feed[index].comments![i].cCommentList![j].regTime),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.black45,
                                                        ))
                                                  ],
                                                ),
                                                Text(
                                                  // '응 좋아 좋아',
                                                  feed[index].comments![i].cCommentList![j].content,
                                                  style:
                                                  const TextStyle(fontSize: 14),
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          ),
                                        ],
                                            );}),
                                      // 댓글 출력 끝
                                      const SizedBox(height: 10),
                          Visibility(
                            visible: isVisible[index] && _cur[0] == index && _cur[1] == i,
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
                                    onPressed: () async{
                                      if(_commentContent != null && _commentContent.isNotEmpty) {
                                        CommentDto commentDto = CommentDto(
                                            cCommentList: [],
                                            cmtId: 0,
                                            content: _commentContent,
                                            feedId: feed[index].feedId,
                                            pcmtId: feed[index].comments![i]
                                                .cmtId,
                                            regTime: '',
                                            userDto: _loginUser!
                                        );
                                        commentProviders.postComment(
                                            commentDto);
                                      }
                                      await initFeed();
                                    }),
                                prefixText: (_cur[0] == index && _cur[1] != -1)?'@${feed[_cur[0]].comments![_cur[1]].userDto.nickname} ':'',
                                hintText: '${_loginUser?.nickname??''}(으)로 댓글 달기...',
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
                                onChanged: (text){
                                  _commentContent = text;
                                },
                            ),
                          ),
                                    ],
                                  ),
                                ),
                              ]),
                        ],
                      );}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
                          Visibility(
                            visible: isVisible[index] && _cur[0] == index && _cur[1] == -1,
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
                                            userDto: _loginUser!
                                        );
                                        commentProviders.postComment(
                                            commentDto);
                                        await initFeed();
                                      }
                                    }),
                                hintText: '${_loginUser?.nickname??''}(으)로 댓글 달기...',
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
                              onChanged: (text){
                                _commentContent = text;
                              },
                            ),
                          ),
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