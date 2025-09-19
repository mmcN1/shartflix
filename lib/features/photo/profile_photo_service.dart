import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class ProfileService {
  // Fotoğraf seç
  static Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Kullanıcı verilerini oku
  static Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "photoUrl": prefs.getString('photoUrl') ?? "",
      "token": prefs.getString('token') ?? "",
    };
  }

  // Fotoğrafı upload et
  static Future<bool> uploadPhoto(File imageFile, String token) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://caseapi.servicelabs.tech/user/upload_photo'),
      );

      // JWT token ekle
      request.headers['Authorization'] = 'Bearer $token';

      // Dosyayı ekle
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: MediaType('image', 'png'),
          filename: path.basename(imageFile.path),
        ),
      );

      // isteği gönder
      var response = await request.send();

      if (response.statusCode == 200) {
        // response'u string olarak al
        final respStr = await response.stream.bytesToString();
        print("Upload response: $respStr");

        final decoded = jsonDecode(respStr);

        // JSON yapısına göre değişebilir!
        // Eğer backend şu şekilde dönüyorsa:
        // { "data": { "photoUrl": "https://..." } }
        final newUrl = decoded["data"]?["photoUrl"];

        if (newUrl != null && newUrl.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("photoUrl", newUrl);
        }

        return true;
      } else {
        print("Upload failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Upload error: $e");
      return false;
    }
  }
}
