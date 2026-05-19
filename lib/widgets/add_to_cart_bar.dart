// ─────────────────────────────────────────────────────────────────────────────
// lib/widgets/add_to_cart_bar.dart
// Bottom action bar: Bookmark button + "Add to Cart" button
// Shared between Product Details and Reviews screens
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AddToCartBar extends StatelessWidget {
  final bool isFavourite;
  final VoidCallback onFavouriteToggle;
  final VoidCallback onAddToCart;

  const AddToCartBar({
    super.key,
    required this.isFavourite,
    required this.onFavouriteToggle,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // ── Bookmark button ──────────────────────────────────────────────
            GestureDetector(
              onTap: onFavouriteToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isFavourite ? AppColors.orangeLight : AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isFavourite
                        ? AppColors.orange.withValues(alpha: 0.4)
                        : AppColors.lightGray,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    isFavourite
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    key: ValueKey(isFavourite),
                    color: isFavourite ? AppColors.orange : AppColors.mediumGray,
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // ── Add to Cart button ─────────────────────────────────────────────
            Expanded(
              child: GestureDetector(
                onTap: onAddToCart,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text('Add to Cart', style: AppTextStyles.button),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
