import 'dart:convert';

import 'package:simda/models/UserDto.dart';
import 'package:http/http.dart' as http;

class UserProviders {
  Uri uri = Uri.parse("");

  void deleteUser(int userId) async {
    String uri = "http://i9a709.p.ssafy.io:8000/user/";
    uri += "$userId";

    final response = await http.put(Uri.parse(uri));

    if(response.statusCode == 200) {
      print("Success!");
    }
  }
}
