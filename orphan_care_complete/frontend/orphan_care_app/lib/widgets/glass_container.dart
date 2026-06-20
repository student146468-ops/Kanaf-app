import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart'; // استيراد الألوان للربط الهندي المباشر

/// [GlassContainer] - القالب الزجاجي الموحد والمطور المعتمد لتطبيق "كَنَفْ" لعام 2026.
/// تم بناؤه بالربط التام مع [AppColors] لتوحيد الشفافية والـ Blur ومنع أي هزة بصرية.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 24.0, // زوايا منحنية ناعمة وانسيابية لعام 2026
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          // تثبيت درجة الضبابية (Blur) هندسياً لراحة العين ومنع اهتزاز التصميم
          filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20.0), // توحيد الـ Padding الافتراضي لجميع الواجهات
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              // استدعاء الشفافية الثابتة 25% من ملف الألوان مباشرة (0 Errors)
              color: AppColors.glassBackground,
              border: Border.all(
                color: AppColors.glassBorder, // لمعة الكريستال الموحدة على الحواف
                width: 0.9,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.glassShadow, // ظل ناعم غير مشتت يعطي عمق ثلاثي الأبعاد
                  blurRadius: 32,
                  offset: Offset(0, 18),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
