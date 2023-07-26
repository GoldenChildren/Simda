import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
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
                      TextButton(onPressed: () => {},
                          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue.shade200)),
                          child: const Text('작성하기', style: TextStyle(color: Colors.black87),)),
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
          ])),
    );
  }
}
