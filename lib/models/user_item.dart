import 'package:flutter/material.dart';

class UserItem {
  UserItem({
    this.userId,
    this.userToken,
    this.username,
    this.registrationCode,
    this.email,
    this.verifyForgotCode,
    this.socialId,
    this.profileImage,
    this.address,
    this.latitude,
    this.longitude,
    this.stripeId,
    this.deviceType,
    this.authToken,
    this.devicePushToken,
    this.isLoggedOut,
    this.badge,
  });

  int userId;
  String userToken;
  String username;
  String registrationCode;
  String email;
  String verifyForgotCode;
  String socialId;
  String profileImage;
  String address;
  double latitude;
  double longitude;
  String stripeId;
  String deviceType;
  String authToken;
  String devicePushToken;
  int isLoggedOut;
  int badge;

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
        userId: json["user_id"],
        userToken: json["user_token"],
        username:
            json["user_name"] != null ? json["user_name"] : json["username"],
        registrationCode: json["registration_code"],
        email: json["email"],
        verifyForgotCode: json["verify_forgot_code"],
        socialId: json["social_id"],
        profileImage: json["profile_image"],
        address: json["address"],
        latitude: json["latitude"] is int
            ? double.parse(json["latitude"].toString())
            : json["latitude"],
        longitude: json["longitude"] is int
            ? double.parse(json["longitude"].toString())
            : json["longitude"],
        stripeId: json["stripe_id"],
        deviceType: json["device_type"],
        authToken: json["auth_token"],
        devicePushToken: json["device_push_token"],
        isLoggedOut: json["is_logged_out"],
        badge: json["badge"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_token": userToken,
        "username": username,
        "registration_code": registrationCode,
        "email": email,
        "verify_forgot_code": verifyForgotCode,
        "social_id": socialId,
        "profile_image": profileImage,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "stripe_id": stripeId,
        "device_type": deviceType,
        "auth_token": authToken,
        "device_push_token": devicePushToken,
        "is_logged_out": isLoggedOut,
        "badge": badge,
      };
}

class UserProvider with ChangeNotifier {
  UserItem _userItem = UserItem();

  UserItem get userItem => _userItem;

  void setUserItem(UserItem userItem) {
    _userItem = userItem;
    notifyListeners();
  }
}
