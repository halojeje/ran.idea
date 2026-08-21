class KatalogItem {
  final String title;
  final String description;
  final String image;
  final List<String>
  tags; // <--- Ditambahkan agar sesuai dengan data_katalogitem_2.dart
  final String?
  output; // <--- Dibuat opsional (nullable) jika masih ingin menyimpan data lama

  const KatalogItem({
    required this.title,
    required this.description,
    required this.image,
    required this.tags, // <--- Ditambahkan di konstruktor
    this.output,
  });
}
