// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/product_detail_screen.dart
// SCREEN 1 – Product Details with carousel, size picker, expandable sections
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:animate_do/animate_do.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/rating_widget.dart';
import '../widgets/expandable_tile.dart';
import '../models/review_model.dart';
import '../models/cart_item_model.dart';
import '../data/mock_data.dart';
import 'checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = PageController();
  int _selectedColorIndex = 0;

  final List<Color> _colors = [
    AppColors.orange,
    AppColors.darkGray,
    AppColors.black,
  ];

  final List<String> _colorNames = [
    'Bright Orange',
    'Dark Shadow',
    'Deep Obsidian',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Show snack-bar feedback when item is added
  void _showAddedSnack(String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName added to cart!'),
        backgroundColor: AppColors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProv = context.watch<ProductProvider>();
    final cartProv = context.read<CartProvider>();
    final product = productProv.product;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(showBack: true),
      body: Column(
        children: [
          // ── Scrollable content ────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image Carousel ─────────────────────────────────────────
                  _buildCarousel(productProv),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Category + Rating row ──────────────────────────
                        FadeInUp(
                          duration: const Duration(milliseconds: 400),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(product.category,
                                  style: AppTextStyles.categoryLabel),
                              RatingWidget(
                                rating: product.rating,
                                size: 14,
                                showLabel: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        // ── Title + Price row ──────────────────────────────
                        FadeInUp(
                          delay: const Duration(milliseconds: 80),
                          duration: const Duration(milliseconds: 400),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(product.name,
                                  style: AppTextStyles.heading1),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: AppTextStyles.price,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),

                        // ── Color selector ─────────────────────────────────
                        FadeInUp(
                          delay: const Duration(milliseconds: 120),
                          duration: const Duration(milliseconds: 400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Color: ', style: AppTextStyles.sectionTitle),
                                  Text(
                                    _colorNames[_selectedColorIndex],
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.orange),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: List.generate(_colors.length, (idx) {
                                  final color = _colors[idx];
                                  final isSelected = _selectedColorIndex == idx;
                                  return GestureDetector(
                                    onTap: () => setState(() => _selectedColorIndex = idx),
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 14),
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? AppColors.orange : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: color,
                                        child: isSelected
                                            ? const Icon(Icons.check_rounded, color: AppColors.white, size: 16)
                                            : null,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),

                        // ── Size selector ──────────────────────────────────
                        FadeInUp(
                          delay: const Duration(milliseconds: 160),
                          duration: const Duration(milliseconds: 400),
                          child: _buildSizeSelector(productProv),
                        ),
                        const SizedBox(height: 22),

                        // ── Expandable sections ────────────────────────────
                        FadeInUp(
                          delay: const Duration(milliseconds: 240),
                          duration: const Duration(milliseconds: 400),
                          child: Column(
                            children: [
                              ExpandableTile(
                                title: 'Description',
                                description: product.description,
                              ),
                              ExpandableTile(
                                title: 'Free Delivery and Returns',
                                description:
                                    'Free standard delivery for all orders over \$50. '
                                    'Free returns within 30 days — no questions asked. '
                                    'Express delivery available at checkout.',
                              ),
                              ExpandableTile(
                                title: 'See Reviews',
                                child: Column(
                                  children: MockData.reviewsFor(product.id)
                                      .map((r) => _ReviewCard(review: r))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ── Bottom Action Bar ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Favorite button
                  GestureDetector(
                    onTap: () => productProv.toggleFavourite(),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: productProv.isFavourite ? AppColors.orangeLight : AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: productProv.isFavourite
                              ? AppColors.orange.withValues(alpha: 0.4)
                              : AppColors.lightGray,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        productProv.isFavourite ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                        color: productProv.isFavourite ? AppColors.orange : AppColors.mediumGray,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Add to Cart Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        cartProv.addToCart(product, productProv.selectedSize);
                        _showAddedSnack(product.name);
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Buy Now Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final buyNowItem = CartItem(
                          product: product,
                          selectedSize: productProv.selectedSize,
                          quantity: 1,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutScreen(directItems: [buyNowItem]),
                          ),
                        );
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Buy Now',
                          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Image carousel with page indicator ──────────────────────────────────────
  Widget _buildCarousel(ProductProvider prov) {
    final products = prov.products;
    return Column(
      children: [
        SizedBox(
          height: AppDimensions.carouselHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: products.length,
            onPageChanged: prov.setCarouselIndex,
            itemBuilder: (ctx, i) {
              return Hero(
                tag: 'shoe_image_$i',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Image.asset(
                    products[i].imageUrls.first,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        // ── Dot indicators ─────────────────────────────────────────────────
        SmoothPageIndicator(
          controller: _pageController,
          count: products.length,
          effect: ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            expansionFactor: 3,
            activeDotColor: AppColors.black,
            dotColor: AppColors.mediumGray.withValues(alpha: 0.3),
            spacing: 5,
          ),
        ),
      ],
    );
  }

  // ── Size unit tabs + size chips ──────────────────────────────────────────────
  Widget _buildSizeSelector(ProductProvider prov) {
    const units = ['US', 'UK', 'EU'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row: "Size:" label + unit tabs
        Row(
          children: [
            Text('Size:', style: AppTextStyles.sectionTitle),
            const Spacer(),
            Row(
              children: units
                  .map((u) => _SizeUnitTab(
                        label: u,
                        isSelected: prov.selectedSizeUnit == u,
                        onTap: () => prov.selectSizeUnit(u),
                      ))
                  .toList(),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Size chips row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: prov.currentSizes.map((size) {
              final isSelected = prov.selectedSize == size;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _SizeChip(
                  label: size,
                  isSelected: isSelected,
                  onTap: () => prov.selectSize(size),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Size unit tab (US / UK / EU) ──────────────────────────────────────────────
class _SizeUnitTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SizeUnitTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            color: isSelected ? AppColors.black : AppColors.mediumGray,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

// ── Individual size chip ───────────────────────────────────────────────────────
class _SizeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SizeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 52,
        height: 46,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orange : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.orange.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.darkGray,
          ),
        ),
      ),
    );
  }
}

// ── Individual review card ─────────────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final Review review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(review.avatarUrl),
                onBackgroundImageError: (_, __) {},
                backgroundColor: AppColors.lightGray,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(review.reviewerName, style: AppTextStyles.reviewerName)),
              RatingWidget(rating: review.rating, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Text(review.text, style: AppTextStyles.reviewText),
          const SizedBox(height: 10),
          Text(review.date, style: AppTextStyles.reviewDate),
        ],
      ),
    );
  }
}
