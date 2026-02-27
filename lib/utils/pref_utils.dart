import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  late SharedPreferences _shared;

  static const _prefToken = "token";
  static const _prefFCMToken = "fcm_token";

  static const _isRegistered = "is_registered";
  static const _prefUser = "user";
  static const _prefSaved = "saved";
  static const _prefLangType = "lang_type";
  static const _prefPhoneCode = "phone_code";

  Future<bool> init() async {
    _shared = await SharedPreferences.getInstance();
    return true;
  }

  String getFCMToken() {
    return _shared.getString(_prefFCMToken) ?? "";
  }

  Future<bool> setFCMToken(String value) async {
    return _shared.setString(_prefFCMToken, value);
  }

  String getToken() {
    return _shared.getString(_prefToken) ?? "";
  }

  Future<bool> setToken(String value) async {
    return _shared.setString(_prefToken, value);
  }

  bool isRegistered() {
    return _shared.getBool(_isRegistered) ?? false;
  }

  Future<bool> register(bool value) async {
    return _shared.setBool(_isRegistered, value);
  }

  //
  // AppUserModel? getUserData() {
  //   var data = _shared.getString(_prefUser);
  //   return data == null ? null : AppUserModel.fromJson(jsonDecode(data));
  // }
  //
  // Future<bool> setUserInfo(AppUserModel? value) async {
  //   return _shared.setString(_prefUser, jsonEncode(value?.toJson()));
  // }
  //
  // LangType getCurrentLang() {
  //   return LangType.getObj(_shared.getString(_prefLangType) ?? LangType.uz.getKey());
  // }
  //
  // Future<bool> setCurrentLang(LangType value) async {
  //   return _shared.setString(_prefLangType, value.getKey());
  // }
  //
  // PhoneCode getPhoneCode() {
  //   return PhoneCode.getObj(_shared.getString(_prefPhoneCode) ?? PhoneCode.uz.getKey());
  // }
  //
  // Future<bool> setPhoneCode(PhoneCode value) async {
  //   return _shared.setString(_prefPhoneCode, value.getKey());
  // }

  Future<void> clearAll() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    return;
  }
}
