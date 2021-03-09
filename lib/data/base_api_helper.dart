import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../extras/shared_pref.dart';
import 'api_exception.dart';
import 'request_constants.dart';

class BaseApiHelper {
  static Future<Map<String, dynamic>> postRequest(
      String requestUrl, Map<String, dynamic> requestData,
      {bool passAuthToken = true}) async {
    return await post(requestUrl, body: json.encode(requestData), headers: {
      RequestHeaderKey.contentType: "application/json",
      RequestHeaderKey.userAgent: "container1102",
      RequestHeaderKey.appSecret: "container1102",
      RequestHeaderKey.appTrackVersion: "v1",
      RequestHeaderKey.appDeviceType:
          preferences.getString(SharedPreference.APP_DEVICE_TYPE),
      RequestHeaderKey.appStoreVersion:
          preferences.getString(SharedPreference.APP_STORE_VERSION),
      RequestHeaderKey.appDeviceModel:
          preferences.getString(SharedPreference.APP_DEVICE_MODEL),
      RequestHeaderKey.appOsVersion:
          preferences.getString(SharedPreference.APP_OS_VERSION),
      RequestHeaderKey.appStoreBuildNumber:
          preferences.getString(SharedPreference.APP_STORE_BUILD_NUMBER),
      if (passAuthToken)
        RequestHeaderKey.authToken:
            preferences.getString(SharedPreference.AUTH_TOKEN),
    })
        .then((response) => onValue(response))
        .onError((error, stackTrace) => onError(error));
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool status = false;
    String message;
    dynamic data = responseData;

    if (response.statusCode == 200) {
      message = responseData["msg"];
      if (responseData["status"] == 1) {
        status = true;
        data = responseData["data"];
      }
    } else {
      message = "Something went wrong.";
    }
    result = {
      "status": status,
      "message": message,
      "data": data,
    };
    return result;
  }

  static onError(error) {
    print("Error caused: " + error.toString());
    bool status = false;
    String message = "Unsuccessful request";
    if (error is SocketException) {
      message = ResponseException("No internet connection").toString();
    }
    return {
      "status": status,
      "message": message,
      "data": error,
    };
  }
}
