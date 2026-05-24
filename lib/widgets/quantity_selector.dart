// ─────────────────────────────────────────────────────────────────────────────
// lib/widgets/quantity_selector.dart
// Orange +/- quantity control — dark/light mode adaptive.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _QtyButton(icon: Icons.remove, onTap: onDecrement, isPrimary: false),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Text(
              '$quantity',
              key: ValueKey(quantity),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText(context),
              ),
            ),
          ),
        ),
        _QtyButton(icon: Icons.add, onTap: onIncrement, isPrimary: true),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.orange
              : (isDark ? AppColors.darkSurface : AppColors.lightGray),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: isPrimary ? AppColors.white : AppColors.primaryText(context),
        ),
      ),
    );
  }
}
