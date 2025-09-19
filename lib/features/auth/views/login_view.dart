import 'package:flutter/material.dart';
import 'package:shartflix/core/resources/app_colors.dart';
import 'package:shartflix/core/resources/app_icons.dart';
import 'package:shartflix/core/routes/app_routes.dart';
import 'package:shartflix/features/auth/auth_service.dart';
import 'package:gradient_borders/gradient_borders.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  // Controllerlar
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final success = await AuthService.loginUser(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (success['data'] != null) {
        // Login başarılı → profil foto sayfasına yönlendir
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.profilePhoto,
              (route) => false,
        );
      } else {
        setState(() => errorMessage = "Kullanıcı adı veya şifre hatalı");
      }
    } catch (e) {
      setState(() => errorMessage = "Kullanıcı adı veya şifre hatalı");
    } finally {
      setState(() => isLoading = false);
    }
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center, // ortalar
                child: Container(
                  padding: const EdgeInsets.all(24),
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
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Image.asset(
                    "assets/shartflix.png",
                    fit: BoxFit.contain,
                    width: 60,  // istediğin boyut
                    height: 60, // istediğin boyut
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                "Giriş Yap",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                "Kullanıcı bilgilerinle giriş yap",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.white.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 32),

              // E-posta input
              TextField(
                controller: emailController,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(AppIcons.mail, color: AppColors.white),
                  labelText: "E-Posta",
                  labelStyle: const TextStyle(color: AppColors.textGrey),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Şifre input
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(color: errorMessage != null ? Colors.red : AppColors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(AppIcons.lock, color: AppColors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? AppIcons.see : AppIcons.hide,
                      color: AppColors.white,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  labelText: "Şifre",
                  labelStyle: const TextStyle(color: AppColors.textGrey),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Hata mesajı
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => {},

                  child: const Text(
                    "Şifremi Unuttum",
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Giriş yap butonu
              ElevatedButton(
                onPressed: isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Giriş Yap", style: TextStyle(color: AppColors.white, fontSize: 16)),
              ),

              const SizedBox(height: 24),

              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image:
                    AssetImage("assets/google.png")
                    ),
                    const SizedBox(width: 16),
                    Image(image:
                    AssetImage("assets/apple.png")
                    ),
                    const SizedBox(width: 16),
                    Image(image:
                    AssetImage("assets/facebook.png")
                    ),
                  ]
              ),

              // Kayıt ol linki
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Bir hesabın yok mu?",
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                    child: const Text(
                      "Kayıt Ol",
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
