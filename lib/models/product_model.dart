// ─────────────────────────────────────────────────────────────────────────────
// lib/models/product_model.dart
// ─────────────────────────────────────────────────────────────────────────────

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> imageUrls;
  final Map<String, List<String>> sizes; // e.g. {"US": ["5","5.5","6",...]}

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.imageUrls,
    required this.sizes,
  });
}
