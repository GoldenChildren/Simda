import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simda/main.dart';
import 'package:simda/main_page.dart';
import 'package:simda/models/UserDto.dart';
import 'package:simda/providers/feed_providers.dart';

import 'models/FeedDto.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  int selected = -1;
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  String _title = '';
  String _content = '';

  final _titleEditController = TextEditingController();
  final _contentEditController = TextEditingController();

  FeedProviders feedProvider = FeedProviders();

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
                          print(_titleEditController.text);
                          print(_contentEditController.text);
                          print(_image!.path);
                          print(selected);
                          // String temp = storage.read(key:'userId');
                          int userId = int.parse(await storage.read(key: 'userId')??'0');
                          print(userId);
                          FeedDto feedDto = FeedDto(
                              content: _content,
                              emotion: 0,
                              feedId: 0,
                              img: '',
                              lat: 37.5013068,
                              likeCnt: 0,
                              lng: 127.0396597,
                              nickName: '',
                              regDate: '',
                              title: _title,
                              userId: userId);
                          feedProvider.postFeed(
                              feedDto, _image!.path);

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.white24,
                                content: Container(
                                  width: 400.0, // 원하는 가로 크기
                                  height: 400.0, // 원하는 세로 크기
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/flower.gif'), // 로딩 스피너
                                      SizedBox(height: 20.0),
                                      Text("로딩 중...", style: TextStyle(fontSize: 16.0)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          // 로딩이 완료되었다고 가정하고, 백엔드에서 emotion 값을 받아옴
                          int receivedEmotion = 2; // 예시로 2로 설정

                          Navigator.of(context).pop(); // 로딩 화면 닫기


                          FocusManager.instance.primaryFocus?.unfocus();
                          showDialog<String>(
                            builder: (context) => StatefulBuilder(builder:
                            context: context,
                                    (BuildContext context, StateSetter setState) {
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
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selected = 0;
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.fromLTRB(
                                                    5, 5, 5, 5),
                                                width: 65,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                                  color: selected == 0
                                                      ? Colors.black12
                                                      : Colors.transparent,
                                                ),
                                                child: const Column(
                                                  children: [
                                                    Image(
                                                        image: AssetImage(
                                                            'assets/images/flower0.png')),
                                                    SizedBox(height: 5),
                                                    Text('행복')
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selected = 1;
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.fromLTRB(
                                                    5, 5, 5, 5),
                                                width: 65,
                                                // color: _colors[1],
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                                  color: selected == 1
                                                      ? Colors.black12
                                                      : Colors.transparent,
                                                ),
                                                child: const Column(
                                                  children: [
                                                    Image(
                                                        image: AssetImage(
                                                            'assets/images/flower1.png')),
                                                    SizedBox(height: 5),
                                                    Text('신남')
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selected = 2;
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.fromLTRB(
                                                    5, 5, 5, 5),
                                                width: 65,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                                  color: selected == 2
                                                      ? Colors.black12
                                                      : Colors.transparent,
                                                ),
                                                child: const Column(
                                                  children: [
                                                    Image(
                                                        image: AssetImage(
                                                            'assets/images/flower2.png')),
                                                    SizedBox(height: 5),
                                                    Text('평온')
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selected = 3;
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.fromLTRB(
                                                    5, 5, 5, 5),
                                                width: 65,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                                  color: selected == 3
                                                      ? Colors.black12
                                                      : Colors.transparent,
                                                ),
                                                child: const Column(
                                                  children: [
                                                    Image(
                                                        image: AssetImage(
                                                            'assets/images/flower3.png')),
                                                    SizedBox(height: 5),
                                                    Text('화남')
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selected = 4;
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.fromLTRB(
                                                    5, 5, 5, 5),
                                                width: 65,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                                  color: selected == 4
                                                      ? Colors.black12
                                                      : Colors.transparent,
                                                ),
                                                child: const Column(
                                                  children: [
                                                    Image(
                                                        image: AssetImage(
                                                            'assets/images/flower4.png')),
                                                    SizedBox(height: 5),
                                                    Text('슬픔')
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(
                                                  5, 5, 5, 5),
                                              width: 65,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
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
                                        onPressed: ()  async {
                                          if (!mounted) return;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>  const MainPage()),
                                          );
                                        },
                                        child: const Text('작성완료'),
                                      ),
                                    ],
                                  );
                                }),
                          );

                        },
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStatePropertyAll(Colors.blue.shade200)),
                        child: const Text(
                          '작성하기',
                          style: TextStyle(color: Colors.black87),
                        )),
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
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _titleEditController,
                    maxLines: null,
                    style: const TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.bold),
                    cursorColor: Colors.black12,
                    cursorWidth: 1.0,
                    decoration: const InputDecoration(
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
                bottom: MediaQuery.of(context).viewInsets.bottom),
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
      color: Colors.red,
    );
  }

  @override
  void dispose() {
    _titleEditController.dispose();
    _contentEditController.dispose();
    super.dispose();
  }
}
