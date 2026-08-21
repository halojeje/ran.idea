import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Katalogsgpage extends StatelessWidget {
  const Katalogsgpage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy supergraphics
    final List<Map<String, String>> supergraphicsData = [
      {
        "title": "Bold Geometric",
        "image": "assets/images/supergraphics/sg_boldgeometric.png",
      },
      {
        "title": "Gradient Wash",
        "image": "assets/images/supergraphics/sg_gradientwash.png",
      },
      {
        "title": "Optical Illusion",
        "image": "assets/images/supergraphics/sg_opticalillusion.png",
      },
      {
        "title": "Typowayfinding",
        "image": "assets/images/supergraphics/sg_typowayfinding.png",
      },
      {
        "title": "Illustrative Mural",
        "image": "assets/images/supergraphics/sg_illustrativemural.png",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Teks sebelum Card Grid
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            "Supergraphic (atau supergrafis) adalah elemen visual berskala besar yang diturunkan dari identitas merek—seperti bentuk logo, warna, atau pola—dan digunakan sebagai ciri khas pendukung untuk memperkuat citra merek agar mudah diingat tanpa harus selalu menampilkan logo utamanya.",
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),

        SizedBox(height: 10),

        // Grid Card yang dibungkus Expanded agar scrollable
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: supergraphicsData.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final item = supergraphicsData[index];
              return _buildSgCard(item["title"]!, item["image"]!);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSgCard(String title, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Transform.translate(
        offset: const Offset(-4, -4),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
