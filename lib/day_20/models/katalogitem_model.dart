class KatalogItem {
  final String title;
  final String description;
  final String image;
  final List<String> tags;
  final String? output;

  const KatalogItem({
    required this.title,
    required this.description,
    required this.image,
    required this.tags,
    this.output,
  });
}
