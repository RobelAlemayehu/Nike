// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/order_confirmation_screen.dart
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Track Order #${order.id}', style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Text('Estimated Delivery: 2-3 Business Days', style: AppTextStyles.bodySmall),
            const SizedBox(height: 24),
            _buildTrackingStep(
              icon: Icons.check_circle_rounded,
              color: Colors.green,
              title: 'Order Placed',
              description: 'We have received your order.',
              isLast: false,
              isActive: true,
            ),
            _buildTrackingStep(
              icon: Icons.inventory_2_outlined,
              color: AppColors.orange,
              title: 'Order Packaging',
              description: 'Your premium sneakers are being packed.',
              isLast: false,
              isActive: true,
            ),
            _buildTrackingStep(
              icon: Icons.local_shipping_outlined,
              color: AppColors.mediumGray,
              title: 'In Transit',
              description: 'Carrier has picked up your package.',
              isLast: false,
              isActive: false,
            ),
            _buildTrackingStep(
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

  Widget _buildTrackingStep({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required bool isLast,
    required bool isActive,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isActive ? color.withValues(alpha: 0.1) : AppColors.lightGray,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isActive ? color : AppColors.mediumGray, size: 18),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isActive ? color : AppColors.lightGray,
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
                  color: isActive ? AppColors.black : AppColors.mediumGray,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(fontSize: 11, color: AppColors.mediumGray),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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

              // Title
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 500),
                child: Text('Order Placed Successfully!', style: AppTextStyles.heading2, textAlign: TextAlign.center),
              ),
              const SizedBox(height: 8),
              
              // Tagline
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 500),
                child: Text(
                  'Your premium footwear is on its way to you.',
                  style: AppTextStyles.bodyMedium,
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
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Order Number', style: TextStyle(fontSize: 12, color: AppColors.mediumGray)),
                          Text(order.id, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.black)),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Estimated Delivery', style: TextStyle(fontSize: 12, color: AppColors.mediumGray)),
                          const Text('2-3 Business Days', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.green)),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery Address', style: TextStyle(fontSize: 12, color: AppColors.mediumGray)),
                          Expanded(
                            child: Text(
                              '${order.address}, ${order.city}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.black),
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Amount', style: TextStyle(fontSize: 12, color: AppColors.mediumGray)),
                          Text('\$${order.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.orange)),
                        ],
                      ),
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
                    // Track Order
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _showTrackingDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('Track Order', style: AppTextStyles.button),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Continue Shopping
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          // Pop back to main navigation (which is root)
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.black, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text(
                          'Continue Shopping',
                          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600, fontSize: 15),
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
}
