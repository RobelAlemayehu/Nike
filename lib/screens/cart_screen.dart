// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/cart_screen.dart — SCREEN 3: My Bag / Cart
// Full dark/light mode adaptive design.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final bool showBack;
  const CartScreen({super.key, this.showBack = true});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ── Custom header ──────────────────────────────────────────────
            _CartHeader(itemCount: items.length, showBack: showBack),
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
  final bool showBack;
  const _CartHeader({required this.itemCount, required this.showBack});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          // Back button (only shown if showBack is true)
          if (showBack) ...[
            GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface(context),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: AppColors.primaryText(context)),
              ),
            ),
            const SizedBox(width: 12),
          ],
          // Title + count
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Bag',
                style: AppTextStyles.bagTitle.copyWith(
                  color: AppColors.primaryText(context),
                ),
              ),
              Text(
                '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
                style: AppTextStyles.categoryLabel.copyWith(
                  color: AppColors.secondaryText(context),
                ),
              ),
            ],
          ),
          const Spacer(),
          // See bookmark list
          TextButton(
            onPressed: () => _showBookmarks(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryText(context),
              padding: EdgeInsets.zero,
            ),
            child: Text(
              'SEE BOOKMARK LIST',
              style: AppTextStyles.label.copyWith(
                color: AppColors.primaryText(context),
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primaryText(context),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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
                  color: isDark ? AppColors.darkBorder : AppColors.lightGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Bookmarked Items',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.primaryText(context),
              ),
            ),
            const SizedBox(height: 16),
            if (bookmarked.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No bookmarks yet.\nTap the bookmark icon on cart items to save them.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.secondaryText(context),
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView(
                  children: bookmarked.map((item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: isDark ? AppColors.darkSurface : AppColors.lightGray,
                        child: Image.asset(
                          item.product.imageUrls.first,
                          width: 50, height: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    title: Text(
                      item.product.name,
                      style: AppTextStyles.reviewerName.copyWith(
                        color: AppColors.primaryText(context),
                      ),
                    ),
                    subtitle: Text(
                      '\$${item.product.price.toStringAsFixed(2)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryText(context),
                      ),
                    ),
                    trailing: const Icon(Icons.bookmark_rounded,
                        color: AppColors.orange),
                  )).toList(),
                ),
              ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightGray,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 48,
                color: AppColors.mediumGray,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Your bag is empty',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.primaryText(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add items from the product page\nto get started.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText(context),
              ),
            ),
            const SizedBox(height: 28),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg(context),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Total row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.primaryText(context),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: Text(
                    '\$${total.toStringAsFixed(2)}',
                    key: ValueKey(total),
                    style: AppTextStyles.price.copyWith(
                      fontSize: 22,
                      color: AppColors.primaryText(context),
                    ),
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
                  color: AppColors.blackButton(context),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Checkout',
                  style: AppTextStyles.button.copyWith(
                    color: isDark ? AppColors.black : AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _onCheckout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
    );
  }
}
