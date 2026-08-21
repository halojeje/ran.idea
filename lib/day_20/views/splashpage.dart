import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ran_idea_flutter/day_20/database/preferences.dart';
import 'package:ran_idea_flutter/day_20/views/loginpage.dart';
import 'package:ran_idea_flutter/extensions/main_navigation.dart'; // Impor MainNavigation

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  void _startSplashScreen() async {
    // 1. Tentukan berapa lama Splash Screen tampil (3 detik)
    var duration = const Duration(seconds: 3);

    Timer(duration, () async {
      // 2. Cek status login dari SharedPreferences
      bool isLogin = await PreferenceHelper.isLoggedIn();

      if (!mounted) return;

      // 3. Navigasi ke halaman yang sesuai
      // DIUBAH: Jika login, arahkan ke MainNavigation agar BottomNavigationBar aktif
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isLogin ? const MainNavigation() : const LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan warna tema Neo Brutalism
      backgroundColor: const Color(0xFFFFB703),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Aplikasi
            Image.asset(
              'assets/images/tes_logo.png',
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.flash_on, size: 80, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Nama Aplikasi
            const Text(
              'RAN.IDEA',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                letterSpacing: 1.5,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),

            // Loading Indicator
            const CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
