import 'package:ran_idea_flutter/day_20/models/katalogitem_model.dart';

class TextKatalogItemData {
  TextKatalogItemData._();

  static const List<KatalogItem> styles = [
    KatalogItem(
      title: 'Japandi',
      description:
          'Perpaduan harmonis antara Japanese minimalism dan Scandinavian functionality. Gaya interior ini menekankan kesederhanaan, garis bersih, material alami (kayu terang), palet warna netral yang hangat, dan kenyamanan (konsep hygge Skandinavia dan wabi-sabi Jepang).',
      image: 'assets/images/design/d_japandi.jpg',
      tags: ['Minimalist', 'Organic', 'Modern'],
    ),
    KatalogItem(
      title: 'Bauhaus',
      description:
          'Gerakan desain dari Jerman (awal abad ke-20) yang menyatukan seni, kerajinan, dan teknologi. Prinsip utamanya adalah "form follows function" (bentuk mengikuti fungsi). Cirinya adalah bentuk geometris dasar, warna primer, tata letak grid, keteraturan, dan penolakan ornamen berlebihan.',
      image: 'assets/images/design/d_bauhaus.jpg',
      tags: ['Modern', 'Geometry', 'Functional'],
    ),
    KatalogItem(
      title: 'Utilitarian',
      description:
          'Desain yang murni berfokus pada kegunaan dan fungsionalitas praktis, seringkali mengabaikan estetika dekoratif. Populer dalam desain industri, arsitektur, dan fashion militer atau kerja, gaya ini menggunakan material tahan lama, bentuk yang efisien, dan struktur yang terekspos.',
      image: 'assets/images/design/d_utilitarian.jpg',
      tags: ['Functional', 'Industrial', 'Minimalist'],
    ),
    KatalogItem(
      title: 'Bento grid',
      description:
          'Gaya tata letak (layout) dalam desain grafis dan web yang terinspirasi dari kotak makan Bento Jepang. Elemen-elemen konten diatur dalam kotak-kotak persegi atau persegi panjang dengan ukuran berbeda yang disusun rapi dalam grid, menciptakan struktur yang bersih, terorganisir, dan mudah dipahami.',
      image: 'assets/images/design/d_bentogrid.jpg',
      tags: ['Digital', 'Layout', 'Modern'],
    ),
    KatalogItem(
      title: 'Pixel art',
      description:
          'Bentuk seni digital yang diciptakan dengan menyusun piksel demi piksel secara manual, meniru estetika video game klasik (8-bit dan 16-bit). Meskipun terbatas secara resolusi, gaya ini sangat ekspresif, memiliki nuansa nostalgia, dan menekankan ketepatan penempatan setiap titik warna.',
      image: 'assets/images/design/d_pixelart.jpg',
      tags: ['Digital', 'Retro', 'Gaming'],
    ),
    KatalogItem(
      title: 'Memphis',
      description:
          'Gaya desain postmodern dari Italia (tahun 1980-an) yang berani dan playful. Memphis menolak minimalis modern dengan menghadirkan pola geometris acak, warna-warna primer dan pastel yang cerah, bentuk yang tidak konvensional, serta kombinasi material yang tak terduga.',
      image: 'assets/images/design/d_memphis.jpg',
      tags: ['Postmodern', 'Playful', 'Geometry'],
    ),
    KatalogItem(
      title: 'Y2K',
      description:
          'Estetika retro-futuristik yang populer di sekitar tahun 1999-2003. Gaya ini mencerminkan optimisme terhadap teknologi milenium baru, ditandai dengan material mengilap (silver, krom), plastik transparan, warna neon/pastel cerah, bentuk futuristik, dan pengaruh budaya pop digital awal.',
      image: 'assets/images/design/d_y2k.jpg',
      tags: ['Retro', 'Digital', 'Futuristic'],
    ),
    KatalogItem(
      title: 'Pop art',
      description:
          'Gerakan seni (tahun 1950-an-1960-an) yang mengambil inspirasi dari budaya populer dan massa (komik, iklan, produk konsumen, selebriti). Cirinya adalah penggunaan warna kontras dan berani, teknik cetak industri (seperti titik Ben-Day), dan repetisi objek sehari-hari.',
      image: 'assets/images/design/d_popart.jpg',
      tags: ['Classic', 'Vibrant', 'Retro'],
    ),
    KatalogItem(
      title: 'Art Nouveau',
      description:
          'Gaya internasional (akhir abad ke-19) yang terinspirasi oleh bentuk-bentuk alam dan organik. Ditandai dengan garis melengkung yang mengalir (sinuous lines), pola tumbuhan/bunga yang rumit, asimetri, dan ornamen yang sangat dekoratif.',
      image: 'assets/images/design/d_artnouveau.jpg',
      tags: ['Classic', 'Organic', 'Decorative'],
    ),
    KatalogItem(
      title: 'Surrealism',
      description:
          'Gerakan seni yang mengeksplorasi alam bawah sadar, mimpi, dan fantasi. Dalam visualnya, Surrealism sering menampilkan kombinasi objek yang tidak logis dan aneh, distorsi realitas, pemandangan seperti mimpi yang ajaib, dan simbolisme yang mendalam.',
      image: 'assets/images/design/d_surrealism.jpg',
      tags: ['Abstract', 'Fantasy', 'Dreamy'],
    ),
    KatalogItem(
      title: 'Bohemian/Boho',
      description:
          'Gaya hidup dan desain yang mencerminkan jiwa bebas, eklektik, dan tidak konvensional. Boho memadukan tekstur kaya (kain tenun, karpet), pola etnik, warna-warni hangat, tanaman hias, dan barang-barang antik atau vintage dari berbagai budaya.',
      image: 'assets/images/design/d_boho.jpg',
      tags: ['Organic', 'Eclectic', 'Textured'],
    ),
    KatalogItem(
      title: 'Farmhouse/Cottagecore',
      description:
          'Farmhouse adalah gaya interior pedesaan yang modern, nyaman, dan praktis dengan material kayu mentah, warna netral, dan elemen rustic. Cottagecore adalah estetika digital/fashion yang lebih diidealisasikan tentang kehidupan pedesaan yang damai, menampilkan motif bunga, pakaian renda, dan kegiatan kerajinan tangan.',
      image: 'assets/images/design/d_farmhouse.jpg',
      tags: ['Rustic', 'Cozy', 'Organic'],
    ),
    KatalogItem(
      title: 'Coquette',
      description:
          'Estetika fashion dan gaya hidup yang menekankan femininitas yang genit, lembut, dan romantis. Ditandai dengan penggunaan pita, renda, warna pastel, motif bunga kecil, rok mini, kerah Peter Pan, dan perhiasan mutiara.',
      image: 'assets/images/design/d_coquette.jpg',
      tags: ['Feminine', 'Soft', 'Romantic'],
    ),
    KatalogItem(
      title: 'Graffiti',
      description:
          'Bentuk ekspresi artistik yang dibuat di ruang publik, biasanya menggunakan cat semprot. Meskipun sering dianggap vandalisme, Graffiti memiliki gaya visual yang kuat dengan tipografi yang rumit dan tumpang tindih, warna kontras, karakter kartun, dan pesan sosial atau politik.',
      image: 'assets/images/design/d_graffiti.jpg',
      tags: ['Urban', 'Street-Art', 'Bold'],
    ),
    KatalogItem(
      title: 'Cybercore',
      description:
          'Gaya retro-futuristik yang terinspirasi oleh teknologi digital awal, hacker, dan internet tahun 1990-an/awal 2000-an. Visualnya menampilkan palet warna gelap dengan aksen neon (terutama hijau), grafik komputer kuno, teks monospaced, dan material teknis (plastik, logam).',
      image: 'assets/images/design/d_cybercore.jpg',
      tags: ['Digital', 'Futuristic', 'Tech'],
    ),
    KatalogItem(
      title: 'Vaporwave',
      description:
          'Estetika seni digital dan musik yang sarat nostalgia, surealisme, dan kritik terhadap konsumerisme tahun 1980-an/1990-an. Visualnya memadukan patung klasik Romawi, grafik komputer awal, pemandangan pantai tropis, warna pastel neon (merah muda, biru), dan logo merek kuno.',
      image: 'assets/images/design/d_vaporwave.jpg',
      tags: ['Digital', 'Retro', 'Nostalgic'],
    ),
    KatalogItem(
      title: 'Scrapbook/Collage',
      description:
          'Teknik desain yang menyusun berbagai potongan material (foto, kertas, kain, tulisan tangan) menjadi satu komposisi baru. Gaya ini menciptakan kesan buatan tangan, personal, dan eklektik dengan tekstur yang kaya dan lapisan konten yang tumpang tindih.',
      image: 'assets/images/design/d_scrapbookcollage.jpg',
      tags: ['Handmade', 'Mixed-Media', 'Textured'],
    ),
    KatalogItem(
      title: 'Brutalism',
      description:
          'Gaya arsitektur dan desain (pertengahan abad ke-20) yang menampilkan struktur yang jujur, mentah, dan masif, terutama menggunakan beton ekspos. Brutalism menolak dekorasi, menekankan bentuk geometris yang kuat, fungsionalitas kaku, dan kesan "berat".',
      image: 'assets/images/design/d_brutalism.jpg',
      tags: ['Modern', 'Raw', 'Industrial'],
    ),
    KatalogItem(
      title: 'Kitsch',
      description:
          'Istilah untuk seni atau desain yang dianggap memiliki selera rendah, vulgar, atau terlalu sentimental, namun sering kali dinikmati secara ironis atau karena keunikannya. Kitsch ditandai dengan repetisi objek murah, warna yang terlalu norak, dan ornamen yang berlebihan.',
      image: 'assets/images/design/d_kitsch.jpg',
      tags: ['Playful', 'Retro', 'Eccentric'],
    ),
    KatalogItem(
      title: 'Mixed Media',
      description:
          'Gaya desain ini menggabungkan berbagai media seperti foto, lukisan, dan kolase. Sering digunakan pada majalah, sampul album, dan visual iklan.',
      image: 'assets/images/design/d_mixedmedia.jpg',
      tags: ['Artistic', 'Textured', 'Layered'],
    ),
  ];
}
