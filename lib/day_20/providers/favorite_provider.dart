import 'package:flutter/material.dart';
import 'package:ran_idea_flutter/day_20/models/favorite_item_model.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<FavoriteItem> _favoriteItems = [];

  List<FavoriteItem> get favoriteItems => _favoriteItems;

  // Cek apakah item sudah difavoritkan
  bool isFavorite(String id) {
    return _favoriteItems.any((item) => item.id == id);
  }

  // Tambah atau Hapus dari Favorit
  void toggleFavorite(FavoriteItem item) {
    final index = _favoriteItems.indexWhere((element) => element.id == item.id);
    if (index >= 0) {
      _favoriteItems.removeAt(index);
    } else {
      _favoriteItems.add(item);
    }
    notifyListeners(); // Mengabari UI (Favoritpage & Dashboardpage) untuk me-refresh tampilan
  }

  // Hapus berdasarkan ID
  void removeFavorite(String id) {
    _favoriteItems.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
