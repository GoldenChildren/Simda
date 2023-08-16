import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:simda/models/UserDto.dart';

class Store{
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> saveAccessToken(OAuthToken token) async{
    storage.write(key: 'accessToken', value: token.accessToken);
    storage.write(key: 'expiresAt', value : token.expiresAt.toIso8601String());
  }

  Future<bool> checkAccessTokenValidity() async{
    final expiresAtString = await storage.read(key: 'expiresAt');
    final expiresAt = (expiresAtString != null)?DateTime.parse(expiresAtString):null;

    if(expiresAt != null && DateTime.now().isBefore(expiresAt)){
      return true;
    }else{
      return false;
    }
  }

  Future<void> saveStorage(Map<String, dynamic> map) async {
    print(map);
    print("정보받아보자 : " + map["email"]);

    map.forEach((key, value) {
      if (value is String) {
        storage.write(key: key, value: value);
      } else {
        String stringValue = json.encode(value);
        storage.write(key: key, value: stringValue);
      }
    });
    print(map);
  }

  Future<UserDto?> getValueFromSecureStorage() async {
    try {
      String? storeEmail = await storage.read(key: "email");
      String? storeProfileImg = await storage.read(key: "profileImg");
      String? storeNickname = await storage.read(key: "nickname");
      String? storeBio = await storage.read(key: "bio");
      int storeUserRole = int.parse((await storage.read(key: "userRole"))??'1');
      int storeUserId = int.parse((await storage.read(key: "userId"))!);

      return UserDto(
          email: storeEmail??'',
          nickname: storeNickname??'',
          profileImg: storeProfileImg??'',
          bio: storeBio,
          userRole: storeUserRole,
          userId: storeUserId,
      );
    } catch (e) {
      print("Error reading from secure storage: $e");
    }
    return null;
  }

  void logout() {
    storage.delete(key: 'accessToken');
    storage.delete(key: 'expiresAt');
  }
}