import 'package:flutter/material.dart';
import 'package:le_nhat_truong/features/shop/models/product.dart';

class CartItem {
  final Product product;
  final String selectedSize;
  final String selectedColor;
  int quantity;

  CartItem({
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    this.quantity = 1,
  });
}

class PromoCode {
  final String code;
  final String title;
  final double discountPercent;
  final String discountLabel;
  final int daysRemaining;
  final String? imageUrl; // For custom preview if wanted

  PromoCode({
    required this.code,
    required this.title,
    required this.discountPercent,
    required this.discountLabel,
    required this.daysRemaining,
    this.imageUrl,
  });
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  PromoCode? _activePromoCode;

  List<CartItem> get items => List.unmodifiable(_items);
  PromoCode? get activePromoCode => _activePromoCode;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount {
    return _items.fold(
        0.0, (sum, item) => sum + (item.product.salePrice * item.quantity));
  }

  double get discountAmount {
    if (_activePromoCode == null) return 0.0;
    return totalAmount * (_activePromoCode!.discountPercent / 100.0);
  }

  double get finalAmount {
    final val = totalAmount - discountAmount;
    return val < 0 ? 0.0 : val;
  }

  void addItem(Product product, String size, String color) {
    final existingIndex = _items.indexWhere((item) =>
        item.product.id == product.id &&
        item.selectedSize == size &&
        item.selectedColor == color);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(
        product: product,
        selectedSize: size,
        selectedColor: color,
        quantity: 1,
      ));
    }
    notifyListeners();
  }

  void removeItem(String productId, String size, String color) {
    _items.removeWhere((item) =>
        item.product.id == productId &&
        item.selectedSize == size &&
        item.selectedColor == color);
    notifyListeners();
  }

  void incrementQuantity(String productId, String size, String color) {
    final index = _items.indexWhere((item) =>
        item.product.id == productId &&
        item.selectedSize == size &&
        item.selectedColor == color);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String productId, String size, String color) {
    final index = _items.indexWhere((item) =>
        item.product.id == productId &&
        item.selectedSize == size &&
        item.selectedColor == color);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void applyPromoCode(PromoCode promo) {
    _activePromoCode = promo;
    notifyListeners();
  }

  void removePromoCode() {
    _activePromoCode = null;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _activePromoCode = null;
    notifyListeners();
  }
}
