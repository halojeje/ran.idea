import 'package:flutter/material.dart';
import 'package:ran_idea_flutter/ran_idea/database/dbhelper.dart';
import 'package:ran_idea_flutter/ran_idea/database/preferences.dart';
import 'package:ran_idea_flutter/ran_idea/views/registerpage.dart';
import 'package:ran_idea_flutter/extensions/main_navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DBHelper dbHelper = DBHelper();

  bool obscurePassword = true;

  InputDecoration _buildInputDecoration(String hintText, IconData prefixIcon) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: Colors.black),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
    );
  }

  // FUNGSI LOGIN DENGAN PENYIMPANAN SESI NAMA & EMAIL
  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    final emailInput = emailC.text.trim();
    final passwordInput = passwordC.text.trim();

    // Query ke database lokal
    final user = await dbHelper.loginUser(emailInput, passwordInput);

    if (!mounted) return;

    if (user != null) {
      // 1. Simpan Sesi Email & Nama Pengguna dari DB ke Preferences
      await PreferenceHelper.saveLoginSession(emailInput);
      await PreferenceHelper.saveUserName(user.nama);

      if (!mounted) return;

      // 2. Navigasi Langsung ke MainNavigation (Mengaktifkan Bottom Navigation)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email/Password Salah atau Akun Belum Terdaftar!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFB703),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/tes_logo.png',
                  width: 60,
                  height: 60,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.flash_on, size: 60, color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text(
                  'WELCOME BACK!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Sign in to continue your ideas',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),

                // EMAIL INPUT
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: emailC,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _buildInputDecoration(
                      'Email',
                      Icons.email_outlined,
                    ),
                    validator: (v) => v == null || !v.contains('@')
                        ? 'Email tak valid'
                        : null,
                  ),
                ),

                const SizedBox(height: 15),

                // PASSWORD INPUT
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: passwordC,
                    obscureText: obscurePassword,
                    decoration:
                        _buildInputDecoration(
                          'Password',
                          Icons.lock_outline,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 25),

                // BUTTON LOGIN
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB703),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'LOG IN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // REGISTER LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register Here',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
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
