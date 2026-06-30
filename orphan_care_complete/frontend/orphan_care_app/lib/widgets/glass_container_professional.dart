import 'package:flutter/material.dart';
import 'dart:ui';

/// مكون الحاوية الزجاجية المتقدم (Glassmorphism)
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double? height;
  final double borderRadius;
  final double opacity;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final BoxShadow? boxShadow;
  final VoidCallback? onTap;
  final bool isClickable;

  const GlassContainer({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = 16,
    this.opacity = 0.1,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(0),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderColor = const Color(0xFFFFFFFF),
    this.borderWidth = 1.5,
    this.boxShadow,
    this.onTap,
    this.isClickable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow != null
            ? [boxShadow!]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(opacity),
              border: Border.all(
                color: borderColor.withOpacity(0.3),
                width: borderWidth,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isClickable ? onTap : null,
                splashColor: Colors.white.withOpacity(0.1),
                highlightColor: Colors.white.withOpacity(0.05),
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// مكون البطاقة الزجاجية المتقدم
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final double elevation;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(8),
    this.onTap,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.elevation = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: double.infinity,
      height: null,
      borderRadius: borderRadius,
      opacity: elevation,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      onTap: onTap,
      isClickable: onTap != null,
      child: child,
    );
  }
}

/// مكون الزر الزجاجي المتقدم
class GlassButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final IconData? icon;
  final bool isLoading;
  final bool isEnabled;

  const GlassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 56,
    this.borderRadius = 12,
    this.backgroundColor = const Color(0xFFFF9500),
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
    if (widget.isEnabled && !widget.isLoading) {
      widget.onPressed();
    }
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isEnabled ? _onTapDown : null,
      onTapUp: widget.isEnabled ? _onTapUp : null,
      onTapCancel: widget.isEnabled ? _onTapCancel : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GlassContainer(
          width: widget.width,
          height: widget.height,
          borderRadius: widget.borderRadius,
          opacity: 1.0,
          backgroundColor: widget.backgroundColor,
          borderColor: widget.backgroundColor,
          borderWidth: 0,
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(widget.textColor),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: widget.textColor),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: widget.fontSize,
                          fontWeight: widget.fontWeight,
                          color: widget.textColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// مكون حقل الإدخال الزجاجي المتقدم
class GlassTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;
  final int minLines;

  const GlassTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.minLines = 1,
  });

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        GlassContainer(
          width: double.infinity,
          height: null,
          borderRadius: 12,
          opacity: 0.05,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          backgroundColor: const Color(0xFFFFFFFF),
          child: TextField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: _obscureText,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            minLines: widget.minLines,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              prefixIcon: widget.prefixIcon != null
                  ? SizedBox(
                      width: 48,
                      height: 48,
                      child: Center(
                        child: Icon(
                          widget.prefixIcon,
                          color: const Color(0xFFFF9500),
                        ),
                      ),
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
              ),
              suffixIcon: widget.suffixIcon != null
                  ? SizedBox(
                      width: 48,
                      height: 48,
                      child: GestureDetector(
                        onTap: widget.onSuffixIconPressed ??
                            (widget.obscureText
                                ? () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  }
                                : null),
                        child: Icon(
                          widget.suffixIcon,
                          color: const Color(0xFFFF9500),
                        ),
                      ),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
              ),
              hintStyle: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                color: Color(0xFFCCCCCC),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }
}
