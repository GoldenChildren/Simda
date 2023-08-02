import 'package:flutter/material.dart';

class ProfileFeedPage extends StatelessWidget {
  const ProfileFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
      key: const PageStorageKey("피드"),
      itemCount: 1000,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              "List View $index",
              style: TextStyle(
                fontSize: 16,
                color: Colors.accents[index % 15],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    ),
    );
  }
}
