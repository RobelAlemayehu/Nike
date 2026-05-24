// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/checkout_screen.dart
// Stunning checkout screen with saved address & credit card selectors,
// dynamic structured entries, and dark/light adaptive design.
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
import '../models/address_model.dart';
import '../models/credit_card_model.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem>? directItems; // Used for "Buy Now" flow

  const CheckoutScreen({super.key, this.directItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientNameController = TextEditingController();
  final _phoneController = TextEditingController();

  // Manual structured address fields
  final _streetController = TextEditingController();
  final _aptController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController(text: 'United States');

  // Manual card fields
  final _cardHolderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  // States
  int? _selectedAddressIndex; // null means manual input / new address
  int? _selectedCardIndex; // null means manual input / new card
  bool _saveNewAddressToProfile = false;
  bool _saveNewCardToProfile = false;

  String _selectedPaymentMethod = 'Cash on Delivery'; // Cash on Delivery | Credit/Debit Card | Mobile Money
  final List<String> _paymentMethods = ['Cash on Delivery', 'Credit/Debit Card', 'Mobile Money'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      _recipientNameController.text = auth.userName;
      if (auth.savedAddresses.isNotEmpty) {
        setState(() {
          _selectedAddressIndex = 0;
        });
      }
      if (auth.savedCards.isNotEmpty) {
        setState(() {
          _selectedCardIndex = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _recipientNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _aptController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    _cardHolderController.dispose();
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

    // Resolve address representation
    String finalAddressStr = '';
    String finalCityStr = '';
    if (_selectedAddressIndex != null && _selectedAddressIndex! < authProv.savedAddresses.length) {
      final saved = authProv.savedAddresses[_selectedAddressIndex!];
      finalAddressStr = saved.displayLine1;
      finalCityStr = '${saved.city}, ${saved.state} ${saved.zip}';
    } else {
      // Manual input
      final addressObj = AddressModel(
        street: _streetController.text.trim(),
        apt: _aptController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zip: _zipController.text.trim(),
        country: _countryController.text.trim(),
      );
      finalAddressStr = addressObj.displayLine1;
      finalCityStr = '${addressObj.city}, ${addressObj.state} ${addressObj.zip}';

      // Save to profile if checked
      if (_saveNewAddressToProfile) {
        authProv.addAddress(addressObj);
      }
    }

    // Resolve card representation and logic if Credit Card selected
    if (_selectedPaymentMethod == 'Credit/Debit Card') {
      if (_selectedCardIndex == null) {
        // Manual card input saving
        if (_saveNewCardToProfile) {
          final rawNum = _cardNumberController.text.replaceAll(' ', '');
          final last4 = rawNum.substring(rawNum.length - 4);
          final brand = CreditCardModel.detectType(rawNum);

          final newCard = CreditCardModel(
            cardHolderName: _cardHolderController.text.trim().toUpperCase(),
            lastFour: last4,
            expiry: _expiryController.text.trim(),
            cardType: brand,
          );
          authProv.addCard(newCard);
        }
      }
    }

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
      customerName: _recipientNameController.text.trim(),
      address: finalAddressStr,
      city: finalCityStr,
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
    final authProv = context.watch<AuthProvider>();
    final cartItems = widget.directItems ?? context.read<CartProvider>().items;
    final subtotal = _calculateSubtotal(cartItems);
    final deliveryFee = _calculateDeliveryFee(subtotal);
    final total = subtotal + deliveryFee;
    final isDark = authProv.isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.primaryText(context)),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Order Summary Card ──────────────────────────────────
                    Text(
                      'Order Summary',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.primaryText(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface(context),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartItems.length,
                          separatorBuilder: (_, __) => Divider(height: 20, color: isDark ? AppColors.darkBorder : AppColors.lightGray),
                          itemBuilder: (ctx, i) {
                            final item = cartItems[i];
                            return Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    color: isDark ? AppColors.darkSurface : AppColors.lightGray,
                                    padding: const EdgeInsets.all(4),
                                    child: Image.asset(
                                      item.product.imageUrls.first,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.bolt_rounded),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: AppColors.primaryText(context),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Size: ${item.selectedSize}  •  Qty: ${item.quantity}',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.secondaryText(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${item.totalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AppColors.primaryText(context),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    // ── Recipient Basic Info ──────────────────────────────────
                    const SizedBox(height: 28),
                    Text(
                      'Contact Information',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.primaryText(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface(context),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            _buildInputField(
                              controller: _recipientNameController,
                              label: 'Recipient Full Name',
                              icon: Icons.person_outline_rounded,
                              validator: (v) => v!.trim().isEmpty ? 'Enter recipient name' : null,
                            ),
                            const SizedBox(height: 12),
                            _buildInputField(
                              controller: _phoneController,
                              label: 'Phone Number',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (v) => v!.trim().isEmpty ? 'Enter phone number' : null,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Shipping Address Picker / Input ──────────────────────
                    const SizedBox(height: 28),
                    Text(
                      'Delivery Address',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.primaryText(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        children: [
                          if (authProv.savedAddresses.isNotEmpty) ...[
                            SizedBox(
                              height: 94,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: authProv.savedAddresses.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == authProv.savedAddresses.length) {
                                    // "Enter New Address" Option Card
                                    final isSelected = _selectedAddressIndex == null;
                                    return GestureDetector(
                                      onTap: () => setState(() => _selectedAddressIndex = null),
                                      child: Container(
                                        width: 180,
                                        margin: const EdgeInsets.only(right: 12, bottom: 8),
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.orange.withValues(alpha: 0.1)
                                              : AppColors.surface(context),
                                          borderRadius: BorderRadius.circular(18),
                                          border: Border.all(
                                            color: isSelected ? AppColors.orange : Colors.transparent,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_location_alt_outlined,
                                              color: isSelected ? AppColors.orange : AppColors.mediumGray,
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Ship to New Address',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: isSelected ? AppColors.orange : AppColors.primaryText(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  final addr = authProv.savedAddresses[index];
                                  final isSelected = _selectedAddressIndex == index;

                                  return GestureDetector(
                                    onTap: () => setState(() => _selectedAddressIndex = index),
                                    child: Container(
                                      width: 220,
                                      margin: const EdgeInsets.only(right: 12, bottom: 8),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.orange.withValues(alpha: 0.1)
                                            : AppColors.surface(context),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: isSelected ? AppColors.orange : Colors.transparent,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            addr.displayLine1,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                              color: isSelected ? AppColors.orange : AppColors.primaryText(context),
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            addr.displayLine2,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: AppColors.secondaryText(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],

                          // Show manual address form if "New Address" is selected
                          if (_selectedAddressIndex == null)
                            FadeInUp(
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.surface(context),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInputField(
                                      controller: _streetController,
                                      label: 'Street Address',
                                      icon: Icons.home_outlined,
                                      validator: (v) => _selectedAddressIndex == null && v!.trim().isEmpty ? 'Street required' : null,
                                    ),
                                    const SizedBox(height: 12),
                                    _buildInputField(
                                      controller: _aptController,
                                      label: 'Apt, Suite, Unit (Optional)',
                                      icon: Icons.business_outlined,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildInputField(
                                            controller: _cityController,
                                            label: 'City',
                                            icon: Icons.location_city_outlined,
                                            validator: (v) => _selectedAddressIndex == null && v!.trim().isEmpty ? 'Required' : null,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _buildInputField(
                                            controller: _stateController,
                                            label: 'State / Region',
                                            icon: Icons.map_outlined,
                                            validator: (v) => _selectedAddressIndex == null && v!.trim().isEmpty ? 'Required' : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildInputField(
                                            controller: _zipController,
                                            label: 'ZIP / Postal Code',
                                            icon: Icons.local_post_office_outlined,
                                            keyboardType: TextInputType.number,
                                            validator: (v) => _selectedAddressIndex == null && v!.trim().isEmpty ? 'Required' : null,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _buildInputField(
                                            controller: _countryController,
                                            label: 'Country',
                                            icon: Icons.public_outlined,
                                            validator: (v) => _selectedAddressIndex == null && v!.trim().isEmpty ? 'Required' : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    CheckboxListTile(
                                      value: _saveNewAddressToProfile,
                                      onChanged: (val) => setState(() => _saveNewAddressToProfile = val ?? false),
                                      title: const Text(
                                        'Save this address to my profile',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                      activeColor: AppColors.orange,
                                      contentPadding: EdgeInsets.zero,
                                      controlAffinity: ListTileControlAffinity.leading,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // ── Payment Method Selector ──────────────────────────────
                    const SizedBox(height: 28),
                    Text(
                      'Payment Method',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.primaryText(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        children: _paymentMethods.map((method) {
                          final isSelected = _selectedPaymentMethod == method;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: AppColors.surface(context),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected ? AppColors.orange : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: RadioListTile<String>(
                              value: method,
                              groupValue: _selectedPaymentMethod,
                              title: Text(
                                method,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryText(context),
                                ),
                              ),
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
                      const SizedBox(height: 16),
                      FadeInUp(
                        duration: const Duration(milliseconds: 300),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (authProv.savedCards.isNotEmpty) ...[
                              SizedBox(
                                height: 110,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: authProv.savedCards.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == authProv.savedCards.length) {
                                      // "Enter New Card" Option
                                      final isSelected = _selectedCardIndex == null;
                                      return GestureDetector(
                                        onTap: () => setState(() => _selectedCardIndex = null),
                                        child: Container(
                                          width: 170,
                                          margin: const EdgeInsets.only(right: 12, bottom: 8),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.orange.withValues(alpha: 0.1)
                                                : AppColors.surface(context),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: isSelected ? AppColors.orange : Colors.transparent,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_card_rounded,
                                                color: isSelected ? AppColors.orange : AppColors.mediumGray,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                'Pay with New Card',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: isSelected ? AppColors.orange : AppColors.primaryText(context),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }

                                    final card = authProv.savedCards[index];
                                    final isSelected = _selectedCardIndex == index;

                                    return GestureDetector(
                                      onTap: () => setState(() => _selectedCardIndex = index),
                                      child: Container(
                                        width: 190,
                                        margin: const EdgeInsets.only(right: 12, bottom: 8),
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          gradient: isSelected
                                              ? const LinearGradient(
                                                  colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                                                )
                                              : null,
                                          color: isSelected ? null : AppColors.surface(context),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: isSelected ? AppColors.orange : Colors.transparent,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              card.cardTypeLabel.toUpperCase(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 10,
                                                color: isSelected ? Colors.white70 : AppColors.secondaryText(context),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              card.maskedDisplay,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: isSelected ? AppColors.white : AppColors.primaryText(context),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              card.cardHolderName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: isSelected ? Colors.white60 : AppColors.secondaryText(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Manual card fields if New Card is selected
                            if (_selectedCardIndex == null)
                              FadeInUp(
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface(context),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Column(
                                    children: [
                                      _buildInputField(
                                        controller: _cardHolderController,
                                        label: 'Cardholder Name',
                                        icon: Icons.person_outline_rounded,
                                        validator: (v) => _selectedPaymentMethod == 'Credit/Debit Card' &&
                                                _selectedCardIndex == null &&
                                                v!.trim().isEmpty
                                            ? 'Required'
                                            : null,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildInputField(
                                        controller: _cardNumberController,
                                        label: 'Card Number',
                                        icon: Icons.credit_card_rounded,
                                        keyboardType: TextInputType.number,
                                        validator: (v) => _selectedPaymentMethod == 'Credit/Debit Card' &&
                                                _selectedCardIndex == null &&
                                                v!.replaceAll(' ', '').length < 16
                                            ? 'Enter a valid 16-digit card number'
                                            : null,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildInputField(
                                              controller: _expiryController,
                                              label: 'Expiry (MM/YY)',
                                              icon: Icons.calendar_month_outlined,
                                              validator: (v) => _selectedPaymentMethod == 'Credit/Debit Card' &&
                                                      _selectedCardIndex == null &&
                                                      v!.isEmpty
                                                  ? 'Required'
                                                  : null,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildInputField(
                                              controller: _cvvController,
                                              label: 'CVV',
                                              icon: Icons.lock_outline_rounded,
                                              keyboardType: TextInputType.number,
                                              validator: (v) => _selectedPaymentMethod == 'Credit/Debit Card' &&
                                                      _selectedCardIndex == null &&
                                                      v!.length < 3
                                                  ? 'Required'
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      CheckboxListTile(
                                        value: _saveNewCardToProfile,
                                        onChanged: (val) => setState(() => _saveNewCardToProfile = val ?? false),
                                        title: const Text(
                                          'Save this card to my profile',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                        ),
                                        activeColor: AppColors.orange,
                                        contentPadding: EdgeInsets.zero,
                                        controlAffinity: ListTileControlAffinity.leading,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
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
                color: AppColors.surface(context),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  )
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondaryText(context)),
                        ),
                        Text(
                          '\$${subtotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.primaryText(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Fee',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondaryText(context)),
                        ),
                        Text(
                          deliveryFee == 0.0 ? 'FREE' : '\$${deliveryFee.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: deliveryFee == 0.0 ? Colors.green : AppColors.primaryText(context),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 20, color: isDark ? AppColors.darkBorder : AppColors.lightGray),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: AppTextStyles.heading3.copyWith(color: AppColors.primaryText(context)),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 19,
                            color: AppColors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _placeOrder(cartItems, subtotal, deliveryFee, total),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blackButton(context),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Place Order',
                          style: AppTextStyles.button.copyWith(
                            color: isDark ? AppColors.black : AppColors.white,
                          ),
                        ),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      style: TextStyle(color: AppColors.primaryText(context), fontSize: 13),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.mediumGray, fontSize: 12),
        prefixIcon: Icon(icon, color: AppColors.mediumGray, size: 20),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : AppColors.lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}
