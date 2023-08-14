
import 'package:flutter/material.dart';

class ChatUserProvider with ChangeNotifier {
   String _nickname ="";
   String _profileImg="";
   String _userId="";


   String get nickname => _nickname;
   String get profileImg => _profileImg;
   String get userId => _userId;

  void set nickname(String inputNickname){
    _nickname=inputNickname;
    notifyListeners();
  }
   void set profileImg(String inputProfileImg){
     _profileImg=inputProfileImg;
     notifyListeners();
   }
   void set userId(String inputUserId){
     _userId=inputUserId;
     notifyListeners();
   }
}
