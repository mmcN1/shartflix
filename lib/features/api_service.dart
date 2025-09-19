import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://caseapi.servicelabs.tech";

  // Profil bilgisini GET ile al ve SharedPreferences'e kaydet
  static Future<Map<String, dynamic>?> getProfile(String token) async {
    final url = Uri.parse("$baseUrl/user/profile");

    try {
      final response = await http.get(
        url,
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded["data"]; // asıl veriler burada

        // Cache
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("name", data["name"] ?? "");
        await prefs.setString("email", data["email"] ?? "");
        await prefs.setString("photoUrl", data["photoUrl"] ?? "");
        await prefs.setString("token", data["token"] ?? "");

        return data;
      } else {
        print("Hata: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("İstek hatası: $e");
      return null;
    }
  }

  // Kaydedilen verileri oku
  static Future<Map<String, String?>> getSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "name": prefs.getString("name"),
      "email": prefs.getString("email"),
      "photoUrl": prefs.getString("photoUrl"),
    };
  }

  static Future<Map<String, dynamic>?> getMovies({int page = 1, String? token}) async {
    final url = Uri.parse("$baseUrl/movie/list?page=$page");

    try {
      final headers = {
        "accept": "application/json",
      };

      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Hata: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("İstek hatası: $e");
      return null;
    }
  }
  static Future<bool> favoriteMovie(String token, String movieId) async {
    final url = Uri.parse("$baseUrl/movie/favorite/$movieId");

    try {
      final response = await http.post(
        url,
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return true; // Başarılı
      } else {
        print("Favori ekleme hatası: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Favori isteği hatası: $e");
      return false;
    }
  }

  static Future<List<Map<String, String>>> getFavoriteMovies(String token) async {
    final url = Uri.parse("$baseUrl/movie/favorites");

    try {
      final response = await http.get(
        url,
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );


      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List data = decoded["data"] ?? []; // <- Burayı düzelttik
        print("Favori filmler decode: $data");

        return data.map<Map<String, String>>((movie) {
          return {
            "id": movie["id"] ?? "",
            "title": movie["Title"] ?? "Bilinmeyen",
            "poster": movie["Poster"] ?? "assets/placeholder.png",
            "year": movie["Year"] ?? "Açıklama yok",
          };
        }).toList();
      } else {
        print("Favori çekme hatası: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      print("Favori isteği hatası: $e");
      return [];
    }
  }
}

