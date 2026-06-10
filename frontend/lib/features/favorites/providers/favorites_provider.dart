import 'package:flutter/material.dart';
import 'package:le_nhat_truong/features/shop/models/product.dart';

class FavoriteItem {
  final Product product;
  final String selectedSize;
  final String selectedColor;
  final bool isSoldOut;

  FavoriteItem({
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    this.isSoldOut = false,
  });
}

class FavoritesProvider extends ChangeNotifier {
  final List<FavoriteItem> _favorites = [];

  List<FavoriteItem> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String productId) {
    return _favorites.any((item) => item.product.id == productId);
  }

  void addFavorite(Product product, String size, String color) {
    // Remove existing entry if any (to update size/color)
    _favorites.removeWhere((item) => item.product.id == product.id);
    _favorites.add(FavoriteItem(
      product: product,
      selectedSize: size,
      selectedColor: color,
      isSoldOut: product.quantity == 0,
    ));
    notifyListeners();
  }

  void removeFavorite(String productId) {
    _favorites.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void toggle(Product product, String size, String color) {
    if (isFavorite(product.id)) {
      removeFavorite(product.id);
    } else {
      addFavorite(product, size, color);
    }
  }

  int get count => _favorites.length;
}
