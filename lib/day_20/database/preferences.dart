import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static const String keyIsLogin = 'is_login';
  static const String keyUserEmail = 'user_email';
  static const String keyUserName = 'user_name';
  static const String keyProfileImage = 'profile_image_path';

  // --- SESSION LOGIN & EMAIL ---
  static Future<void> saveLoginSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsLogin, true);
    await prefs.setString(keyUserEmail, email);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLogin) ?? false;
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserEmail);
  }

  // --- SIMPAN & AMBIL NAMA USER (Dari Register/Login) ---
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUserName, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserName);
  }

  // --- SIMPAN & AMBIL FOTO PROFIL (Path Gambar Galeri) ---
  static Future<void> saveProfileImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyProfileImage, imagePath);
  }

  static Future<String?> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyProfileImage);
  }

  // --- LOGOUT / CLEAR SESSION ---
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
