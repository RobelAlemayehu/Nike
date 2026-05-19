// ─────────────────────────────────────────────────────────────────────────────
// lib/providers/cart_provider.dart
// Global cart state using Provider (ChangeNotifier)
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  // Internal list of cart items
  final List<CartItem> _items = [];

  // ── Public getters ──────────────────────────────────────────────────────────

  /// All items currently in the cart
  List<CartItem> get items => List.unmodifiable(_items);

  /// Total number of individual units across all cart items
  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Total monetary value of cart
  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Only bookmarked items
  List<CartItem> get bookmarkedItems =>
      _items.where((item) => item.isBookmarked).toList();

  // ── Methods ─────────────────────────────────────────────────────────────────

  /// Add a product to the cart. If it already exists (same id + size),
  /// increment quantity instead of duplicating.
  void addToCart(Product product, String selectedSize) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id && item.selectedSize == selectedSize,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product, selectedSize: selectedSize));
    }
    notifyListeners();
  }

  /// Remove an item from cart entirely
  void removeFromCart(String productId, String selectedSize) {
    _items.removeWhere(
      (item) => item.product.id == productId && item.selectedSize == selectedSize,
    );
    notifyListeners();
  }

  /// Increase quantity of a specific cart item
  void incrementQuantity(String productId, String selectedSize) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId && item.selectedSize == selectedSize,
    );
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  /// Decrease quantity; removes item if it reaches 0
  void decrementQuantity(String productId, String selectedSize) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId && item.selectedSize == selectedSize,
    );
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// Toggle bookmark on a cart item
  void toggleBookmark(String productId, String selectedSize) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId && item.selectedSize == selectedSize,
    );
    if (index >= 0) {
      _items[index].isBookmarked = !_items[index].isBookmarked;
      notifyListeners();
    }
  }

  /// Clear the entire cart (after checkout)
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
