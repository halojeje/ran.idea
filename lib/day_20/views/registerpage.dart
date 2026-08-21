import 'package:flutter/material.dart';
import 'package:ran_idea_flutter/day_20/database/dbhelper.dart';
import 'package:ran_idea_flutter/day_20/database/preferences.dart';
import 'package:ran_idea_flutter/day_20/models/usermodel.dart';
import 'package:ran_idea_flutter/day_20/views/loginpage.dart';
import 'package:ran_idea_flutter/extensions/main_navigation.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController namaC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController nomorHpC = TextEditingController();
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
      // Sembunyikan teks error bawaan InputDecoration agar tidak dirender di dalam kotak
      errorStyle: const TextStyle(height: 0, fontSize: 0),
    );
  }

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    final namaClean = namaC.text.trim();
    final emailClean = emailC.text.trim();
    final passwordClean = passwordC.text.trim();

    final user = UserModelSQL(
      nama: namaClean,
      email: emailClean,
      nomorHp: nomorHpC.text.trim(),
      password: passwordClean,
    );

    final success = await dbHelper.registerUser(user);

    if (!mounted) return;

    if (success) {
      await PreferenceHelper.saveLoginSession(emailClean);
      await PreferenceHelper.saveUserName(namaClean);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi Berhasil! Selamat datang.')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi Gagal! Email mungkin sudah digunakan.'),
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
                const SizedBox(height: 10),
                Image.asset(
                  'assets/images/tes_logo.png',
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.flash_on, size: 50, color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text(
                  'CREATE ACCOUNT',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Sign up to get full access',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 25),

                // 1. NAMA FIELD
                _buildFieldWithExternalError(
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Nama tidak boleh kosong'
                      : null,
                  builder: (validator) => TextFormField(
                    controller: namaC,
                    decoration: _buildInputDecoration(
                      'Nama Lengkap',
                      Icons.person_outline,
                    ),
                    validator: validator,
                  ),
                ),
                const SizedBox(height: 12),

                // 2. EMAIL FIELD
                _buildFieldWithExternalError(
                  validator: (v) => v == null || !v.contains('@')
                      ? 'Email tidak valid'
                      : null,
                  builder: (validator) => TextFormField(
                    controller: emailC,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _buildInputDecoration(
                      'Email',
                      Icons.email_outlined,
                    ),
                    validator: validator,
                  ),
                ),
                const SizedBox(height: 12),

                // 3. NOMOR HP FIELD
                _buildFieldWithExternalError(
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Nomor HP tidak boleh kosong'
                      : null,
                  builder: (validator) => TextFormField(
                    controller: nomorHpC,
                    keyboardType: TextInputType.phone,
                    decoration: _buildInputDecoration(
                      'Nomor HP',
                      Icons.phone_outlined,
                    ),
                    validator: validator,
                  ),
                ),
                const SizedBox(height: 12),

                // 4. PASSWORD FIELD
                _buildFieldWithExternalError(
                  validator: (v) => v == null || v.length < 6
                      ? 'Password minimal 6 karakter'
                      : null,
                  builder: (validator) => TextFormField(
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
                    validator: validator,
                  ),
                ),
                const SizedBox(height: 20),

                // BUTTON REGISTER
                Container(
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
                    onPressed: registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB703),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text(
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // LOGIN LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login Here',
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

  // WIDGET PEMBUNGKUS DENGAN TEKS ERROR DI LUAR KOTAK
  Widget _buildFieldWithExternalError({
    required FormFieldValidator<String> validator,
    required Widget Function(FormFieldValidator<String>) builder,
  }) {
    return FormField<String>(
      validator: validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kotak Putih & Border
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: state.hasError ? Colors.deepOrange : Colors.black,
                  width: 3,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: builder((val) {
                final result = validator(val);
                state.didChange(val);
                return result;
              }),
            ),
            // Teks error di luar kotak
            if (state.hasError) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
