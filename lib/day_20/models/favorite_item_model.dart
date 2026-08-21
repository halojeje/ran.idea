import 'package:flutter/material.dart';

class FavoriteItem {
  final String id;
  final String category;
  final String title;
  final String theme;
  final String supergraphics;
  final String imagePath;
  final List<Color> colors;
  final List<String> hexColors;

  FavoriteItem({
    required this.id,
    required this.category,
    required this.title,
    required this.theme,
    required this.supergraphics,
    required this.imagePath,
    required this.colors,
    required this.hexColors,
  });
}
