// ─────────────────────────────────────────────────────────────────────────────
// lib/widgets/rating_widget.dart
// Renders star icons dynamically from a double rating value
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class RatingWidget extends StatelessWidget {
  final double rating;    // e.g. 4.5
  final double size;      // icon size
  final bool showLabel;   // show numeric label next to stars

  const RatingWidget({
    super.key,
    required this.rating,
    this.size = 14,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          if (i < rating.floor()) {
            // Full star
            return Icon(Icons.star_rounded, color: AppColors.star, size: size);
          } else if (i < rating && rating - i >= 0.5) {
            // Half star
            return Icon(Icons.star_half_rounded, color: AppColors.star, size: size);
          } else {
            // Empty star
            return Icon(Icons.star_outline_rounded, color: AppColors.mediumGray, size: size);
          }
        }),
        if (showLabel) ...[
          const SizedBox(width: 4),
          Text(
            '($rating)',
            style: TextStyle(
              fontSize: size - 2,
              color: AppColors.mediumGray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
