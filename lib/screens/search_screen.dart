// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/search_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../providers/product_provider.dart';
import '../models/product_model.dart';
import '../widgets/rating_widget.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final String initialCategory;

  const SearchScreen({
    super.key,
    this.initialCategory = 'All',
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedPriceRange = 'All'; // All | Under $120 | $120 - $200 | Over $200
  String _selectedSort = 'Newest'; // Newest | Price: Low to High | Price: High to Low
  String _selectedBrand = 'All'; // All | Air Max | SB Dunk | Pegasus | Free Run | Kobe

  final List<String> _categories = ['All', 'Running', 'Casual', 'Sports', 'Formal'];
  final List<String> _priceRanges = ['All', 'Under \$120', '\$120 - \$200', 'Over \$200'];
  final List<String> _brands = ['All', 'Air Max', 'Pegasus', 'Kobe', 'SB Dunk', 'Free Run'];
  final List<String> _sortOptions = ['Newest', 'Price: Low to High', 'Price: High to Low'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  void didUpdateWidget(covariant SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != oldWidget.initialCategory) {
      setState(() {
        _selectedCategory = widget.initialCategory;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = 'All';
      _selectedPriceRange = 'All';
      _selectedBrand = 'All';
      _selectedSort = 'Newest';
    });
  }

  // Extract brand from name as best effort
  String _getBrandName(String name) {
    if (name.contains('Air Max')) return 'Air Max';
    if (name.contains('Pegasus')) return 'Pegasus';
    if (name.contains('Kobe')) return 'Kobe';
    if (name.contains('SB Dunk')) return 'SB Dunk';
    if (name.contains('Free Run')) return 'Free Run';
    return 'Nike Classic';
  }

  List<Product> _getFilteredProducts(List<Product> allProducts) {
    List<Product> filtered = allProducts.where((p) {
      // 1. Search Query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = p.name.toLowerCase().contains(query);
        final matchesCat = p.category.toLowerCase().contains(query);
        if (!matchesName && !matchesCat) return false;
      }

      // 2. Category Filter
      if (_selectedCategory != 'All') {
        final cat = _selectedCategory.toLowerCase();
        // Match Running/Casual/Sports/Formal against category and description
        if (cat == 'running') {
          if (!p.category.toLowerCase().contains('running') && 
              !p.name.toLowerCase().contains('run') &&
              !p.name.toLowerCase().contains('pegasus')) return false;
        } else if (cat == 'casual') {
          if (!p.category.toLowerCase().contains('men') && 
              !p.category.toLowerCase().contains('women')) return false;
        } else if (cat == 'sports' || cat == 'formal') {
          // Fallback or custom matches
          if (cat == 'sports' && !p.category.toLowerCase().contains('golf') && !p.name.toLowerCase().contains('kobe')) return false;
          if (cat == 'formal' && !p.name.toLowerCase().contains('pegasus') && !p.name.toLowerCase().contains('ascend')) return false;
        }
      }

      // 3. Price Filter
      if (_selectedPriceRange != 'All') {
        if (_selectedPriceRange == 'Under \$120') {
          if (p.price >= 120) return false;
        } else if (_selectedPriceRange == '\$120 - \$200') {
          if (p.price < 120 || p.price > 200) return false;
        } else if (_selectedPriceRange == 'Over \$200') {
          if (p.price <= 200) return false;
        }
      }

      // 4. Brand Filter
      if (_selectedBrand != 'All') {
        final brand = _getBrandName(p.name);
        if (brand != _selectedBrand) return false;
      }

      return true;
    }).toList();

    // 5. Sorting
    if (_selectedSort == 'Price: Low to High') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == 'Price: High to Low') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    } else {
      // "Newest" - sort by ID or default rating
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return filtered;
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pull Bar
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: AppTextStyles.heading2),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        _selectedCategory = 'All';
                        _selectedPriceRange = 'All';
                        _selectedBrand = 'All';
                      });
                      setState(() {});
                    },
                    child: const Text('Reset All', style: TextStyle(color: AppColors.orange)),
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Category
              Text('Category', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _categories.map((c) {
                  final isSel = _selectedCategory == c;
                  return ChoiceChip(
                    label: Text(c),
                    selected: isSel,
                    onSelected: (val) {
                      setModalState(() => _selectedCategory = c);
                      setState(() {});
                    },
                    selectedColor: AppColors.orange,
                    labelStyle: TextStyle(
                      color: isSel ? AppColors.white : AppColors.black,
                      fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                    ),
                    backgroundColor: AppColors.lightGray,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Price range
              Text('Price Range', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _priceRanges.map((p) {
                  final isSel = _selectedPriceRange == p;
                  return ChoiceChip(
                    label: Text(p),
                    selected: isSel,
                    onSelected: (val) {
                      setModalState(() => _selectedPriceRange = p);
                      setState(() {});
                    },
                    selectedColor: AppColors.orange,
                    labelStyle: TextStyle(
                      color: isSel ? AppColors.white : AppColors.black,
                      fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                    ),
                    backgroundColor: AppColors.lightGray,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Brand
              Text('Collection / Brand', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _brands.map((b) {
                  final isSel = _selectedBrand == b;
                  return ChoiceChip(
                    label: Text(b),
                    selected: isSel,
                    onSelected: (val) {
                      setModalState(() => _selectedBrand = b);
                      setState(() {});
                    },
                    selectedColor: AppColors.orange,
                    labelStyle: TextStyle(
                      color: isSel ? AppColors.white : AppColors.black,
                      fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                    ),
                    backgroundColor: AppColors.lightGray,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Apply Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Apply Filters', style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProv = context.watch<ProductProvider>();
    final filtered = _getFilteredProducts(productProv.products);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Search & Filter header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: AppColors.mediumGray, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(fontSize: 14, color: AppColors.black),
                              decoration: const InputDecoration(
                                hintText: 'Search premium shoes...',
                                hintStyle: TextStyle(color: AppColors.mediumGray, fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _searchQuery = val;
                                });
                              },
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                              child: const Icon(Icons.close_rounded, color: AppColors.mediumGray, size: 18),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter Button
                  GestureDetector(
                    onTap: _openFilterBottomSheet,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: const Icon(Icons.tune_rounded, color: AppColors.black, size: 20),
                    ),
                  )
                ],
              ),
            ),

            // ── Sort Options & Reset Row ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${filtered.length} Items Found',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.darkGray),
                  ),
                  const Spacer(),
                  // Sort dropdown
                  PopupMenuButton<String>(
                    initialValue: _selectedSort,
                    onSelected: (val) {
                      setState(() => _selectedSort = val);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        Text(
                          _selectedSort,
                          style: const TextStyle(color: AppColors.orange, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.orange, size: 16),
                      ],
                    ),
                    itemBuilder: (_) => _sortOptions.map((opt) {
                      return PopupMenuItem<String>(
                        value: opt,
                        child: Text(opt, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                  ),
                  if (_searchQuery.isNotEmpty || _selectedCategory != 'All' || _selectedPriceRange != 'All' || _selectedBrand != 'All') ...[
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _resetFilters,
                      child: const Icon(Icons.refresh_rounded, color: AppColors.mediumGray, size: 18),
                    )
                  ]
                ],
              ),
            ),

            // ── Products Grid ───────────────────────────────────────────────
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.search_off_rounded, size: 36, color: AppColors.mediumGray),
                          ),
                          const SizedBox(height: 16),
                          const Text('No shoes match your criteria.', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.black)),
                          const SizedBox(height: 8),
                          Text('Try modifying your filters or query.', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final product = filtered[i];
                        final brandName = _getBrandName(product.name);
                        return _SearchProductCard(
                          product: product,
                          brand: brandName,
                          onTap: () {
                            // Find product index in global products list
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

class _SearchProductCard extends StatelessWidget {
  final Product product;
  final String brand;
  final VoidCallback onTap;

  const _SearchProductCard({
    required this.product,
    required this.brand,
    required this.onTap,
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
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (centered)
            Expanded(
              child: Center(
                child: Hero(
                  tag: 'search_shoe_image_${product.id}',
                  child: Image.asset(
                    product.imageUrls.first,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_rounded, size: 50, color: AppColors.mediumGray),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Brand name
            Text(brand.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10, color: AppColors.orange, letterSpacing: 0.8)),
            const SizedBox(height: 2),

            // Shoe Name
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.black),
            ),
            const SizedBox(height: 4),

            // Stars
            RatingWidget(rating: product.rating, size: 12),
            const SizedBox(height: 8),

            // Price Row
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.black),
            ),
          ],
        ),
      ),
    );
  }
}
