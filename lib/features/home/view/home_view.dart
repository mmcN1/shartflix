import 'package:flutter/material.dart';
import 'package:shartflix/features/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shartflix/core/resources/app_icons.dart';
import 'package:shartflix/core/routes/app_routes.dart';

class HomeView extends StatefulWidget {
  final String currentPage;

  const HomeView({super.key, this.currentPage = "home"});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Map<String, dynamic>> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<void> _loadMovies({int page = 1}) async {
    final token = await _getToken();
    final response = await ApiService.getMovies(token: token, page: page);

    if (response != null && mounted) {
      final movieList = (response["data"]?["movies"] as List<dynamic>?) ?? [];

      setState(() {
        movies.addAll(
          movieList.map(
            (m) => {
              ...m,
              "isFavorite": false,
              "title": m["Title"], // API'deki Title alanını kullan
              "description": m["Plot"], // API'deki Plot alanını kullan
              "posterUrl": m["Poster"], // API'deki Poster alanını kullan
            },
          ),
        );
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  String currentPage = AppRoutes.home;


  void _toggleFavorite(int index) async {
    final movie = movies[index];
    final movieId = movie["id"];
    final token = await _getToken();

    if (token == null) return;

    // POST isteği at
    final success = await ApiService.favoriteMovie(token, movieId);

    if (success) {
      // Başarılı ise favori state’i true yap
      setState(() {
        movies[index]["isFavorite"] = true;
        print("Favori eklendi $movieId");
      });
    } else {
      // Başarısızsa kullanıcıya bir mesaj gösterebilirsin
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favori eklenemedi, tekrar deneyin.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      // BoxDecoration gradient ve diğer dekorları koruyoruz
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Network image + placeholder
                          Positioned.fill(
                            child: Image.network(
                              movie["posterUrl"],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  color: Colors.black,
                                  "assets/placeholder.png",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),

                          // Favori ikonu
                          Positioned(
                            top: 40,
                            right: 20,
                            child: IconButton(
                              icon: Icon(
                                movie["isFavorite"]
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                                size: 32,
                              ),
                              onPressed: () => _toggleFavorite(index),
                            ),
                          ),

                          // Film bilgileri
                          Positioned(
                            left: 20,
                            right: 20,
                            bottom: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie["title"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movie["description"],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Navbar (en altta sabit)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
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
