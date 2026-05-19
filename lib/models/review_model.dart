// ─────────────────────────────────────────────────────────────────────────────
// lib/models/review_model.dart
// ─────────────────────────────────────────────────────────────────────────────

class Review {
  final String id;
  final String productId;   // links review to a specific product
  final String reviewerName;
  final String avatarUrl;
  final double rating;
  final String text;
  final String date;

  const Review({
    required this.id,
    required this.productId,
    required this.reviewerName,
    required this.avatarUrl,
    required this.rating,
    required this.text,
    required this.date,
  });
}
