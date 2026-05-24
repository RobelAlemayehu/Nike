// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/profile_screen.dart
// Beautiful profile editor, avatar uploader, full address list & card saver
// ─────────────────────────────────────────────────────────────────────────────
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../providers/auth_provider.dart';
import '../models/address_model.dart';
import '../models/credit_card_model.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<String> _avatarPresets = [
    '👟', '🔥', '⚡', '🏃', '⭐', '🏀'
  ];

  Future<void> _pickAvatarImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (image != null) {
        if (mounted) {
          final auth = context.read<AuthProvider>();
          await auth.updateProfile(auth.userName, avatarPath: image.path);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated successfully!'),
              backgroundColor: AppColors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showEditProfileDialog() {
    final auth = context.read<AuthProvider>();
    final controller = TextEditingController(text: auth.userName);
    String selectedEmoji = auth.avatarPath.length == 2 ? auth.avatarPath : '👟';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                style: TextStyle(color: AppColors.primaryText(context)),
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: const TextStyle(color: AppColors.mediumGray),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkSurface
                      : AppColors.lightGray,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Choose a Preset Emoji:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _avatarPresets.map((emoji) {
                  final isSelected = selectedEmoji == emoji;
                  return GestureDetector(
                    onTap: () {
                      setDialogState(() => selectedEmoji = emoji);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.orange.withValues(alpha: 0.15)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.orange : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _pickAvatarImage();
                  },
                  icon: const Icon(Icons.photo_library_outlined, color: AppColors.orange),
                  label: const Text(
                    'Upload Photo instead',
                    style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.mediumGray)),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  auth.updateProfile(
                    controller.text.trim(),
                    avatarPath: selectedEmoji,
                  );
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save', style: TextStyle(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAddressDialog() {
    final streetCtrl = TextEditingController();
    final aptCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final stateCtrl = TextEditingController();
    final zipCtrl = TextEditingController();
    final countryCtrl = TextEditingController(text: 'United States');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.mediumGray.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Add New Address 📍',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: AppColors.primaryText(context)),
                ),
                const SizedBox(height: 16),
                _buildSheetField(
                  controller: streetCtrl,
                  label: 'Street Address',
                  icon: Icons.home_outlined,
                  validator: (v) => v!.isEmpty ? 'Please enter street' : null,
                ),
                const SizedBox(height: 12),
                _buildSheetField(
                  controller: aptCtrl,
                  label: 'Apt, Suite, Unit (Optional)',
                  icon: Icons.business_outlined,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSheetField(
                        controller: cityCtrl,
                        label: 'City',
                        icon: Icons.location_city_outlined,
                        validator: (v) => v!.isEmpty ? 'City required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSheetField(
                        controller: stateCtrl,
                        label: 'State / Region',
                        icon: Icons.map_outlined,
                        validator: (v) => v!.isEmpty ? 'State required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSheetField(
                        controller: zipCtrl,
                        label: 'ZIP / Postal Code',
                        icon: Icons.local_post_office_outlined,
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'ZIP required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSheetField(
                        controller: countryCtrl,
                        label: 'Country',
                        icon: Icons.public_outlined,
                        validator: (v) => v!.isEmpty ? 'Country required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final address = AddressModel(
                          street: streetCtrl.text.trim(),
                          apt: aptCtrl.text.trim(),
                          city: cityCtrl.text.trim(),
                          state: stateCtrl.text.trim(),
                          zip: zipCtrl.text.trim(),
                          country: countryCtrl.text.trim(),
                        );
                        context.read<AuthProvider>().addAddress(address);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Address saved successfully!'),
                            backgroundColor: AppColors.orange,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save Address',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddCardDialog() {
    final holderCtrl = TextEditingController();
    final numberCtrl = TextEditingController();
    final expiryCtrl = TextEditingController();
    final cvvCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.mediumGray.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Add New Card 💳',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: AppColors.primaryText(context)),
                ),
                const SizedBox(height: 16),
                _buildSheetField(
                  controller: holderCtrl,
                  label: 'Cardholder Name',
                  icon: Icons.person_outline_rounded,
                  validator: (v) => v!.isEmpty ? 'Name required' : null,
                ),
                const SizedBox(height: 12),
                _buildSheetField(
                  controller: numberCtrl,
                  label: 'Card Number',
                  icon: Icons.credit_card_rounded,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.length < 16 ? 'Enter a valid 16-digit card number' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSheetField(
                        controller: expiryCtrl,
                        label: 'Expiry (MM/YY)',
                        icon: Icons.calendar_month_outlined,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSheetField(
                        controller: cvvCtrl,
                        label: 'CVV',
                        icon: Icons.lock_outline_rounded,
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.length < 3 ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final rawNum = numberCtrl.text.replaceAll(' ', '');
                        final last4 = rawNum.substring(rawNum.length - 4);
                        final detected = CreditCardModel.detectType(rawNum);

                        final card = CreditCardModel(
                          cardHolderName: holderCtrl.text.trim().toUpperCase(),
                          lastFour: last4,
                          expiry: expiryCtrl.text.trim(),
                          cardType: detected,
                        );

                        context.read<AuthProvider>().addCard(card);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Card added successfully!'),
                            backgroundColor: AppColors.orange,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save Credit Card',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSheetField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: AppColors.primaryText(context), fontSize: 14),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.mediumGray, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.mediumGray, size: 20),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : AppColors.lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AuthProvider>();
    final isDark = authProv.isDarkMode;

    Widget avatarWidget;
    if (authProv.avatarPath.length == 2) {
      // EMOJI PRESET
      avatarWidget = Text(
        authProv.avatarPath,
        style: const TextStyle(fontSize: 34),
      );
    } else if (authProv.avatarPath.isNotEmpty) {
      // IMAGE FILE PATH / URL
      final file = File(authProv.avatarPath);
      avatarWidget = ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: file.existsSync()
            ? Image.file(file, fit: BoxFit.cover, width: 80, height: 80)
            : Image.network(
                authProv.avatarPath,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
                errorBuilder: (_, __, ___) => const Text('👟', style: TextStyle(fontSize: 34)),
              ),
      );
    } else {
      // DEFAULT FALLBACK
      avatarWidget = const Text(
        '👟',
        style: TextStyle(fontSize: 34),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
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
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _showEditProfileDialog,
                        child: Container(
                          width: 74,
                          height: 74,
                          decoration: BoxDecoration(
                            color: AppColors.orangeLight,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.orange, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: avatarWidget,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authProv.userName,
                              style: AppTextStyles.heading2.copyWith(
                                color: AppColors.primaryText(context),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              authProv.userEmail.isNotEmpty ? authProv.userEmail : 'nike.member@nike.com',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.secondaryText(context),
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: _showEditProfileDialog,
                              child: Row(
                                children: [
                                  const Icon(Icons.edit_outlined, size: 14, color: AppColors.orange),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      color: AppColors.orange,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.lightGray,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // ── Member Stats Summary ──────────────────────────────────────
              const SizedBox(height: 24),
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        title: 'Total Spent',
                        val: '\$${authProv.totalSpent.toStringAsFixed(2)}',
                        icon: Icons.analytics_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        title: 'Orders Placed',
                        val: '${authProv.totalOrders}',
                        icon: Icons.shopping_bag_outlined,
                      ),
                    ),
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
                    Text(
                      'Saved Addresses',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.primaryText(context),
                      ),
                    ),
                    GestureDetector(
                      onTap: _showAddAddressDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.add_circle_outline_rounded, color: AppColors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Add New',
                              style: TextStyle(
                                color: AppColors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              authProv.savedAddresses.isEmpty
                  ? FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: _buildEmptyState(
                        context,
                        msg: 'No addresses saved yet. Add one for a faster checkout!',
                        icon: Icons.location_on_outlined,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: authProv.savedAddresses.length,
                      itemBuilder: (context, index) {
                        final addr = authProv.savedAddresses[index];
                        return FadeInUp(
                          delay: Duration(milliseconds: 50 * index),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface(context),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : Colors.transparent,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.orange.withValues(alpha: 0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.location_on_rounded, color: AppColors.orange, size: 20),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        addr.displayLine1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: AppColors.primaryText(context),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        addr.displayLine2,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.secondaryText(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                  onPressed: () => authProv.removeAddress(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

              // ── Saved Credit Cards Section ──────────────────────────────
              const SizedBox(height: 28),
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Saved Cards',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.primaryText(context),
                      ),
                    ),
                    GestureDetector(
                      onTap: _showAddCardDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.credit_card_outlined, color: AppColors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Add New',
                              style: TextStyle(
                                color: AppColors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              authProv.savedCards.isEmpty
                  ? FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: _buildEmptyState(
                        context,
                        msg: 'No credit cards saved. Stored cards are fully encrypted.',
                        icon: Icons.credit_card_rounded,
                      ),
                    )
                  : SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: authProv.savedCards.length,
                        itemBuilder: (context, index) {
                          final card = authProv.savedCards[index];
                          return FadeInUp(
                            delay: Duration(milliseconds: 50 * index),
                            child: _buildCreditCardUI(context, card, index),
                          );
                        },
                      ),
                    ),

              // ── Settings Section ──────────────────────────────────────────
              const SizedBox(height: 32),
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  'Settings',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.primaryText(context),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SwitchListTile.adaptive(
                        value: authProv.isDarkMode,
                        onChanged: (val) => authProv.toggleDarkMode(),
                        title: Text('Dark Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryText(context))),
                        subtitle: Text('Enable dark theme throughout the app', style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText(context))),
                        activeColor: AppColors.orange,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      ),
                      Divider(height: 1, indent: 16, endIndent: 16, color: isDark ? AppColors.darkBorder : AppColors.lightGray),
                      SwitchListTile.adaptive(
                        value: authProv.notificationsEnabled,
                        onChanged: (val) => authProv.toggleNotifications(),
                        title: Text('Notifications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryText(context))),
                        subtitle: Text('Get updates on order status and sales', style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryText(context))),
                        activeColor: AppColors.orange,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String val,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.orange, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryText(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  val,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, {required String msg, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface(context).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.mediumGray.withValues(alpha: 0.15),
          style: BorderStyle.none,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.mediumGray.withValues(alpha: 0.6), size: 36),
          const SizedBox(height: 8),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryText(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCardUI(BuildContext context, CreditCardModel card, int index) {
    // Elegant high-tech credit card gradient
    final gradient = index % 2 == 0
        ? const LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.cardTypeLabel.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 1.0,
                ),
              ),
              // Delete card
              GestureDetector(
                onTap: () {
                  context.read<AuthProvider>().removeCard(index);
                },
                child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 20),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.maskedDisplay,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CARDHOLDER',
                          style: TextStyle(color: Colors.white60, fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          card.cardHolderName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'EXPIRES',
                        style: TextStyle(color: Colors.white60, fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        card.expiry,
                        style: const TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
