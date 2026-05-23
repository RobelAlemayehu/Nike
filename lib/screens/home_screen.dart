// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/home_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../models/product_model.dart';
import '../widgets/app_header.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onTabChange;
  final Function(String) onCategoryChange;

  const HomeScreen({
    super.key,
    required this.onTabChange,
    required this.onCategoryChange,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _activeCategoryIndex = 0;

  final List<String> _categories = ['All', 'Running', 'Casual', 'Sports', 'Formal'];

  final List<Map<String, dynamic>> _promoBanners = [
    {
      'title': 'New Release',
      'subtitle': 'Nike Air Max Plus',
      'discount': '20% OFF',
      'gradient': [const Color(0xFF1E3C72), const Color(0xFF2A5298)],
      'tagline': 'Experience the air today',
    },
    {
      'title': 'Summer Sale',
      'subtitle': 'Nike Pegasus Zoom',
      'discount': '30% OFF',
      'gradient': [AppColors.orange, const Color(0xFFF77737)],
      'tagline': 'Run like the wind',
    },
    {
      'title': 'Limited Edition',
      'subtitle': 'Nike SB Dunk High',
      'discount': 'Free Shipping',
      'gradient': [const Color(0xFF11998e), const Color(0xFF38ef7d)],
      'tagline': 'Collector items only',
    }
  ];

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  void _onCategorySelected(int index) {
    setState(() => _activeCategoryIndex = index);
    
    // Switch to search tab (index 1) and apply the filter
    final selectedCategory = _categories[index];
    widget.onCategoryChange(selectedCategory);
    widget.onTabChange(1); // switch to Search tab
  }

  @override
  Widget build(BuildContext context) {
    final productProv = context.watch<ProductProvider>();
    final cartProv = context.read<CartProvider>();
    final featuredProducts = productProv.products.take(6).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(showBack: false),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Search bar ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
                vertical: 12,
              ),
              child: FadeInDown(
                duration: const Duration(milliseconds: 400),
                child: GestureDetector(
                  onTap: () {
                    widget.onCategoryChange('All');
                    widget.onTabChange(1); // Switch to search tab
                  },
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Row(
                      children: [
                        Icon(Icons.search_rounded, color: AppColors.mediumGray),
                        SizedBox(width: 12),
                        Text(
                          'Looking for shoes?',
                          style: TextStyle(color: AppColors.mediumGray, fontSize: 14),
                        ),
                        Spacer(),
                        Icon(Icons.tune_rounded, color: AppColors.black),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Promotion Slider ────────────────────────────────────────────
            const SizedBox(height: 10),
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 500),
              child: SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: _bannerController,
                  itemCount: _promoBanners.length,
                  itemBuilder: (ctx, index) {
                    final banner = _promoBanners[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: banner['gradient'],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: (banner['gradient'][0] as Color).withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Graphic circles
                          Positioned(
                            right: -30,
                            top: -30,
                            child: CircleAvatar(
                              radius: 80,
                              backgroundColor: AppColors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          Positioned(
                            right: 40,
                            bottom: -50,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          // Content
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  banner['title'].toString().toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.white.withValues(alpha: 0.75),
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  banner['subtitle'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  banner['tagline'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    banner['discount'],
                                    style: const TextStyle(
                                      color: AppColors.black,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // ── Categories ──────────────────────────────────────────────────
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text('Categories', style: AppTextStyles.heading3),
            ),
            const SizedBox(height: 12),
            FadeInUp(
              delay: const Duration(milliseconds: 150),
              duration: const Duration(milliseconds: 500),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: List.generate(_categories.length, (index) {
                    final isSelected = _activeCategoryIndex == index;
                    return GestureDetector(
                      onTap: () => _onCategorySelected(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.orange : AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.orange.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : [],
                        ),
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            color: isSelected ? AppColors.white : AppColors.darkGray,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // ── Featured Products ───────────────────────────────────────────
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular Featured', style: AppTextStyles.heading3),
                  GestureDetector(
                    onTap: () {
                      widget.onCategoryChange('All');
                      widget.onTabChange(1); // Switch to search tab
                    },
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: AppColors.orange,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 500),
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: featuredProducts.length,
                itemBuilder: (ctx, i) {
                  final product = featuredProducts[i];
                  return _ShoeCard(
                    product: product,
                    onTap: () {
                      // Set carousel index in provider
                      final actualIndex = productProv.products.indexWhere((p) => p.id == product.id);
                      if (actualIndex >= 0) {
                        productProv.setCarouselIndex(actualIndex);
                      }
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const ProductDetailScreen(),
                          transitionsBuilder: (_, animation, __, child) =>
                              FadeTransition(opacity: animation, child: child),
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    onAddToCart: () {
                      cartProv.addToCart(product, 'EU 40'); // Default size for home additions
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart!'),
                          backgroundColor: AppColors.black,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.all(16),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShoeCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const _ShoeCard({
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Favorite Button + Image
            Expanded(
              child: Stack(
                children: [
                  // Center Image
                  Center(
                    child: Hero(
                      tag: 'home_shoe_image_${product.id}',
                      child: Image.asset(
                        product.imageUrls.first,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.bolt_rounded,
                          size: 60,
                          color: AppColors.mediumGray,
                        ),
                      ),
                    ),
                  ),
                  // Hot Tag
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.orangeLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'HOT',
                        style: TextStyle(
                          color: AppColors.orange,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Product Category
            Text(
              product.category,
              style: AppTextStyles.categoryLabel.copyWith(fontSize: 11),
            ),
            const SizedBox(height: 2),

            // Product Name
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 6),

            // Price & Add Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.black,
                  ),
                ),
                GestureDetector(
                  onTap: onAddToCart,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
