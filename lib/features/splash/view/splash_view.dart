import 'package:flutter/material.dart';
import 'package:shartflix/core/routes/app_routes.dart';
import 'package:shartflix/core/resources/app_colors.dart';
import 'package:gradient_borders/gradient_borders.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            colors: [AppColors.primary, AppColors.background],
            stops: [0.2, 1.0],
            radius: 0.9,
          ),
        ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24), // içeride boşluk
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.background],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: const GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [AppColors.white, AppColors.redColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),

              ),
              child: Image.asset(
                "assets/shartflix.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

      ),
    );
  }
}
