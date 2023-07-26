import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: const Column(
          children: [
            TextField(
              style: TextStyle(fontSize: 14.0),
              cursorColor: Colors.black12,
              cursorWidth: 1.0,
              decoration: InputDecoration(
                contentPadding:
                EdgeInsets.fromLTRB(10, 0, 10, 0),
                prefixIcon:
                Icon(Icons.search, color: Colors.black54),
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
          ],
        ),
      ),
    );
  }
}
