// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/profile_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../providers/auth_provider.dart';
import '../models/order_model.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showAddAddressDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add Address', style: TextStyle(fontWeight: FontWeight.w700)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter new address...',
            hintStyle: const TextStyle(fontSize: 13, color: AppColors.mediumGray),
            filled: true,
            fillColor: AppColors.lightGray,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.mediumGray)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<AuthProvider>().addAddress(controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Save', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AuthProvider>();

    // Fallback dummy order if no orders have been placed yet
    final orders = authProv.pastOrders.isEmpty
        ? [
            OrderModel(
              id: 'NK-894291',
              date: '23.05.2026',
              items: const [
                OrderItemModel(
                  productName: 'Nike Air Pegasus+ 30',
                  imageUrl: 'assets/images/air_max_1.png',
                  size: 'US 8.5',
                  quantity: 1,
                  price: 290.0,
                )
              ],
              subtotal: 290.0,
              deliveryFee: 15.0,
              total: 305.0,
              customerName: authProv.userName,
              address: '123 Nike Blvd',
              city: 'Portland',
              phone: '+1 503-555-0199',
              paymentMethod: 'Credit Card',
              status: 'Delivered',
            )
          ]
        : authProv.pastOrders;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Profile Details ────────────────────────────────────
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppColors.orangeLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.orange, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '👟',
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(authProv.userName, style: AppTextStyles.heading2),
                          const SizedBox(height: 2),
                          Text(authProv.userEmail, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    // Log out
                    GestureDetector(
                      onTap: () {
                        authProv.logout();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                      ),
                    )
                  ],
                ),
              ),

              // ── Saved Addresses Section ───────────────────────────────────
              const SizedBox(height: 32),
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Saved Addresses', style: AppTextStyles.heading3),
                    GestureDetector(
                      onTap: () => _showAddAddressDialog(context),
                      child: const Icon(Icons.add_circle_outline_rounded, color: AppColors.orange),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: authProv.savedAddresses.map((addr) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppColors.orange, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              addr,
                              style: const TextStyle(fontSize: 13, color: AppColors.black, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              // ── Orders Section ────────────────────────────────────────────
              const SizedBox(height: 28),
              FadeInUp(
                delay: const Duration(milliseconds: 150),
                duration: const Duration(milliseconds: 500),
                child: Text('My Orders', style: AppTextStyles.heading3),
              ),
              const SizedBox(height: 12),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 500),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (ctx, idx) {
                    final order = orders[idx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order #${order.id}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: order.status == 'Delivered'
                                      ? Colors.green.withValues(alpha: 0.1)
                                      : AppColors.orangeLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  order.status,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: order.status == 'Delivered' ? Colors.green : AppColors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          ...order.items.map((it) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    it.imageUrl,
                                    width: 40, height: 40,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.bolt_rounded, color: AppColors.mediumGray),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(it.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                      Text('Size: ${it.size}  •  Qty: ${it.quantity}', style: AppTextStyles.bodySmall),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${(it.price * it.quantity).toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                )
                              ],
                            ),
                          )),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(order.date, style: AppTextStyles.bodySmall),
                              Text(
                                'Total: \$${order.total.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.orange),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ── Settings Section ──────────────────────────────────────────
              const SizedBox(height: 28),
              FadeInUp(
                delay: const Duration(milliseconds: 250),
                duration: const Duration(milliseconds: 500),
                child: Text('Settings', style: AppTextStyles.heading3),
              ),
              const SizedBox(height: 12),
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 500),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Dark Mode Switch
                      SwitchListTile.adaptive(
                        value: authProv.isDarkMode,
                        onChanged: (val) => authProv.toggleDarkMode(),
                        title: const Text('Dark Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        subtitle: Text('Enable dark theme throughout the app', style: AppTextStyles.bodySmall),
                        activeColor: AppColors.orange,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      // Notifications Switch
                      SwitchListTile.adaptive(
                        value: authProv.notificationsEnabled,
                        onChanged: (val) => authProv.toggleNotifications(),
                        title: const Text('Notifications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        subtitle: Text('Get updates on order status and sales', style: AppTextStyles.bodySmall),
                        activeColor: AppColors.orange,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
