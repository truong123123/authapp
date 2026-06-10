import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConstants {
  // =========================================================
  // Cấu hình Base URL không dùng ngrok
  // =========================================================
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    }
    if (Platform.isAndroid) {
      // Sử dụng localhost kết hợp với adb reverse tcp:8080 tcp:8080
      // để Google OAuth2 không chặn địa chỉ IP riêng tư (private IP).
      return 'http://localhost:8080';
    }
    return 'http://localhost:8080';
  }

  // API Endpoints
  static const String loginEndpoint = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';
  static const String refreshEndpoint = '/api/auth/refresh';
  static const String logoutEndpoint = '/api/auth/logout';
  static const String meEndpoint = '/api/users/me';

  // SharedPreferences Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';
}
