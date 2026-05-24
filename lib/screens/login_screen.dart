// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/login_screen.dart — Redesigned with Nike branding + logo
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import 'signup_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final authProv = context.read<AuthProvider>();
    final success = await authProv.login(email, password);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Welcome back!'),
          backgroundColor: AppColors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ));
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Invalid email or password.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // ── Gradient background ─────────────────────────────────────────
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A1A1A), Color(0xFF2D1A00)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ── Decorative orange orb ───────────────────────────────────────
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orange.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orange.withValues(alpha: 0.08),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // ── Branded header ────────────────────────────────────────
                  SizedBox(
                    height: size.height * 0.36,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Nike Logo
                        ZoomIn(
                          duration: const Duration(milliseconds: 800),
                          child: Image.asset(
                            'assets/images/nike_logo.png',
                            height: 70,
                            color: AppColors.white,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Text(
                              'NIKE',
                              style: GoogleFonts.poppins(
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                color: AppColors.white,
                                letterSpacing: -1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          duration: const Duration(milliseconds: 600),
                          child: const Text(
                            'JUST DO IT.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 4.0,
                              color: AppColors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FadeInUp(
                          delay: const Duration(milliseconds: 450),
                          duration: const Duration(milliseconds: 600),
                          child: Text(
                            'Sign in to your Nike account',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.white.withValues(alpha: 0.55),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── White card ─────────────────────────────────────────────
                  SlideInUp(
                    duration: const Duration(milliseconds: 600),
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: size.height * 0.64),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36),
                          topRight: Radius.circular(36),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(28, 36, 28, 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInDown(
                              delay: const Duration(milliseconds: 200),
                              duration: const Duration(milliseconds: 500),
                              child: const Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            FadeInDown(
                              delay: const Duration(milliseconds: 280),
                              duration: const Duration(milliseconds: 500),
                              child: const Text(
                                'Enter your credentials to continue.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.mediumGray,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Email field
                            FadeInUp(
                              delay: const Duration(milliseconds: 200),
                              duration: const Duration(milliseconds: 500),
                              child: _buildField(
                                controller: _emailController,
                                hint: 'Email Address',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if (val == null || val.isEmpty) return 'Please enter your email';
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Password field
                            FadeInUp(
                              delay: const Duration(milliseconds: 300),
                              duration: const Duration(milliseconds: 500),
                              child: _buildField(
                                controller: _passwordController,
                                hint: 'Password',
                                icon: Icons.lock_outline_rounded,
                                obscure: _obscurePassword,
                                toggleObscure: () =>
                                    setState(() => _obscurePassword = !_obscurePassword),
                                validator: (val) {
                                  if (val == null || val.isEmpty) return 'Please enter your password';
                                  if (val.length < 6) return 'At least 6 characters';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Forgot password
                            FadeInUp(
                              delay: const Duration(milliseconds: 380),
                              duration: const Duration(milliseconds: 500),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.orange,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Sign In button
                            FadeInUp(
                              delay: const Duration(milliseconds: 450),
                              duration: const Duration(milliseconds: 500),
                              child: SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.orange,
                                    foregroundColor: AppColors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18)),
                                    elevation: 4,
                                    shadowColor: AppColors.orange.withValues(alpha: 0.4),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            color: AppColors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Sign In',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Divider
                            FadeInUp(
                              delay: const Duration(milliseconds: 500),
                              duration: const Duration(milliseconds: 500),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Divider(
                                          color: AppColors.mediumGray
                                              .withValues(alpha: 0.3))),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      'Or continue with',
                                      style: TextStyle(
                                          color: AppColors.mediumGray,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                          color: AppColors.mediumGray
                                              .withValues(alpha: 0.3))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Social buttons (UI only)
                            FadeInUp(
                              delay: const Duration(milliseconds: 560),
                              duration: const Duration(milliseconds: 500),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _socialBtn(
                                      const Text(
                                        'G',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18,
                                        ),
                                      ),
                                      'Google',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _socialBtn(
                                      const Icon(
                                        Icons.apple,
                                        color: AppColors.black,
                                        size: 20,
                                      ),
                                      'Apple',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Sign up link
                            FadeInUp(
                              delay: const Duration(milliseconds: 620),
                              duration: const Duration(milliseconds: 500),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                        color: AppColors.mediumGray,
                                        fontSize: 13),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            const SignUpScreen(),
                                        transitionsBuilder:
                                            (_, animation, __, child) =>
                                                SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(1.0, 0.0),
                                            end: Offset.zero,
                                          ).animate(CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeInOutCubic,
                                          )),
                                          child: child,
                                        ),
                                      ));
                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: AppColors.orange,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    VoidCallback? toggleObscure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: AppColors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.mediumGray, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.mediumGray, size: 20),
        suffixIcon: toggleObscure != null
            ? GestureDetector(
                onTap: toggleObscure,
                child: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.mediumGray,
                  size: 20,
                ),
              )
            : null,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.orange, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }

  Widget _socialBtn(Widget iconWidget, String label) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.mediumGray.withValues(alpha: 0.4)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
