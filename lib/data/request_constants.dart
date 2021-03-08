class AppUrls {
  static const String _LIVE_BASE_URL =
      "http://codonnier.tech/jaydeep/container/dev";

  /// Create request with query parameter
  static const String BASE_URL = _LIVE_BASE_URL + "/Service.php?";
}

class MethodNames {
  static const userRegistration = "userRegistration";
  static const userLogin = "userlogin";
}

class RequestParam {
  static const service = "Service"; // -> pass method name
  static const showError = "show_error"; // -> bool in String
}

class RequestHeaderKey {
  static const contentType = "Content-Type";
  static const userAgent = "User-Agent";
  static const appSecret = "App-Secret";
  static const appTrackVersion = "App-Track-Version";
  static const appDeviceType = "App-Device-Type";
  static const appStoreVersion = "App-Store-Version";
  static const appDeviceModel = "App-Device-Model";
  static const appOsVersion = "App-Os-Version";
  static const appStoreBuildNumber = "App-Store-Build-Number";
}