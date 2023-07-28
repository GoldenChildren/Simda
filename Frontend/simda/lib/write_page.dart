import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  int selected = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                        onPressed: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
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
                                                      'assets/images/flowerYellow.png')),
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
                                                      'assets/images/flowerPurple.png')),
                                              SizedBox(height: 5),
                                              Text('평온')
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
                                                      'assets/images/flowerBlue.png')),
                                              SizedBox(height: 5),
                                              Text('슬픔')
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                      'assets/images/flowerGreen.png')),
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
                                                      'assets/images/flowerPink.png')),
                                              SizedBox(height: 5),
                                              Text('화남')
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 5, 5, 5),
                                        width: 65,
                                        decoration: const BoxDecoration(
                                          borderRadius:
                                          BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Colors.transparent,
                                        ),),
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
                              ],
                            ),
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
          const TextField(
            maxLines: null,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            cursorColor: Colors.black12,
            cursorWidth: 1.0,
            decoration: InputDecoration(
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
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: 1,
              color: Colors.black54),
          const TextField(
            maxLines: null,
            style: TextStyle(fontSize: 16.0, height: 1.5),
            cursorColor: Colors.black12,
            cursorWidth: 1.0,
            decoration: InputDecoration(
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
          ),
        ]),
        bottomSheet: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(0),
            // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                        onPressed: () {},
                        icon: const Icon(Icons.image_outlined))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
