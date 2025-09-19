import 'package:flutter/material.dart';
import 'package:shartflix/core/routes/app_routes.dart';
import 'package:shartflix/core/resources/app_colors.dart';
import 'package:shartflix/core/resources/app_icons.dart';
import 'package:shartflix/features/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String currentPage = AppRoutes.profile;
  String username = "";
  String userId = "";
  String profilePhoto = "";
  List<Map<String, String>> favoriteMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    final profileData = await ApiService.getProfile(token);
    final movies = await ApiService.getFavoriteMovies(token);

    setState(() {
      username = profileData?["name"] ?? "Mehmet";
      userId = profileData?["id"]?.toString() ?? "123456";
      profilePhoto = profileData?["photoUrl"] ?? "";
      favoriteMovies = movies;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Profil",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              AppIcons.gem,
              color: Colors.white,
            ),
            label: const Text(
              "Sınırlı Teklif",
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Stack(
        children: [
          // Gradient arka plan
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.redColor, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profil bilgileri
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: profilePhoto.isNotEmpty
                            ? NetworkImage(profilePhoto)
                            : const AssetImage("assets/placeholder.png")
                        as ImageProvider,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "ID: $userId",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black54.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pushNamed(
                          context,
                          AppRoutes.profilePhoto,
                        ),
                        child: const Text(
                          "Fotoğraf Ekle",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Favori filmler Grid
                  Expanded(
                    child: isLoading
                        ? GridView.builder(
                      itemCount: 6,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[800]!,
                          highlightColor: Colors.grey[600]!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    )
                        : favoriteMovies.isEmpty
                        ? const Center(
                      child: Text(
                        "Favori film yok",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                        : GridView.builder(
                      itemCount: favoriteMovies.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final movie = favoriteMovies[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius:
                                  const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: movie["poster"] ?? "",
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Image.asset(
                                          "assets/placeholder.png",
                                          fit: BoxFit.cover,
                                        ),
                                    errorWidget:
                                        (context, url, error) =>
                                        Image.asset(
                                          "assets/placeholder.png",
                                          fit: BoxFit.cover,
                                        ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                child: Text(
                                  movie["title"] ?? "Bilinmeyen",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 3.0, left: 8.0, right: 8.0),
                                  child: Text(
                                    movie["year"] ?? "Açıklama yok",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Navbar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _navButton(
                        context,
                        "Anasayfa",
                        AppRoutes.home,
                        currentPage,
                        AppIcons.home,
                        AppIcons.homeFill,
                      ),
                      _navButton(
                        context,
                        "Profil",
                        AppRoutes.profile,
                        currentPage,
                        AppIcons.profile,
                        AppIcons.profileFill,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton(
      BuildContext context,
      String label,
      String page,
      String currentPage,
      IconData icon,
      IconData filledIcon,
      ) {
    final bool isSelected = page == currentPage;

    return GestureDetector(
      onTap: () {
        if (page != currentPage) {
          Navigator.pushNamedAndRemoveUntil(context, page, (route) => false);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.withOpacity(0.7) : Colors.transparent,
          border: Border.all(color: isSelected ? Colors.red.withOpacity(0.7) : Colors.white, width: 1),
          borderRadius: BorderRadius.circular(36), // border radius
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24), // border radius
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isSelected ? filledIcon : icon, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
