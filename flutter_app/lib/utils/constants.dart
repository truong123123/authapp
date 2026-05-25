class AppConstants {
  // =========================================================
  // ⚠️  ĐỔI IP NÀY THÀNH IP MÁY TÍNH CỦA BẠN
  //      (chạy `ipconfig` để xem, chọn IP trong mạng LAN)
  // =========================================================
  static const String baseUrl = 'http://172.16.6.205:8080';

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
