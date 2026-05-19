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
import '../widgets/add_to_cart_bar.dart';
import '../models/review_model.dart';
import '../data/mock_data.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = PageController();

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
      appBar: const AppHeader(showBack: false),
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
          // ── Bottom bar ────────────────────────────────────────────────────
          AddToCartBar(
            isFavourite: productProv.isFavourite,
            onFavouriteToggle: () => productProv.toggleFavourite(),
            onAddToCart: () {
              cartProv.addToCart(product, productProv.selectedSize);
              _showAddedSnack(product.name);
            },
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
