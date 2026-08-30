import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ran_idea_flutter/ran_idea/database/data_katalogitem.dart';
import 'package:ran_idea_flutter/ran_idea/database/preferences.dart';
import 'package:ran_idea_flutter/ran_idea/models/katalogitem_model.dart';
import 'package:ran_idea_flutter/ran_idea/views/katalog/katalog_detail_page.dart';
import 'package:ran_idea_flutter/ran_idea/views/katalogsgpage.dart';

class Katalogpage extends StatefulWidget {
  const Katalogpage({super.key});

  @override
  State<Katalogpage> createState() => _KatalogpageState();
}

class _KatalogpageState extends State<Katalogpage> {
  String _searchQuery = '';
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  // Reload foto profil setiap kali dependencies/halaman berubah/aktif kembali
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProfileImage();
  }

  // MEMUAT FOTO PROFIL SESI
  Future<void> _loadProfileImage() async {
    final imagePath = await PreferenceHelper.getProfileImage();
    if (mounted) {
      setState(() {
        _profileImagePath = imagePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter list berdasarkan pencarian
    final filteredStyles = TextKatalogItemData.styles.where((item) {
      return item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.tags.any(
            (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()),
          );
    }).toList();

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF9FAFC),
          body: Column(
            children: [
              // 1. Header Yellow Banner + TabBar
              Container(
                color: const Color(0xFFFFC107),
                child: Column(
                  children: [
                    // Header Logo & Avatar Sesi
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
                                      _profileImagePath!.isNotEmpty &&
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
                                                backgroundColor:
                                                    Colors.grey[400],
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

                    // TAB BAR (DESIGN STYLES & SUPERGRAPHICS)
                    Container(
                      color: const Color(0xFFFFC107),
                      child: TabBar(
                        indicatorColor: Colors.black,
                        indicatorWeight: 3,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black54,
                        labelStyle: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: const [
                          Tab(text: "DESIGN STYLES"),
                          Tab(text: "SUPERGRAPHICS"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // TAB BAR VIEWS
              Expanded(
                child: TabBarView(
                  children: [
                    // TAB 1: DESIGN STYLES
                    Column(
                      children: [
                        // Search Bar Section
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(2, 2),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: "Cari gaya desain (e.g. Bauhaus)...",
                                hintStyle: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  color: Colors.grey[500],
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // List Katalog Design Styles
                        Expanded(
                          child: filteredStyles.isEmpty
                              ? Center(
                                  child: Text(
                                    "Gaya desain tidak ditemukan",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: filteredStyles.length,
                                  itemBuilder: (context, index) {
                                    final item = filteredStyles[index];
                                    return _buildKatalogCard(context, item);
                                  },
                                ),
                        ),
                      ],
                    ),

                    // TAB 2: SUPERGRAPHICS PAGE
                    const Katalogsgpage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKatalogCard(BuildContext context, KatalogItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KatalogDetailPage(item: item),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Gambar Katalog
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Image.asset(
                      item.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Detail Teks Katalog
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: item.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9BF1F4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag.toUpperCase(),
                              style: GoogleFonts.montserrat(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.black,
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
