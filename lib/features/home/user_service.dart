import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static Future<void> saveUserData(String name, String photoUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('photoUrl', photoUrl);
  }

  static Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "name": prefs.getString('name') ?? "Kullanıcı",
      "photoUrl": prefs.getString('photoUrl') ?? "",
    };
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
