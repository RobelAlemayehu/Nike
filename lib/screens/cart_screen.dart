// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/cart_screen.dart — SCREEN 3: My Bag / Cart
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Custom header ──────────────────────────────────────────────
            _CartHeader(itemCount: items.length),
            // ── Body ────────────────────────────────────────────────────────
            Expanded(
              child: items.isEmpty
                  ? _EmptyCartView()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingL,
                        vertical: 8,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (ctx, i) => FadeInUp(
                        delay: Duration(milliseconds: i * 80),
                        duration: const Duration(milliseconds: 350),
                        child: CartItemWidget(item: items[i]),
                      ),
                    ),
            ),
            // ── Total + Checkout ───────────────────────────────────────────
            if (items.isNotEmpty) _CheckoutSection(total: cart.totalPrice),
          ],
        ),
      ),
    );
  }
}

// ── Cart header ───────────────────────────────────────────────────────────────
class _CartHeader extends StatelessWidget {
  final int itemCount;
  const _CartHeader({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18, color: AppColors.black),
            ),
          ),
          const SizedBox(width: 12),
          // Title + count
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('My Bag', style: AppTextStyles.bagTitle),
              Text(
                '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
                style: AppTextStyles.categoryLabel,
              ),
            ],
          ),
          const Spacer(),
          // See bookmark list
          TextButton(
            onPressed: () => _showBookmarks(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.black,
              padding: EdgeInsets.zero,
            ),
            child: Text(
              'SEE BOOKMARK LIST',
              style: AppTextStyles.label.copyWith(
                color: AppColors.black,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.black,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookmarks(BuildContext context) {
    final cart = context.read<CartProvider>();
    final bookmarked = cart.bookmarkedItems;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Bookmarked Items', style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            if (bookmarked.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No bookmarks yet.\nTap the bookmark icon on cart items to save them.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              )
            else
              ...bookmarked.map((item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    item.product.imageUrls.first,
                    width: 50, height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
                title: Text(item.product.name, style: AppTextStyles.reviewerName),
                subtitle: Text(
                  '\$${item.product.price.toStringAsFixed(2)}',
                  style: AppTextStyles.bodySmall,
                ),
                trailing: const Icon(Icons.bookmark_rounded,
                    color: AppColors.orange),
              )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Empty cart state ──────────────────────────────────────────────────────────
class _EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 48,
                color: AppColors.mediumGray,
              ),
            ),
            const SizedBox(height: 20),
            Text('Your bag is empty', style: AppTextStyles.heading3),
            const SizedBox(height: 8),
            Text(
              'Add items from the product page\nto get started.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text('Continue Shopping',
                    style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Total + checkout section ──────────────────────────────────────────────────
class _CheckoutSection extends StatelessWidget {
  final double total;
  const _CheckoutSection({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
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
        child: Column(
          children: [
            // Total row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: AppTextStyles.sectionTitle),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: Text(
                    '\$${total.toStringAsFixed(2)}',
                    key: ValueKey(total),
                    style: AppTextStyles.price.copyWith(fontSize: 22),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Checkout button
            GestureDetector(
              onTap: () => _onCheckout(context),
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text('Checkout', style: AppTextStyles.button),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _onCheckout(BuildContext context) {
    final cart = context.read<CartProvider>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.white,
        title: const Icon(
          Icons.check_circle_rounded,
          color: AppColors.orange,
          size: 52,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Order Placed!', style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Text(
              'Your order has been placed successfully.\nThank you for shopping with Nike!',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          GestureDetector(
            onTap: () {
              cart.clearCart();
              Navigator.pop(context);  // close dialog
              Navigator.maybePop(context); // back to product screen
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text('Done', style: AppTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }
}
