// ─────────────────────────────────────────────────────────────────────────────
// lib/widgets/expandable_tile.dart
// Custom animated expandable section (replaces default ExpansionTile styling)
// with gorgeous dark/light mode compatibility.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class ExpandableTile extends StatefulWidget {
  final String title;
  final Widget? child;        // optional custom child
  final String? description;  // or plain text
  final VoidCallback? onTap;  // override tap (e.g. navigate to reviews)
  final bool initiallyExpanded;

  const ExpandableTile({
    super.key,
    required this.title,
    this.child,
    this.description,
    this.onTap,
    this.initiallyExpanded = false,
  });

  @override
  State<ExpandableTile> createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late AnimationController _controller;
  late Animation<double> _rotationAnim;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: _expanded ? 1.0 : 0.0,
    );
    _rotationAnim = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _expandAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasContent = widget.child != null || widget.description != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // ── Divider ──────────────────────────────────────────────────────────
        Divider(
          color: isDark ? AppColors.darkBorder : AppColors.lightGray,
          height: 1,
          thickness: 1,
        ),
        // ── Header row ───────────────────────────────────────────────────────
        InkWell(
          onTap: _toggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.primaryText(context),
                  ),
                ),
                RotationTransition(
                  turns: _rotationAnim,
                  child: Icon(
                    widget.onTap != null
                        ? Icons.arrow_forward_ios_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppColors.secondaryText(context),
                  ),
                ),
              ],
            ),
          ),
        ),
        // ── Expandable content ────────────────────────────────────────────────
        if (hasContent && widget.onTap == null)
          SizeTransition(
            sizeFactor: _expandAnim,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: widget.child ??
                  Text(
                    widget.description!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.secondaryText(context),
                    ),
                  ),
            ),
          ),
      ],
    );
  }
}
