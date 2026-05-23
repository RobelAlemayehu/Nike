// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/checkout_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem>? directItems; // Used for "Buy Now" flow

  const CheckoutScreen({super.key, this.directItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();

  // Card fields
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  String _selectedPaymentMethod = 'Cash on Delivery'; // Cash on Delivery | Card | Mobile Money
  final List<String> _paymentMethods = ['Cash on Delivery', 'Credit/Debit Card', 'Mobile Money'];

  @override
  void initState() {
    super.initState();
    // Pre-populate user details from AuthProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      _nameController.text = auth.userName;
      if (auth.savedAddresses.isNotEmpty) {
        _addressController.text = auth.savedAddresses.first;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  double _calculateSubtotal(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double _calculateDeliveryFee(double subtotal) {
    return subtotal > 200 ? 0.0 : 15.0; // Free delivery above $200
  }

  void _placeOrder(List<CartItem> items, double subtotal, double deliveryFee, double total) {
    if (!_formKey.currentState!.validate()) return;

    final authProv = context.read<AuthProvider>();
    final cartProv = context.read<CartProvider>();

    // Generate random order ID
    final random = Random();
    final orderNum = 'NK-${100000 + random.nextInt(900000)}';

    // Construct OrderItem list
    final orderItems = items.map((item) {
      return OrderItemModel(
        productName: item.product.name,
        imageUrl: item.product.imageUrls.first,
        size: item.selectedSize,
        quantity: item.quantity,
        price: item.product.price,
      );
    }).toList();

    final order = OrderModel(
      id: orderNum,
      date: '${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year}',
      items: orderItems,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      customerName: _nameController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      phone: _phoneController.text.trim(),
      paymentMethod: _selectedPaymentMethod,
      status: 'Pending',
    );

    // Save order history
    authProv.placeOrder(order);

    // Clear cart if ordered from checkout cart
    if (widget.directItems == null) {
      cartProv.clearCart();
    }

    // Navigate to Confirmation Screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(order: order),
      ),
      (route) => route.isFirst, // Go back to Home / Main tab and replace other screens
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = widget.directItems ?? context.read<CartProvider>().items;
    final subtotal = _calculateSubtotal(cartItems);
    final deliveryFee = _calculateDeliveryFee(subtotal);
    final total = subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.black)),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.black),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Order Summary Card ──────────────────────────────────
                    Text('Order Summary', style: AppTextStyles.heading3),
                    const SizedBox(height: 12),
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartItems.length,
                          separatorBuilder: (_, __) => const Divider(height: 20),
                          itemBuilder: (ctx, i) {
                            final item = cartItems[i];
                            return Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    item.product.imageUrls.first,
                                    width: 50, height: 50,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.bolt_rounded),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                      const SizedBox(height: 2),
                                      Text('Size: ${item.selectedSize}  •  Qty: ${item.quantity}', style: AppTextStyles.bodySmall),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${item.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    // ── Delivery Details Form ────────────────────────────────
                    const SizedBox(height: 28),
                    Text('Delivery Address', style: AppTextStyles.heading3),
                    const SizedBox(height: 12),
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              style: const TextStyle(fontSize: 13, color: AppColors.black),
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                labelStyle: TextStyle(color: AppColors.mediumGray, fontSize: 12),
                                prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.mediumGray, size: 20),
                                border: UnderlineInputBorder(),
                              ),
                              validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a recipient name' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _addressController,
                              style: const TextStyle(fontSize: 13, color: AppColors.black),
                              decoration: const InputDecoration(
                                labelText: 'Address',
                                labelStyle: TextStyle(color: AppColors.mediumGray, fontSize: 12),
                                prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.mediumGray, size: 20),
                                border: UnderlineInputBorder(),
                              ),
                              validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a delivery address' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _cityController,
                              style: const TextStyle(fontSize: 13, color: AppColors.black),
                              decoration: const InputDecoration(
                                labelText: 'City / State',
                                labelStyle: TextStyle(color: AppColors.mediumGray, fontSize: 12),
                                prefixIcon: Icon(Icons.location_city_outlined, color: AppColors.mediumGray, size: 20),
                                border: UnderlineInputBorder(),
                              ),
                              validator: (val) => val == null || val.trim().isEmpty ? 'Please enter your city' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _phoneController,
                              style: const TextStyle(fontSize: 13, color: AppColors.black),
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(color: AppColors.mediumGray, fontSize: 12),
                                prefixIcon: Icon(Icons.phone_outlined, color: AppColors.mediumGray, size: 20),
                                border: UnderlineInputBorder(),
                              ),
                              validator: (val) => val == null || val.trim().isEmpty ? 'Please enter your phone number' : null,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Payment Method Selector ──────────────────────────────
                    const SizedBox(height: 28),
                    Text('Payment Method', style: AppTextStyles.heading3),
                    const SizedBox(height: 12),
                    FadeInUp(
                      delay: const Duration(milliseconds: 150),
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        children: _paymentMethods.map((method) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: RadioListTile<String>(
                              value: method,
                              groupValue: _selectedPaymentMethod,
                              title: Text(method, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              activeColor: AppColors.orange,
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedPaymentMethod = val);
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Card Fields (Visible only if Credit/Debit Card is selected)
                    if (_selectedPaymentMethod == 'Credit/Debit Card') ...[
                      const SizedBox(height: 12),
                      FadeInUp(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _cardNumberController,
                                style: const TextStyle(fontSize: 13, color: AppColors.black),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Card Number',
                                  labelStyle: TextStyle(color: AppColors.mediumGray, fontSize: 12),
                                  prefixIcon: Icon(Icons.credit_card_rounded, color: AppColors.mediumGray, size: 20),
                                  hintText: '1234 5678 9101 1121',
                                ),
                                validator: (val) => val == null || val.length < 16 ? 'Enter a valid card number' : null,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _expiryController,
                                      style: const TextStyle(fontSize: 13, color: AppColors.black),
                                      decoration: const InputDecoration(
                                        labelText: 'Expiry Date',
                                        labelStyle: TextStyle(color: AppColors.mediumGray, fontSize: 12),
                                        hintText: 'MM/YY',
                                      ),
                                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _cvvController,
                                      style: const TextStyle(fontSize: 13, color: AppColors.black),
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'CVV',
                                        labelStyle: TextStyle(color: AppColors.mediumGray, fontSize: 12),
                                        hintText: '123',
                                      ),
                                      validator: (val) => val == null || val.length < 3 ? 'Required' : null,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── Bill Summary + Place Order Button ────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  )
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal', style: AppTextStyles.bodyMedium),
                        Text('\$${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Fee', style: AppTextStyles.bodyMedium),
                        Text(
                          deliveryFee == 0.0 ? 'FREE' : '\$${deliveryFee.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: deliveryFee == 0.0 ? Colors.green : AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: AppTextStyles.heading3),
                        Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.orange)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _placeOrder(cartItems, subtotal, deliveryFee, total),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('Place Order', style: AppTextStyles.button),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
