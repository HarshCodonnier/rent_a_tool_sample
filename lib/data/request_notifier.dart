import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rent_a_tool_sample/data/base_api_helper.dart';

import '../data/request_constants.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut,
}

class RequestNotifier with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;

  Status get registeredStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final Map<String, dynamic> requestData = {
      "email": email,
      "password": password,
    };

    notifyListeners();
    var queryParameters = {
      RequestParam.service: MethodNames.userLogin,
    };
    String queryString = Uri(queryParameters: queryParameters).query;
    String requestUrl = AppUrls.BASE_URL + queryString;
    return await BaseApiHelper.postRequest(requestUrl, requestData,
        passAuthToken: false);
  }

  Future<Map<String, dynamic>> register(
      String userName, String email, String password) async {
    final Map<String, dynamic> requestData = {
      "username": userName,
      "email": email,
      "password": password,
      "registration_code": "bscode1123138",
      "social_id": ""
    };

    _registeredInStatus = Status.Registering;
    notifyListeners();

    var queryParameters = {
      RequestParam.service: MethodNames.userRegistration,
    };
    String queryString = Uri(queryParameters: queryParameters).query;
    String requestUrl = AppUrls.BASE_URL + queryString;
    return await BaseApiHelper.postRequest(requestUrl, requestData,
        passAuthToken: false);
  }

  Future<Map<String, dynamic>> getAgentList(
      int page, int limit, String search) async {
    final Map<String, dynamic> requestData = {
      "page": page,
      "limit": limit,
      "search": search
    };

    var queryParameters = {RequestParam.service: MethodNames.agentList};
    String queryString = Uri(queryParameters: queryParameters).query;
    String requestUrl = AppUrls.CONTAINER_BASE_URL + queryString;
    return await BaseApiHelper.postRequest(requestUrl, requestData);
  }
}
