import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'isSoldOut': isSoldOut,
    };
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      product: Product.fromJson(json['product']),
      selectedSize: json['selectedSize'] ?? '',
      selectedColor: json['selectedColor'] ?? '',
      isSoldOut: json['isSoldOut'] ?? false,
    );
  }
}

class FavoritesProvider extends ChangeNotifier {
  final List<FavoriteItem> _favorites = [];
  static const String _prefKey = 'favorites_list';

  List<FavoriteItem> get favorites => List.unmodifiable(_favorites);

  FavoritesProvider() {
    _loadFromPrefs();
  }

  bool isFavorite(String productId) {
    return _favorites.any((item) => item.product.id == productId);
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? listStr = prefs.getString(_prefKey);
      if (listStr != null) {
        final List<dynamic> decoded = json.decode(listStr);
        _favorites.clear();
        _favorites.addAll(decoded.map((x) => FavoriteItem.fromJson(x)).toList());
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(_favorites.map((x) => x.toJson()).toList());
      await prefs.setString(_prefKey, encoded);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  void addFavorite(Product product, String size, String color) {
    _favorites.removeWhere((item) => item.product.id == product.id);
    _favorites.add(FavoriteItem(
      product: product,
      selectedSize: size,
      selectedColor: color,
      isSoldOut: product.quantity == 0,
    ));
    notifyListeners();
    _saveToPrefs();
  }

  void removeFavorite(String productId) {
    _favorites.removeWhere((item) => item.product.id == productId);
    notifyListeners();
    _saveToPrefs();
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
