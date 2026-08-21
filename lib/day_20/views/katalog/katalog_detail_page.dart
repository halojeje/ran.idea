import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ran_idea_flutter/day_20/database/preferences.dart';
import 'package:ran_idea_flutter/day_20/models/katalogitem_model.dart';

class KatalogDetailPage extends StatefulWidget {
  final KatalogItem item;

  const KatalogDetailPage({super.key, required this.item});

  @override
  State<KatalogDetailPage> createState() => _KatalogDetailPageState();
}

class _KatalogDetailPageState extends State<KatalogDetailPage> {
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final imagePath = await PreferenceHelper.getProfileImage();
    if (mounted && imagePath != null) {
      setState(() {
        _profileImagePath = imagePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // 1. Header Banner Yellow
            Container(
              color: const Color(0xFFFFC107),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
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
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child:
                                _profileImagePath != null &&
                                    File(_profileImagePath!).existsSync()
                                ? Image.file(
                                    File(_profileImagePath!),
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/apple.png',
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Colors.grey[400],
                                              child: const Icon(
                                                Icons.person,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Back Button Header
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "DETAIL STYLES",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // 3. Detail Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Utama
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(4, 4),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        item.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Judul
                    Text(
                      item.title,
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tags
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: item.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9BF1F4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Text(
                            tag.toUpperCase(),
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Deskripsi
                    Text(
                      item.description,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
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
}
