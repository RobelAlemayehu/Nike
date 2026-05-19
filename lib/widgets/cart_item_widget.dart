// ─────────────────────────────────────────────────────────────────────────────
// lib/widgets/cart_item_widget.dart
// Individual cart card with image, title, price, qty selector, bookmark & trash
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/cart_item_model.dart';
import '../providers/cart_provider.dart';
import 'quantity_selector.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return Dismissible(
      key: Key('${item.product.id}_${item.selectedSize}'),
      direction: DismissDirection.endToStart,
      // Orange swipe background showing delete icon
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.orangeLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: AppColors.orange, size: 26),
      ),
      onDismissed: (_) =>
          cart.removeFromCart(item.product.id, item.selectedSize),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Shoe image ───────────────────────────────────────────────────
              Hero(
                tag: 'cart_${item.product.id}',
                child: Container(
                  width: 82,
                  height: 82,
                  color: AppColors.lightGray,
                  child: Image.asset(
                    item.product.imageUrls.first,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // ── Product info + controls ─────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(item.product.name, style: AppTextStyles.heading3),
                    const SizedBox(height: 2),
                    // Price
                    Text(
                      '\$${item.product.price.toStringAsFixed(2)}',
                      style: AppTextStyles.categoryLabel.copyWith(
                        color: AppColors.mediumGray,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Size
                    Text(
                      'Size: ${item.selectedSize}',
                      style: AppTextStyles.categoryLabel.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Qty selector row
                    Row(
                      children: [
                        QuantitySelector(
                          quantity: item.quantity,
                          onDecrement: () => cart.decrementQuantity(
                              item.product.id, item.selectedSize),
                          onIncrement: () => cart.incrementQuantity(
                              item.product.id, item.selectedSize),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ── Bookmark + Delete column ────────────────────────────────────
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bookmark toggle
                  GestureDetector(
                    onTap: () => cart.toggleBookmark(
                        item.product.id, item.selectedSize),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        item.isBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_outline_rounded,
                        key: ValueKey(item.isBookmarked),
                        color: item.isBookmarked
                            ? AppColors.orange
                            : AppColors.mediumGray,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Delete button
                  GestureDetector(
                    onTap: () => cart.removeFromCart(
                        item.product.id, item.selectedSize),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.orangeLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.orange,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
