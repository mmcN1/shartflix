import 'package:flutter/material.dart';
import 'package:shartflix/core/resources/app_colors.dart';
import 'package:shartflix/core/resources/app_icons.dart';
import 'package:shartflix/core/routes/app_routes.dart';
import 'package:shartflix/features/auth/auth_service.dart';
import 'package:gradient_borders/gradient_borders.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isLoading = false;

  // Hata kontrolü
  bool hasError = false;
  String errorMessage = "";

  Future<void> _register() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      setState(() {
        hasError = true;
        errorMessage = "Şifreler eşleşmiyor";
        isLoading = false;
      });
      return;
    }

    try {
      final result = await AuthService.registerUser(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (result['data'] != null) {
        debugPrint("Kayıt başarılı: ${result['data']['name']}");
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        setState(() {
          hasError = true;
          errorMessage = "Kayıt sırasında bir hata oluştu";
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = "Kayıt sırasında bir hata oluştu";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  InputDecoration _inputDecoration({required String label, required IconData icon}) {
    return InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Icon(icon, size: 20, color: AppColors.white),
      ),
      labelText: label,
      labelStyle: TextStyle(color: hasError ? Colors.red : AppColors.textGrey),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: hasError ? Colors.red : AppColors.inputBorder.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: hasError ? Colors.red : AppColors.inputBorder.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: hasError ? Colors.red : AppColors.primary.withOpacity(0.2)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
          child: SingleChildScrollView(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 102),
                Align(
                  alignment: Alignment.center, // ortalar
                  widthFactor: 1, // Container'ın içeriği kadar genişlik alır
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
                  "Hesap Oluştur",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Yeni bir hesap oluştur",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 32),

                // Ad Soyad
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: AppColors.white),
                  decoration: _inputDecoration(label: "Ad Soyad", icon: AppIcons.user),
                ),
                const SizedBox(height: 16),

                // Email
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: AppColors.white),
                  decoration: _inputDecoration(label: "E-Posta", icon: AppIcons.mail),
                ),
                const SizedBox(height: 16),

                // Şifre
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: AppColors.white),
                  decoration: _inputDecoration(label: "Şifre", icon: AppIcons.lock).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? AppIcons.see : AppIcons.hide, color: AppColors.white),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Şifre tekrar
                TextField(
                  controller: confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: const TextStyle(color: AppColors.white),
                  decoration: _inputDecoration(label: "Şifre (Tekrar)", icon: AppIcons.lock).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? AppIcons.see : AppIcons.hide, color: AppColors.white),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Genel hata mesajı
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 24),

                // Kayıt Ol butonu
                ElevatedButton(
                  onPressed: isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Kayıt Ol", style: TextStyle(color: AppColors.white, fontSize: 16)),
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

                const SizedBox(height: 24),

                // Giriş Yap yönlendirme
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Zaten hesabın var mı?",
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.login);
                      },
                      child: const Text(
                        "Giriş Yap",
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
