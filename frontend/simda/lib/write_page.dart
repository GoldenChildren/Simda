import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simda/main.dart';
import 'package:simda/providers/feed_providers.dart';

import 'main_page.dart';
import 'models/FeedDto.dart';

class WritePage extends StatefulWidget {
  LatLng latLng;

  WritePage(this.latLng, {super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  int selected = -1;
  XFile? _image;
  String _title = '';
  String _content = '';

  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  final _titleEditController = TextEditingController();
  final _contentEditController = TextEditingController();

  FeedProviders feedProvider = FeedProviders();

  FeedDto uploadFeed = FeedDto(
    content: "",
    emotion: -1,
    feedId: -1,
    img: '',
    lat: 0,
    likeCnt: 0,
    lng: 0,
    nickname: "",
    regDate: '',
    title: "",
    userId: 0,
  );

  int emotion = -1;

  void _showEmotionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: const Text(
                    '나의 감정은?',
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(height: 2, color: Colors.purple),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'AI가 분석한 내 감정',
                                style: TextStyle(
                                  color: emotion == 0 && selected == 0
                                      ? Colors.redAccent
                                      : Colors.transparent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = 0;
                                  });

                                  print("selected: $selected");
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      10, 5, 10, 5),
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 6 + 5,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                    color: selected == 0
                                        ? Colors.black12
                                        : Colors.transparent,
                                  ),
                                  child: const Column(
                                    children: [
                                      SizedBox(height: 3),
                                      Image(
                                          image:
                                          AssetImage(
                                              'assets/images/flower0.png')),
                                      SizedBox(height: 5),
                                      Text('행복')
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              Text(
                                'AI가 분석한 내 감정',
                                style: TextStyle(
                                  color: emotion == 1 && selected == 1
                                      ? Colors.redAccent
                                      : Colors.transparent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = 1;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      10, 5, 10, 5),
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 6 + 5,
                                  // color: _colors[1],
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                    color: selected == 1
                                        ? Colors.black12
                                        : Colors.transparent,
                                  ),
                                  child: const Column(
                                    children: [
                                      Image(
                                          image:
                                          AssetImage(
                                              'assets/images/flower1.png')),
                                      SizedBox(height: 5),
                                      Text('신남')
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              Text(
                                'AI가 분석한 내 감정',
                                style: TextStyle(
                                  color: emotion == 2 && selected == 2
                                      ? Colors.redAccent
                                      : Colors.transparent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = 2;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      10, 5, 10, 5),
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 6 + 5,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                    color: selected == 2
                                        ? Colors.black12
                                        : Colors.transparent,
                                  ),
                                  child: const Column(
                                    children: [
                                      Image(
                                          image:
                                          AssetImage(
                                              'assets/images/flower2.png')),
                                      SizedBox(height: 5),
                                      Text('평온')
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'AI가 분석한 내 감정',
                                style: TextStyle(
                                  color: emotion == 3 && selected == 3
                                      ? Colors.redAccent
                                      : Colors.transparent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = 3;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      10, 5, 10, 5),
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 6 + 5,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                    color: selected == 3
                                        ? Colors.black12
                                        : Colors.transparent,
                                  ),
                                  child: const Column(
                                    children: [
                                      Image(
                                          image:
                                          AssetImage(
                                              'assets/images/flower3.png')),
                                      SizedBox(height: 5),
                                      Text('화남')
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              Text(
                                'AI가 분석한 내 감정',
                                style: TextStyle(
                                  color: emotion == 4 && selected == 4
                                      ? Colors.redAccent
                                      : Colors.transparent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = 4;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      10, 5, 10, 5),
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 6 + 5,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                    color: selected == 4
                                        ? Colors.black12
                                        : Colors.transparent,
                                  ),
                                  child: const Column(
                                    children: [
                                      Image(
                                          image:
                                          AssetImage(
                                              'assets/images/flower4.png')),
                                      SizedBox(height: 5),
                                      Text('슬픔')
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            width: 65,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  5)),
                              color: Colors.transparent,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: const Text('저장하기'),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPage(0)),
                                (route) => false);
                        uploadFeed = FeedDto(content: uploadFeed.content,
                            emotion: selected,
                            feedId: uploadFeed.feedId,
                            img: uploadFeed.img,
                            lat: uploadFeed.lat,
                            likeCnt: uploadFeed.likeCnt,
                            lng: uploadFeed.lng,
                            nickname: uploadFeed.nickname,
                            regDate: uploadFeed.regDate,
                            title: uploadFeed.title,
                            userId: uploadFeed.userId);
                        await feedProvider.postFeed(uploadFeed);
                      },
                      child: const Text('작성완료'),
                    ),
                  ],
                );
              }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(children: [
          Row(
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
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '글 작성하기',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {});

                        // 입력된 내용 출력
                        print(_titleEditController.text);
                        print(_contentEditController.text);
                        print(_image!.path);
                        print(selected);

                        // 사용자 정보 가져오기
                        int userId =
                        int.parse(await storage.read(key: 'userId') ?? '0');
                        String nickname =
                            await storage.read(key: 'nickname') ?? '';
                        print(userId);

                        // FeedDto 생성
                        FeedDto feedDto = FeedDto(
                          content: _content,
                          emotion: 0,
                          feedId: 0,
                          img: '',
                          lat: widget.latLng.latitude,
                          likeCnt: 0,
                          lng: widget.latLng.longitude,
                          nickname: nickname,
                          regDate: '',
                          title: _title,
                          userId: userId,
                        );

                        // await feedProvider.postFeed(feedDto);

                        //로딩 화면 표시
                        if (!mounted) return;
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierColor: null,
                          builder: (BuildContext buildContext) {
                            Future.delayed(const Duration(seconds: 1),
                                    () async {
                                  // 감정 정보 받아오기
                                  uploadFeed = await feedProvider.getEmotion(
                                      feedDto, _image!.path);
                                  selected = uploadFeed.emotion;
                                  emotion = uploadFeed.emotion;
                                  if (!mounted) return;
                                  Navigator.of(buildContext).pop(); // 로딩 화면 닫기
                                  _showEmotionDialog(
                                      buildContext); // 감정 선택 화면 열기
                                  print("AI가 분석한 감정: $emotion");
                                  print("선택된 감정: $selected");
                                });
                            return Dialog(
                              // insetAnimationDuration:
                              //     const Duration(seconds: 2),
                                insetPadding: const EdgeInsets.all(0),
                                elevation: 0,
                                backgroundColor: Colors.black45,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(0))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/color.gif'),
                                    // 로딩 스피너
                                    const SizedBox(height: 20.0),
                                    const Text("로딩 중...",
                                        style: TextStyle(fontSize: 16.0)),
                                  ],
                                  // ),
                                ));
                          },
                        );

                        // 2초 딜레이 후 로딩 화면 닫기 및 다이얼로그 표시
                        // await Future.delayed(const Duration(seconds: 2));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStatePropertyAll(Colors.blue.shade200)),
                      child: const Text(
                        '분석하기',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          Container(height: 2, color: Colors.purple),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _titleEditController,
                    maxLines: null,
                    maxLength: 50,
                    style: const TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.bold),
                    cursorColor: Colors.black12,
                    cursorWidth: 1.0,
                    decoration: const InputDecoration(
                      counterText: "",
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      hintText: '제목을 입력하세요',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0.0,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0.0,
                          )),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (text) {
                      _title = text;
                    },
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      height: 1,
                      color: Colors.black54),
                  TextField(
                    controller: _contentEditController,
                    maxLines: null,
                    style: const TextStyle(fontSize: 16.0, height: 1.5),
                    cursorColor: Colors.black12,
                    cursorWidth: 1.0,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                      hintText: '내용을 입력하세요',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0.0,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0.0,
                          )),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (text) {
                      _content = text;
                    },
                  ),
                  _buildImageArea(),
                ],
              ),
            ),
          ),
        ]),
        bottomSheet: SafeArea(
          child: Padding(
            // padding: const EdgeInsets.all(0),
            padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom),
            child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                          color: Colors.black12,
                          width: 1,
                        ))),
                width: double.infinity,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        icon: const Icon(Icons.image_outlined))
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildImageArea() {
    return _image != null
        ? Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 60),
      width: 300,
      height: 300,
      child: Image.file(File(_image!.path)),
    )
        : Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 60),
      width: 300,
      height: 300,
      color: Colors.transparent,
    );
  }

  @override
  void dispose() {
    _titleEditController.dispose();
    _contentEditController.dispose();
    super.dispose();
  }
}
