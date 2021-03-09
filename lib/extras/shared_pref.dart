import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'package:rent_a_tool_sample/models/user_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferences = SharedPreference();

class SharedPreference {
  static SharedPreferences _preferences;

  init() async {
    if (_preferences == null)
      _preferences = await SharedPreferences.getInstance();
  }

  static const String IS_LOGGED_IN = "isLoggedIn";
  static const String IS_REGISTERED = "isRegistered";
  static const String _USER_ID = "userId";
  static const String _USER_NAME = "userName";
  static const String _PROFILE_IMAGE = "profileImage";
  static const String _EMAIL = "email";
  static const String _AUTH_TOKEN = "authToken";
  static const String _USER_TOKEN = "userToken";
  static const String _SOCIAL_ID = "socialId";
  static const APP_DEVICE_TYPE = "App-Device-Type";
  static const APP_STORE_VERSION = "App-Store-Version";
  static const APP_DEVICE_MODEL = "App-Device-Model";
  static const APP_OS_VERSION = "App-Os-Version";
  static const APP_STORE_BUILD_NUMBER = "App-Store-Build-Number";
  static const AUTH_TOKEN = "Auth-Token";

  saveUser(UserItem userItem) async {
    _preferences.setBool(IS_LOGGED_IN, true);
    _preferences.setInt(_USER_ID, userItem.userId);
    _preferences.setString(_USER_NAME, userItem.username);
    _preferences.setString(_PROFILE_IMAGE, userItem.profileImage);
    _preferences.setString(_EMAIL, userItem.email);
    _preferences.setString(_AUTH_TOKEN, userItem.authToken);
    _preferences.setString(_USER_TOKEN, userItem.userToken);
    _preferences.setString(_SOCIAL_ID, userItem.socialId);
  }

  Future<UserItem> getUserItem() async {
    UserItem userItem = UserItem();
    userItem.userId = _preferences.getInt(_USER_ID);
    userItem.username = _preferences.getString(_USER_NAME);
    userItem.profileImage = _preferences.getString(_PROFILE_IMAGE);
    userItem.email = _preferences.getString(_EMAIL);
    userItem.authToken = _preferences.getString(_AUTH_TOKEN);
    userItem.userToken = _preferences.getString(_USER_TOKEN);
    userItem.socialId = _preferences.getString(_SOCIAL_ID);

    return userItem;
  }

  void clearUserItem() async {
    _preferences.remove(IS_LOGGED_IN);
    _preferences.remove(_USER_ID);
    _preferences.remove(_USER_NAME);
    _preferences.remove(_PROFILE_IMAGE);
    _preferences.remove(_EMAIL);
    _preferences.remove(_AUTH_TOKEN);
    _preferences.remove(_USER_TOKEN);
    _preferences.remove(_SOCIAL_ID);
  }

  putAppDeviceInfo() async {
    bool isiOS = Platform.isIOS;
    putString(APP_DEVICE_TYPE, isiOS ? "iOS" : "android");
    var deviceInfo = await appDeviceInfo();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (isiOS) {
      IosDeviceInfo iosDeviceInfo = (deviceInfo as IosDeviceInfo);
      putString(APP_DEVICE_MODEL, iosDeviceInfo.name);
      putString(APP_OS_VERSION, "iOS ${iosDeviceInfo.systemVersion}");
    } else {
      AndroidDeviceInfo androidDeviceInfo = (deviceInfo as AndroidDeviceInfo);
      putString(APP_DEVICE_MODEL, androidDeviceInfo.model);
      putString(APP_OS_VERSION, androidDeviceInfo.version.release);
    }
    putString(APP_STORE_VERSION, packageInfo.version);
    putString(APP_STORE_BUILD_NUMBER, packageInfo.buildNumber);
  }

  Future<dynamic> appDeviceInfo() async {
    return Platform.isIOS
        ? await DeviceInfoPlugin().iosInfo
        : await DeviceInfoPlugin().androidInfo;
  }

  Future<bool> putString(String key, String value) async {
    return _preferences == null ? null : _preferences.setString(key, value);
  }

  String getString(String key, {String defValue = ""}) {
    return _preferences == null
        ? defValue
        : _preferences.getString(key) == null
            ? defValue
            : _preferences.getString(key);
  }

  Future<bool> putInt(String key, int value) async {
    return _preferences == null ? null : _preferences.setInt(key, value);
  }

  int getInt(String key, {int defValue = 0}) {
    return _preferences == null
        ? defValue
        : _preferences.getInt(key) == null
            ? defValue
            : _preferences.getInt(key);
  }

  Future<bool> putBool(String key, bool value) async {
    return _preferences == null ? null : _preferences.setBool(key, value);
  }

  bool getBool(String key, {bool defValue = false}) {
    return _preferences == null
        ? defValue
        : _preferences.getBool(key) == null
            ? defValue
            : _preferences.getBool(key);
  }
}
