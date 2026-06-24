import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

const double donorMobileMaxWidth = 430;
const double donorRadius = 18;

PreferredSizeWidget donorMobileAppBar({
  required String title,
  Widget? leading,
  List<Widget>? actions,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(64),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: donorMobileMaxWidth),
        child: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleSpacing: 8,
          leadingWidth: 56,
          leading: leading,
          title: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.textDarkPrimary,
            ),
          ),
          actions: actions,
        ),
      ),
    ),
  );
}

Widget donorMobileBottomBar({
  required Widget child,
  double height = 72,
}) {
  return SizedBox(
    height: height,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: donorMobileMaxWidth),
        child: child,
      ),
    ),
  );
}

Widget donorBackButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsetsDirectional.only(start: 12),
    child: DonorCircleButton(
      icon: Icons.arrow_back_ios_new_rounded,
      tooltip: 'رجوع',
      onTap: () => Navigator.of(context).pop(),
    ),
  );
}

class DonorBackground extends StatelessWidget {
  const DonorBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.white, AppColors.scaffoldBackground],
        ),
      ),
    );
  }
}

class DonorCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final VoidCallback? onTap;

  const DonorCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(donorRadius),
        border: Border.all(color: AppColors.innerBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.innerShadow.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(donorRadius),
        child: content,
      ),
    );
  }
}

class DonorIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const DonorIconBox({
    super.key,
    required this.icon,
    required this.color,
    this.size = 46,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.24)),
      ),
      child: Icon(icon, color: color, size: size * 0.48),
    );
  }
}

class DonorCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const DonorCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.innerBorder),
        ),
        child: Icon(icon, color: AppColors.textDarkPrimary, size: 19),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

class DonorBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const DonorBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class DonorPrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  const DonorPrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = AppColors.brandOrange,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        backgroundColor: color,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.innerBorder,
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class DonorSecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  const DonorSecondaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = AppColors.textDarkSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        foregroundColor: color,
        side: BorderSide(color: color.withOpacity(0.45)),
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class DonorEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const DonorEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: DonorCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  color: AppColors.textDarkMuted.withOpacity(0.45), size: 52),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDarkPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                  height: 1.45,
                  color: AppColors.textDarkSecondary,
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 14),
                TextButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.arrow_back_rounded, size: 17),
                  label: Text(actionLabel!),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.brandOrangeDark,
                    textStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

Color donorStatusColor(String value) {
  if (value.contains('عاجل') || value.contains('جديد')) {
    return AppColors.brandOrangeDark;
  }
  if (value.contains('مكتمل') ||
      value.contains('مقبول') ||
      value.contains('تم')) {
    return AppColors.successGreen;
  }
  if (value.contains('مرفوض') || value.contains('فشل')) {
    return AppColors.errorRed;
  }
  return AppColors.skyBlueDark;
}
