import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shartflix/core/resources/app_colors.dart';
import 'package:shartflix/core/resources/app_icons.dart';
import 'package:shartflix/core/routes/app_routes.dart';
import 'package:shartflix/features/photo/profile_photo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shartflix/features/api_service.dart';

class ProfilePhotoPage extends StatefulWidget {
  final String? photoUrl;

  const ProfilePhotoPage({super.key, this.photoUrl});

  @override
  State<ProfilePhotoPage> createState() => _ProfilePhotoPageState();
}

class _ProfilePhotoPageState extends State<ProfilePhotoPage> {
  File? _selectedImage;
  String photoUrl = "";
  String userToken = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token != null && token.isNotEmpty) {
      final data = await ApiService.getProfile(token); // API çağrısı

      if (data != null) {
        setState(() {
          photoUrl = data["photoUrl"] ?? "";
          userToken = data["token"] ?? "";
          prefs.setString("photoUrl", photoUrl);
        });
      }
    } else {
      print("Token yok, kullanıcı giriş yapmamış!");
    }
  }



  Future<void> _pickImage() async {
    final image = await ProfileService.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _uploadPhotoAndContinue() async {
    if (_selectedImage != null) {
      bool success = await ProfileService.uploadPhoto(_selectedImage!, userToken);
      debugPrint(success ? "Fotoğraf başarıyla yüklendi." : "Fotoğraf yüklenemedi.");
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          colors: [AppColors.primary, AppColors.background],
          stops: [0.2, 1.0],
          radius: 0.9,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Center(
            child: Container(
              width: 60,
              height: 45,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.white.withOpacity(0.3), width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.profile,
                        (route) => false,
                  );
                },
              ),
            ),
          ),
          title: const Text(
            "Profil Detayı",
            style: TextStyle(color: AppColors.white),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(AppIcons.profileFill, size: 80, color: AppColors.white),
              const SizedBox(height: 12),
              const Text("Fotoğraf Yükle",
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text(
                "Profil fotoğrafın için görsel yükleyebilirsin",
                style: TextStyle(color: AppColors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (_selectedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(_selectedImage!,
                      width: 200, height: 200, fit: BoxFit.cover),
                )
              else if (photoUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(photoUrl,
                      width: 200, height: 200, fit: BoxFit.cover),
                )
              else
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.add_a_photo,
                        size: 40, color: AppColors.white),
                  ),
                ),
              const SizedBox(height: 16),
              if (_selectedImage != null || photoUrl.isNotEmpty)
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.white, width: 0.5),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.close,
                        color: AppColors.white, size: 24),
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _uploadPhotoAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Devam Et",
                      style: TextStyle(color: AppColors.white)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                          (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.transparent),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Atla",
                      style: TextStyle(color: AppColors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
