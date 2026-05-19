// ─────────────────────────────────────────────────────────────────────────────
// lib/models/cart_item_model.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  bool isBookmarked;
  final String selectedSize;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.isBookmarked = false,
    required this.selectedSize,
  });

  double get totalPrice => product.price * quantity;

  /// Creates a copy with overridden fields
  CartItem copyWith({
    int? quantity,
    bool? isBookmarked,
  }) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      selectedSize: selectedSize,
    );
  }
}
