import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shartflix/core/routes/app_routes.dart';
import 'package:shartflix/features/auth/views/login_view.dart';
import 'package:shartflix/features/auth/views/register_view.dart';
import 'package:shartflix/features/home/view/home_view.dart';
import 'package:shartflix/features/photo/view/profile_photo_page.dart';
import 'package:shartflix/features/profile/view/profile_view.dart';
import 'package:shartflix/features/splash/view/splash_view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => HomeView(currentPage: "home"),
        );
      case AppRoutes.profilePhoto:
        return MaterialPageRoute(builder: (_) => const ProfilePhotoPage());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileView());
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}

