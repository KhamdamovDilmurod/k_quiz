import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';

class PrefUtils {
  late SharedPreferences _shared;

  static const _prefToken = "token";
  static const _prefFCMToken = "fcm_token";

  static const _isRegistered = "is_registered";
  static const _prefUser = "user";
  static const _prefSaved = "saved";
  static const _prefLangType = "lang_type";
  static const _prefPhoneCode = "phone_code";
  static const _prefThemeMode = "theme_mode";

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

  UserModel? getUserData() {
    final data = _shared.getString(_prefUser);
    if (data == null || data.isEmpty) return null;

    try {
      return UserModel.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<bool> setUserInfo(UserModel? value) async {
    if (value == null) {
      return _shared.remove(_prefUser);
    }
    return _shared.setString(_prefUser, jsonEncode(value.toJson()));
  }

  ThemeMode getThemeMode() {
    final value = _shared.getString(_prefThemeMode) ?? 'system';
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<bool> setThemeMode(ThemeMode mode) {
    return _shared.setString(_prefThemeMode, mode.name);
  }

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
