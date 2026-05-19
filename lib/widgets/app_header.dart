// ─────────────────────────────────────────────────────────────────────────────
// lib/widgets/app_header.dart
// Shared top header: back button | Nike logo | cart badge
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  const AppHeader({super.key, this.showBack = true});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalCount;

    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      // ── Back button ─────────────────────────────────────────────────────────
      leading: showBack
          ? Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: _CircleIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.maybePop(context),
              ),
            )
          : null,
      // ── Nike logo ───────────────────────────────────────────────────────────
      title: _NikeLogo(),
      // ── Cart icon with badge ─────────────────────────────────────────────────
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: _CartBadge(count: cartCount),
        ),
      ],
    );
  }
}

// ── Circular icon button (back, etc.) ─────────────────────────────────────────
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: AppColors.black),
      ),
    );
  }
}

// ── Cart badge icon ───────────────────────────────────────────────────────────
class _CartBadge extends StatelessWidget {
  final int count;
  const _CartBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => const CartScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.white,
              size: 20,
            ),
          ),
          // Orange badge – only visible when count > 0
          if (count > 0)
            Positioned(
              top: -4,
              right: -4,
              child: AnimatedScale(
                scale: count > 0 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    count > 9 ? '9+' : '$count',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Nike logo text widget ──────────────────────────────────────────────────────
class _NikeLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Nike',
      style: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
        color: AppColors.black,
        letterSpacing: -0.5,
      ),
    );
  }
}
