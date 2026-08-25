import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ran_idea_flutter/day_20/database/preferences.dart';
import 'package:ran_idea_flutter/day_20/models/favorite_item_model.dart';
import 'package:ran_idea_flutter/day_20/providers/favorite_provider.dart';
import 'package:ran_idea_flutter/day_20/views/loginpage.dart';

class Favoritpage extends StatefulWidget {
  const Favoritpage({super.key});

  @override
  State<Favoritpage> createState() => _FavoritpageState();
}

class _FavoritpageState extends State<Favoritpage> {
  String _userEmail = 'Loading...';
  String _userName = 'User';
  String? _profileImagePath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  // EDIT FOTO PROFIL //
  Future<void> _pickProfileImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        await PreferenceHelper.saveProfileImage(pickedFile.path);
        setState(() {
          _profileImagePath = pickedFile.path;
        });
      }
    } catch (e) {
      debugPrint("Error picking profile image: $e");
    }
  }

  // HAPUS FOTO PROFIL //
  Future<void> _deleteProfileImage() async {
    await PreferenceHelper.saveProfileImage(''); // Kosongkan path di Preference
    setState(() {
      _profileImagePath = null;
    });
  }

  // MODAL BOTTOM OPSI EDIT & HAPUS //
  void _showProfileImagePickerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Foto Profil",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _pickProfileImage(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.photo_library),
                      label: Text(
                        "Galeri",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _pickProfileImage(ImageSource.camera);
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: Text(
                        "Kamera",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (_profileImagePath != null &&
                        _profileImagePath!.isNotEmpty)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteProfileImage();
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: Text(
                          "Hapus",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // MEMUAT DATA SESI PENGGUNA //
  Future<void> _loadUserData() async {
    final email = await PreferenceHelper.getEmail();
    final savedName = await PreferenceHelper.getUserName();
    final savedImage = await PreferenceHelper.getProfileImage();

    if (mounted) {
      setState(() {
        _userEmail = email ?? 'No Email';
        if (savedName != null && savedName.isNotEmpty) {
          _userName = savedName;
        } else if (email != null && email.contains('@')) {
          final prefix = email.split('@').first;
          _userName = prefix[0].toUpperCase() + prefix.substring(1);
        } else {
          _userName = 'User';
        }
        _profileImagePath = savedImage;
      });
    }
  }

  // LOGOUT USER //
  Future<void> _logout() async {
    await PreferenceHelper.clearSession();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  // MODAL DIALOG INFO CARD FAVORIT //
  void _showDetailDialog(
    BuildContext context,
    FavoriteItem item,
    FavoriteProvider favoriteProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black, width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(6, 6),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, right: 12),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelText("OUTPUT"),
                        _buildValueText(item.category),
                        const SizedBox(height: 12),

                        _buildLabelText("CONCEPT TITLE"),
                        _buildValueText(item.title),
                        const SizedBox(height: 12),

                        _buildLabelText("THEME"),
                        _buildValueText(item.theme),
                        const SizedBox(height: 12),

                        _buildLabelText("SUPERGRAPHICS"),
                        _buildValueText(item.supergraphics),
                        const SizedBox(height: 12),

                        Container(
                          height: 130,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: Colors.grey[200]),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildLabelText("COLOR PALETTE"),
                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(item.colors.length, (index) {
                            final color = item.colors[index];
                            final hex = item.hexColors.length > index
                                ? item.hexColors[index]
                                : '#000000';
                            return Column(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black26,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  hex,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.share_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Membagikan ${item.title}..."),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          favoriteProvider.removeFavorite(item.id);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabelText(String text) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 10,
        color: Colors.grey[400],
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildValueText(String text) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildProfileAvatar({
    double radius = 18,
    double imageSize = 36,
    bool isEditable = false,
  }) {
    final double appleSize = imageSize == 36 ? 32 : (imageSize * 32 / 36);
    return GestureDetector(
      onTap: isEditable ? _showProfileImagePickerModal : null,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: ClipOval(
          child:
              _profileImagePath != null &&
                  _profileImagePath!.isNotEmpty &&
                  File(_profileImagePath!).existsSync()
              ? Image.file(
                  File(_profileImagePath!),
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'assets/images/apple.png',
                  width: appleSize,
                  height: appleSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => CircleAvatar(
                    radius: radius - 2,
                    backgroundColor: Colors.grey[400],
                    child: Icon(
                      Icons.person,
                      size: imageSize * 0.6,
                      color: Colors.black,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favoriteItems = favoriteProvider.favoriteItems;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BG YELLOW BANNER //
            Container(
              color: const Color(0xFFFFC107),
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: 36,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "RAN.IDEA",
                        style: TextStyle(
                          fontFamily: 'Montserrat-Black',
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: Colors.black,
                        ),
                      ),
                      _buildProfileAvatar(radius: 18, imageSize: 36),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 2. KARTU USER PROFIL
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black, width: 2.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(4, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildProfileAvatar(
                          radius: 36,
                          imageSize: 72,
                          isEditable: true,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _userName,
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _userEmail,
                                style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _logout,
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: Colors.redAccent,
                            size: 24,
                          ),
                          tooltip: "Logout",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // IDE FAVORIT //
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "IDE FAVORIT",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // CARD FAVORIT IN EMPTY STATE //
                    favoriteItems.isEmpty
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.black, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(3, 3),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Belum ada ide favorit yang disimpan",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: favoriteItems.length,
                            itemBuilder: (context, index) {
                              final item = favoriteItems[index];
                              return _buildFavoriteCard(
                                context,
                                item,
                                favoriteProvider,
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CARD ITEM FAVORIT //
  Widget _buildFavoriteCard(
    BuildContext context,
    FavoriteItem item,
    FavoriteProvider favoriteProvider,
  ) {
    return GestureDetector(
      onTap: () => _showDetailDialog(context, item, favoriteProvider),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 2.5),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TITLE",
                      style: GoogleFonts.montserrat(
                        fontSize: 9,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.title,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC107),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: Text(
                        item.category.toUpperCase(),
                        style: GoogleFonts.montserrat(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                    icon: const Icon(
                      Icons.share_outlined,
                      size: 22,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Membagikan ${item.title}..."),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 22,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      favoriteProvider.removeFavorite(item.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
