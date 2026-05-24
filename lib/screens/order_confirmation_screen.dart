// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/order_confirmation_screen.dart
// Dark/light mode adaptive order confirmation.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/order_model.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final OrderModel order;

  const OrderConfirmationScreen({super.key, required this.order});

  void _showTrackingDialog(BuildContext context) {
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
              'Track Order #${order.id}',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.primaryText(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Estimated Delivery: 2-3 Business Days',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.secondaryText(context),
              ),
            ),
            const SizedBox(height: 24),
            _TrackingStep(
              icon: Icons.check_circle_rounded,
              color: Colors.green,
              title: 'Order Placed',
              description: 'We have received your order.',
              isLast: false,
              isActive: true,
            ),
            _TrackingStep(
              icon: Icons.inventory_2_outlined,
              color: AppColors.orange,
              title: 'Order Packaging',
              description: 'Your premium sneakers are being packed.',
              isLast: false,
              isActive: true,
            ),
            _TrackingStep(
              icon: Icons.local_shipping_outlined,
              color: AppColors.mediumGray,
              title: 'In Transit',
              description: 'Carrier has picked up your package.',
              isLast: false,
              isActive: false,
            ),
            _TrackingStep(
              icon: Icons.home_work_outlined,
              color: AppColors.mediumGray,
              title: 'Delivered',
              description: 'Package delivered at your doorstep.',
              isLast: true,
              isActive: false,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Animated Success Checkmark
              ZoomIn(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.orangeLight,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.orange.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.orange,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 500),
                child: Text(
                  'Order Placed Successfully!',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.primaryText(context),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 500),
                child: Text(
                  'Your premium footwear is on its way to you.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondaryText(context),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              // Order details box
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.02),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _infoRow(context, 'Order Number', order.id),
                      Divider(height: 20, color: isDark ? AppColors.darkBorder : AppColors.lightGray),
                      _infoRow(context, 'Estimated Delivery', '2-3 Business Days', valueColor: Colors.green),
                      Divider(height: 20, color: isDark ? AppColors.darkBorder : AppColors.lightGray),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery Address', style: TextStyle(fontSize: 12, color: AppColors.secondaryText(context))),
                          Expanded(
                            child: Text(
                              '${order.address}, ${order.city}',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryText(context)),
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 20, color: isDark ? AppColors.darkBorder : AppColors.lightGray),
                      _infoRow(context, 'Total Amount', '\$${order.total.toStringAsFixed(2)}', valueColor: AppColors.orange, valueBold: true),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Buttons
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _showTrackingDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blackButton(context),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          'Track Order',
                          style: AppTextStyles.button.copyWith(
                            color: isDark ? AppColors.black : AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primaryText(context), width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          'Continue Shopping',
                          style: TextStyle(
                            color: AppColors.primaryText(context),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value, {Color? valueColor, bool valueBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.secondaryText(context))),
        Text(
          value,
          style: TextStyle(
            fontSize: valueBold ? 15 : 13,
            fontWeight: valueBold ? FontWeight.w800 : FontWeight.w700,
            color: valueColor ?? AppColors.primaryText(context),
          ),
        ),
      ],
    );
  }
}

// ── Tracking step widget ──────────────────────────────────────────────────────
class _TrackingStep extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final bool isLast;
  final bool isActive;

  const _TrackingStep({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.isLast,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isActive
                    ? color.withValues(alpha: 0.1)
                    : (isDark ? AppColors.darkSurface : AppColors.lightGray),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isActive ? color : AppColors.mediumGray, size: 18),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isActive ? color : (isDark ? AppColors.darkBorder : AppColors.lightGray),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isActive ? AppColors.primaryText(context) : AppColors.mediumGray,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(fontSize: 11, color: AppColors.secondaryText(context)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
