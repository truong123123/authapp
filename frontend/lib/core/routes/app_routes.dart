import 'package:flutter/material.dart';
import 'package:le_nhat_truong/features/auth/screens/login_screen.dart';
import 'package:le_nhat_truong/features/auth/screens/register_screen.dart';
import 'package:le_nhat_truong/features/shop/screens/splash_screen.dart';
import 'package:le_nhat_truong/features/shop/screens/main_page.dart';
import 'package:le_nhat_truong/features/orders/screens/checkout_screen.dart';
import 'package:le_nhat_truong/features/auth/screens/oauth2_redirect_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String checkout = '/checkout';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name != null && settings.name!.startsWith('/oauth2/redirect')) {
      final uri = Uri.parse(settings.name!);
      final token = uri.queryParameters['token'];
      final refreshToken = uri.queryParameters['refreshToken'];
      return MaterialPageRoute(
        builder: (context) => OAuth2RedirectScreen(
          token: token,
          refreshToken: refreshToken,
        ),
        settings: settings,
      );
    }

    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
          settings: settings,
        );
      case register:
        return MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
          settings: settings,
        );
      case main:
        return MaterialPageRoute(
          builder: (context) => const MainPage(),
          settings: settings,
        );
      case checkout:
        return MaterialPageRoute(
          builder: (context) => const CheckoutScreen(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
