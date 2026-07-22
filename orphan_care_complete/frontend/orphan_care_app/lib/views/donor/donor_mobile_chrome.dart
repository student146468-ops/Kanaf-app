import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

const double donorMobileMaxWidth = 430;
const double donorAppBarHeight = 64;
const double donorHorizontalPadding = 20;
const double donorRadius = 18;
const double donorRadiusMedium = 16;
const double donorRadiusSmall = 12;
const double donorRadiusPill = 999;
const double donorIconBoxSize = 46;
const double donorIconSize = 20;
const double donorCardShadowBlur = 14;
const Offset donorCardShadowOffset = Offset(0, 7);

class DonorSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 10;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;

  const DonorSpacing._();
}

class DonorRadii {
  static const BorderRadius small =
      BorderRadius.all(Radius.circular(donorRadiusSmall));
  static const BorderRadius medium =
      BorderRadius.all(Radius.circular(donorRadiusMedium));
  static const BorderRadius large =
      BorderRadius.all(Radius.circular(donorRadius));
  static const BorderRadius pill =
      BorderRadius.all(Radius.circular(donorRadiusPill));

  const DonorRadii._();
}

class DonorTextStyles {
  static const TextStyle title = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 18,
    fontWeight: FontWeight.w900,
    color: AppColors.textDarkPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 15,
    fontWeight: FontWeight.w900,
    color: AppColors.textDarkPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 14,
    height: 1.5,
    color: AppColors.textDarkSecondary,
  );

  static const TextStyle muted = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 13,
    color: AppColors.textDarkMuted,
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11.5,
    fontWeight: FontWeight.w800,
  );

  const DonorTextStyles._();
}

PreferredSizeWidget donorMobileAppBar({
  required String title,
  Widget? leading,
  List<Widget>? actions,
}) {
  return DonorTopBar(title: title, leading: leading, actions: actions);
}

class DonorTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  const DonorTopBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(donorAppBarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
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
              style: DonorTextStyles.title,
            ),
            actions: actions,
          ),
        ),
      ),
    );
  }
}

class DonorTopBarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const DonorTopBarActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return DonorCircleButton(icon: icon, onTap: onTap, tooltip: tooltip);
  }
}

class DonorMobileFrame extends StatelessWidget {
  final Widget child;

  const DonorMobileFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: donorMobileMaxWidth),
        child: child,
      ),
    );
  }
}

class DonorBottomBar extends StatelessWidget {
  final Widget child;
  final double height;

  const DonorBottomBar({
    super.key,
    required this.child,
    this.height = 72,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, child: DonorMobileFrame(child: child));
  }
}

Widget donorMobileBottomBar({
  required Widget child,
  double height = 72,
}) {
  return DonorBottomBar(height: height, child: child);
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
    this.padding = const EdgeInsets.all(DonorSpacing.lg),
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
            blurRadius: donorCardShadowBlur,
            offset: donorCardShadowOffset,
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
    this.size = donorIconBoxSize,
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

class DonorStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const DonorStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DonorBadge(label: label, color: color, icon: icon);
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
        borderRadius: BorderRadius.circular(donorRadiusPill),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 5),
          ],
          Text(label, style: DonorTextStyles.badge.copyWith(color: color)),
        ],
      ),
    );
  }
}

class DonorSectionTitle extends StatelessWidget {
  final String title;

  const DonorSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: DonorTextStyles.sectionTitle);
  }
}

class DonorFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final IconData? icon;
  final Color selectedColor;
  final Color backgroundColor;
  final Color unselectedTextColor;
  final Color selectedTextColor;
  final FontWeight fontWeight;
  final double fontSize;
  final EdgeInsetsGeometry? labelPadding;

  const DonorFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
    this.selectedColor = AppColors.brandOrange,
    this.backgroundColor = Colors.white,
    this.unselectedTextColor = AppColors.textDarkSecondary,
    this.selectedTextColor = Colors.white,
    this.fontWeight = FontWeight.w800,
    this.fontSize = 12.5,
    this.labelPadding,
  });

  @override
  Widget build(BuildContext context) {
    final labelWidget = labelPadding == null
        ? Text(label)
        : Padding(padding: labelPadding!, child: Text(label));

    return ChoiceChip(
      avatar: icon == null
          ? null
          : Icon(
              icon,
              size: 17,
              color: selected ? selectedTextColor : unselectedTextColor,
            ),
      label: labelWidget,
      selected: selected,
      showCheckmark: false,
      selectedColor: selectedColor,
      backgroundColor: backgroundColor,
      side: BorderSide(
        color: selected ? selectedColor : AppColors.innerBorder,
      ),
      labelStyle: TextStyle(
        fontFamily: 'Cairo',
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: selected ? selectedTextColor : unselectedTextColor,
      ),
      onSelected: onSelected,
    );
  }
}

class DonorInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixIconWidget;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSuffixTap;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final TextAlign textAlign;
  final Color iconColor;
  final Color focusedBorderColor;
  final Color fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final bool useFormField;
  final double enabledBorderWidth;
  final double focusedBorderWidth;
  final double errorBorderWidth;

  const DonorInputField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconWidget,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onSuffixTap,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.style,
    this.hintStyle,
    this.labelStyle,
    this.errorStyle,
    this.textAlign = TextAlign.start,
    this.iconColor = AppColors.brandOrange,
    this.focusedBorderColor = AppColors.brandOrange,
    this.fillColor = Colors.white,
    this.contentPadding,
    this.useFormField = false,
    this.enabledBorderWidth = 1.2,
    this.focusedBorderWidth = 1.2,
    this.errorBorderWidth = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      errorStyle: errorStyle,
      prefixIcon:
          prefixIcon == null ? null : Icon(prefixIcon, color: iconColor),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 48,
        minHeight: 48,
      ),
      suffixIcon: suffixIconWidget ??
          (suffixIcon == null
              ? null
              : IconButton(
                  tooltip: null,
                  icon: Icon(suffixIcon, color: AppColors.textDarkMuted),
                  onPressed: onSuffixTap,
                )),
      suffixIconConstraints: const BoxConstraints(
        minWidth: 48,
        minHeight: 48,
      ),
      labelStyle: labelStyle,
      hintStyle: hintStyle,
      filled: true,
      fillColor: fillColor,
      contentPadding: contentPadding,
      enabledBorder: donorInputBorder(
        AppColors.innerBorder,
        width: enabledBorderWidth,
      ),
      focusedBorder: donorInputBorder(
        focusedBorderColor,
        width: focusedBorderWidth,
      ),
      errorBorder:
          donorInputBorder(AppColors.errorRed, width: errorBorderWidth),
      focusedErrorBorder:
          donorInputBorder(AppColors.errorRed, width: errorBorderWidth),
    );

    if (useFormField || validator != null) {
      return TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textInputAction: textInputAction ??
            (maxLines == 1 ? TextInputAction.next : TextInputAction.newline),
        validator: validator,
        onChanged: onChanged,
        textAlign: textAlign,
        style: style,
        decoration: decoration,
      );
    }

    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      textAlign: textAlign,
      style: style,
      decoration: decoration,
    );
  }
}

OutlineInputBorder donorInputBorder(Color color, {double width = 1.2}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(donorRadiusMedium),
    borderSide: BorderSide(color: color, width: width),
  );
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
        textStyle: DonorTextStyles.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(donorRadiusMedium),
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
        textStyle: DonorTextStyles.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(donorRadiusMedium),
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
                style: DonorTextStyles.sectionTitle,
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: DonorTextStyles.body.copyWith(fontSize: 13),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 14),
                TextButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.arrow_back_rounded, size: 17),
                  label: Text(actionLabel!),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.brandOrangeDark,
                    textStyle: DonorTextStyles.button.copyWith(fontSize: 12.5),
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
