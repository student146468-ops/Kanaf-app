import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

const String careHomeFontFamily = 'Vazirmatn';

const double careHomeMobileMaxWidth = 480;
const double careHomeAppBarHeight = 64;
const double careHomeHorizontalPadding = 20;
const double careHomeCardPadding = 18;
const double careHomeRadiusSmall = 12;
const double careHomeRadiusMedium = 16;
const double careHomeRadiusLarge = 18;
const double careHomeRadiusPill = 999;
const double careHomeIconSizeSmall = 16;
const double careHomeIconSize = 20;
const double careHomeIconSizeLarge = 24;
const double careHomeIconBoxSize = 44;

class CareHomeSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;

  const CareHomeSpacing._();
}

class CareHomeRadii {
  static const BorderRadius small =
      BorderRadius.all(Radius.circular(careHomeRadiusSmall));
  static const BorderRadius medium =
      BorderRadius.all(Radius.circular(careHomeRadiusMedium));
  static const BorderRadius large =
      BorderRadius.all(Radius.circular(careHomeRadiusLarge));
  static const BorderRadius pill =
      BorderRadius.all(Radius.circular(careHomeRadiusPill));

  const CareHomeRadii._();
}

class CareHomeTextStyles {
  static const TextStyle pageTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkSecondary,
    fontSize: 13.5,
    height: 1.5,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkMuted,
    fontSize: 12.5,
    height: 1.45,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle button = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 11.5,
    height: 1,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle statsNumber = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkPrimary,
    fontSize: 22,
    height: 1,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle title = pageTitle;
  static const TextStyle body = bodyText;
  static const TextStyle muted = caption;
  static const TextStyle buttonText = button;

  const CareHomeTextStyles._();
}

Color _careHomeTint(Color color, double opacity) {
  return color.withAlpha((opacity * 255).round());
}

class CareHomeMobileFrame extends StatelessWidget {
  final Widget child;

  const CareHomeMobileFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final careHomeTheme = theme.copyWith(
      textTheme: theme.textTheme.apply(fontFamily: careHomeFontFamily),
      primaryTextTheme:
          theme.primaryTextTheme.apply(fontFamily: careHomeFontFamily),
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SizedBox(
              width: constraints.maxWidth < careHomeMobileMaxWidth
                  ? constraints.maxWidth
                  : careHomeMobileMaxWidth,
              height: constraints.maxHeight,
              child: Theme(
                data: careHomeTheme,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}

class CareHomeAppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;

  const CareHomeAppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CareHomeMobileFrame(
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(careHomeAppBarHeight),
            child: CareHomeAppBar(
              title: title,
              showBackButton: showBack,
              onBack: onBack,
              actions: actions,
            ),
          ),
          body: body,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }
}

class CareHomeAppBar extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? leading;
  final bool includeSafeArea;
  final bool showShadow;
  final Color backgroundColor;

  const CareHomeAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.showBackButton = true,
    this.onBack,
    this.actions,
    this.leading,
    this.includeSafeArea = true,
    this.showShadow = true,
    this.backgroundColor = AppColors.cardBackground,
  });

  @override
  Widget build(BuildContext context) {
    final hasActions = actions != null && actions!.isNotEmpty;
    final titlePadding =
        hasActions || leading != null || showBackButton ? 62.0 : 12.0;
    final bar = Container(
      width: double.infinity,
      height: careHomeAppBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(careHomeRadiusLarge + 2),
        ),
        border: showShadow ? Border.all(color: AppColors.innerBorder) : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: _careHomeTint(Colors.black, 0.035),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: 0,
            child: leading ?? _buildBackSlot(context),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: titlePadding),
            child: _buildTitleBlock(),
          ),
          if (hasActions)
            PositionedDirectional(
              end: 0,
              top: 0,
              bottom: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              ),
            ),
        ],
      ),
    );

    if (!includeSafeArea) return bar;
    return SafeArea(bottom: false, child: bar);
  }

  Widget _buildBackSlot(BuildContext context) {
    if (!showBackButton) return const SizedBox(width: 46);

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onBack ?? () => Navigator.maybePop(context),
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            isRtl
                ? Icons.arrow_forward_ios_rounded
                : Icons.arrow_back_ios_new_rounded,
            color: AppColors.textDarkPrimary,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBlock() {
    final resolvedTitle = title ?? '';
    final resolvedSubtitle = subtitle;

    if (resolvedSubtitle == null || resolvedSubtitle.isEmpty) {
      return Text(
        resolvedTitle,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: CareHomeTextStyles.title,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          resolvedTitle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: CareHomeTextStyles.title,
        ),
        const SizedBox(height: 2),
        Text(
          resolvedSubtitle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: CareHomeTextStyles.muted.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}

class CareHomeTopBar extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? leading;
  final bool includeSafeArea;
  final bool showShadow;
  final Color backgroundColor;

  const CareHomeTopBar({
    super.key,
    this.title,
    this.subtitle,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.leading,
    this.includeSafeArea = true,
    this.showShadow = true,
    this.backgroundColor = AppColors.cardBackground,
  });

  @override
  Widget build(BuildContext context) {
    return CareHomeAppBar(
      title: title,
      subtitle: subtitle,
      showBackButton: showBack,
      onBack: onBack,
      actions: actions,
      leading: leading,
      includeSafeArea: includeSafeArea,
      showShadow: showShadow,
      backgroundColor: backgroundColor,
    );
  }
}

class CareHomeTopBarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final Color? color;
  final Color? backgroundColor;

  const CareHomeTopBarActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor = color ?? AppColors.textDarkPrimary;
    final button = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.cardBackground,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.innerBorder),
        ),
        child: Icon(icon, color: foregroundColor, size: 19),
      ),
    );

    if (tooltip == null || tooltip!.isEmpty) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

class CareHomeBottomNavigationItem {
  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final int? badgeCount;

  const CareHomeBottomNavigationItem({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.badgeCount,
  });
}

class CareHomeBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final List<CareHomeBottomNavigationItem> items;
  final ValueChanged<int> onTap;
  final Color activeColor;
  final Color inactiveColor;
  final EdgeInsetsGeometry margin;

  const CareHomeBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
    this.activeColor = AppColors.brandOrange,
    this.inactiveColor = AppColors.textDarkMuted,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: margin,
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(careHomeRadiusLarge + 4),
          ),
          boxShadow: [
            BoxShadow(
              color: _careHomeTint(Colors.black, 0.05),
              blurRadius: 18,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            return Expanded(
              child: _CareHomeBottomNavigationTile(
                item: item,
                selected: index == currentIndex,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => onTap(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _CareHomeBottomNavigationTile extends StatelessWidget {
  final CareHomeBottomNavigationItem item;
  final bool selected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _CareHomeBottomNavigationTile({
    required this.item,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? activeColor : inactiveColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(careHomeRadiusMedium),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
          decoration: BoxDecoration(
            color: selected
                ? _careHomeTint(activeColor, 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(careHomeRadiusMedium),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 25,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      selected ? item.selectedIcon ?? item.icon : item.icon,
                      color: color,
                      size: 22,
                    ),
                    if ((item.badgeCount ?? 0) > 0)
                      PositionedDirectional(
                        top: -4,
                        end: -9,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 16),
                          height: 16,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: const BoxDecoration(
                            color: AppColors.errorRed,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            item.badgeCount! > 9 ? '9+' : '${item.badgeCount}',
                            style: CareHomeTextStyles.badge.copyWith(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CareHomeTextStyles.caption.copyWith(
                  color: color,
                  fontSize: 10.5,
                  height: 1.1,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CareHomeIconCircle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color? backgroundColor;
  final double size;
  final double iconSize;

  const CareHomeIconCircle({
    super.key,
    required this.icon,
    this.color = AppColors.brandOrange,
    this.backgroundColor,
    this.size = careHomeIconBoxSize,
    this.iconSize = careHomeIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? _careHomeTint(color, 0.10),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: iconSize),
    );
  }
}

class CareHomeCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double elevation;
  final Color shadowColor;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  const CareHomeCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 18.0,
    this.color = AppColors.cardBackground,
    this.borderColor = AppColors.innerBorder,
    this.borderWidth = 1,
    this.elevation = 1.5,
    this.shadowColor = const Color(0x14000000),
    this.onTap,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final content = Container(
      padding: padding ?? const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: child,
    );

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: Material(
        color: color,
        elevation: elevation,
        shadowColor: shadowColor,
        borderRadius: radius,
        clipBehavior: clipBehavior,
        child: onTap == null
            ? content
            : InkWell(
                onTap: onTap,
                borderRadius: radius,
                child: content,
              ),
      ),
    );
  }
}

class CareHomeIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final double borderRadius;
  final BoxShape shape;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;

  const CareHomeIconBox({
    super.key,
    required this.icon,
    this.color = AppColors.brandOrange,
    this.size = careHomeIconBoxSize,
    this.iconSize = careHomeIconSize,
    this.backgroundColor,
    this.borderRadius = 14,
    this.shape = BoxShape.rectangle,
    this.borderColor,
    this.borderWidth = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final box = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? _careHomeTint(color, 0.10),
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : radius,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: borderWidth),
      ),
      child: Icon(icon, color: color, size: iconSize),
    );

    if (onTap == null) return box;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: shape == BoxShape.circle ? null : radius,
        customBorder: shape == BoxShape.circle ? const CircleBorder() : null,
        child: box,
      ),
    );
  }
}

class CareHomePrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;
  final double height;
  final double? width;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? disabledBackgroundColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final double iconSize;

  const CareHomePrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.height = 54,
    this.width = double.infinity,
    this.backgroundColor = AppColors.brandOrange,
    this.foregroundColor = Colors.white,
    this.disabledBackgroundColor,
    this.borderRadius = careHomeRadiusMedium,
    this.textStyle,
    this.padding,
    this.iconSize = 19,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor:
          disabledBackgroundColor ?? _careHomeTint(backgroundColor, 0.55),
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      textStyle: textStyle ?? CareHomeTextStyles.button,
    );

    final effectiveTextStyle = textStyle ?? CareHomeTextStyles.button;
    final labelWidget = Text(label, style: effectiveTextStyle);
    final iconWidget = loading
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.2,
            ),
          )
        : icon == null
            ? null
            : Icon(icon, size: iconSize);

    return SizedBox(
      height: height,
      width: width,
      child: iconWidget == null
          ? ElevatedButton(
              onPressed: loading ? null : onPressed,
              style: buttonStyle,
              child: labelWidget,
            )
          : ElevatedButton.icon(
              onPressed: loading ? null : onPressed,
              style: buttonStyle,
              icon: iconWidget,
              label: labelWidget,
            ),
    );
  }
}

class CareHomeSecondaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color foregroundColor;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final double iconSize;

  const CareHomeSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.width,
    this.height,
    this.foregroundColor = AppColors.brandOrangeDark,
    Color? borderColor,
    this.borderRadius = careHomeRadiusMedium,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    this.textStyle,
    this.iconSize = 18,
  }) : borderColor = borderColor ?? AppColors.brandOrange;

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      foregroundColor: foregroundColor,
      side: BorderSide(color: _careHomeTint(borderColor, 0.35)),
      textStyle: textStyle ?? CareHomeTextStyles.button,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    final button = icon == null
        ? OutlinedButton(
            onPressed: onPressed,
            style: style,
            child: Text(label),
          )
        : OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: iconSize),
            label: Text(label),
            style: style,
          );

    return SizedBox(
      width: width,
      height: height,
      child: button,
    );
  }
}

class CareHomeInputField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String label;
  final String? hint;
  final IconData? icon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final AutovalidateMode? autovalidateMode;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? prefixIconPadding;
  final BoxConstraints? prefixIconConstraints;
  final Color fillColor;
  final Color iconColor;
  final Color? focusedIconColor;
  final Color cursorColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final Color? focusedErrorBorderColor;
  final double borderWidth;
  final double focusedBorderWidth;
  final double borderRadius;
  final bool useOuterAnimatedBorder;
  final Duration outerBorderAnimationDuration;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;

  const CareHomeInputField({
    super.key,
    this.controller,
    this.focusNode,
    required this.label,
    this.hint,
    this.icon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.autovalidateMode,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    this.prefixIconPadding,
    this.prefixIconConstraints,
    this.fillColor = AppColors.surfaceLight,
    this.iconColor = AppColors.brandOrange,
    this.focusedIconColor,
    this.cursorColor = AppColors.brandOrange,
    this.borderColor = AppColors.innerBorder,
    this.focusedBorderColor = AppColors.brandOrange,
    this.errorBorderColor = AppColors.errorRed,
    this.focusedErrorBorderColor,
    this.borderWidth = 1,
    this.focusedBorderWidth = 1.4,
    this.borderRadius = careHomeRadiusMedium,
    this.useOuterAnimatedBorder = false,
    this.outerBorderAnimationDuration = const Duration(milliseconds: 200),
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isFocused = focusNode?.hasFocus ?? false;
    final effectiveBorderColor = isFocused ? focusedBorderColor : borderColor;
    final effectiveBorderWidth = isFocused ? focusedBorderWidth : borderWidth;
    final effectiveIconColor =
        isFocused ? focusedIconColor ?? iconColor : iconColor;
    final prefixIconWidget = icon == null
        ? null
        : Padding(
            padding: prefixIconPadding ?? EdgeInsets.zero,
            child: Icon(
              icon,
              color: effectiveIconColor,
              size: careHomeIconSize,
            ),
          );

    final field = TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: obscureText ? 1 : maxLines,
      minLines: obscureText ? null : minLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      autovalidateMode: autovalidateMode,
      cursorColor: cursorColor,
      style: textStyle ??
          CareHomeTextStyles.body.copyWith(color: AppColors.textDarkPrimary),
      decoration: InputDecoration(
        labelText: label.isEmpty ? null : label,
        hintText: hint,
        labelStyle: labelStyle ?? CareHomeTextStyles.body,
        hintStyle: hintStyle ?? CareHomeTextStyles.muted,
        errorStyle: errorStyle,
        prefixIcon: prefixIconWidget,
        prefixIconConstraints: prefixIconConstraints,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor,
        contentPadding: contentPadding,
        border: useOuterAnimatedBorder
            ? InputBorder.none
            : _careHomeInputBorder(borderColor, width: borderWidth),
        enabledBorder: useOuterAnimatedBorder
            ? InputBorder.none
            : _careHomeInputBorder(borderColor, width: borderWidth),
        disabledBorder: useOuterAnimatedBorder
            ? InputBorder.none
            : _careHomeInputBorder(borderColor, width: borderWidth),
        focusedBorder: useOuterAnimatedBorder
            ? InputBorder.none
            : _careHomeInputBorder(
                focusedBorderColor,
                width: focusedBorderWidth,
              ),
        errorBorder: useOuterAnimatedBorder
            ? InputBorder.none
            : _careHomeInputBorder(errorBorderColor, width: borderWidth),
        focusedErrorBorder: useOuterAnimatedBorder
            ? InputBorder.none
            : _careHomeInputBorder(focusedErrorBorderColor ?? errorBorderColor),
      ),
    );

    if (!useOuterAnimatedBorder) return field;

    return AnimatedContainer(
      duration: outerBorderAnimationDuration,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: effectiveBorderWidth,
        ),
      ),
      child: field,
    );
  }

  OutlineInputBorder _careHomeInputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class CareHomeStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double iconSize;
  final TextStyle? textStyle;

  const CareHomeStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    this.borderRadius = CareHomeRadii.pill,
    this.iconSize = 14,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = textColor ?? color;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? _careHomeTint(color, 0.10),
        borderRadius: borderRadius,
        border: Border.all(color: borderColor ?? _careHomeTint(color, 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: foreground, size: iconSize),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: (textStyle ?? CareHomeTextStyles.badge)
                .copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}

enum CareHomeChipVariant { soft, filter }

class CareHomeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final IconData? icon;
  final VoidCallback? onTap;
  final CareHomeChipVariant variant;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedForegroundColor;
  final Color unselectedForegroundColor;
  final Color selectedBorderColor;
  final Color unselectedBorderColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double iconSize;
  final TextStyle? textStyle;
  final Duration animationDuration;

  const CareHomeChip({
    super.key,
    required this.label,
    this.selected = false,
    this.icon,
    this.onTap,
    this.variant = CareHomeChipVariant.soft,
    Color? selectedColor,
    this.unselectedColor = AppColors.surfaceLight,
    this.selectedForegroundColor = AppColors.brandOrange,
    this.unselectedForegroundColor = AppColors.textDarkSecondary,
    this.selectedBorderColor = AppColors.brandOrange,
    this.unselectedBorderColor = AppColors.innerBorder,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.borderRadius = CareHomeRadii.pill,
    this.iconSize = careHomeIconSizeSmall,
    this.textStyle,
    this.animationDuration = const Duration(milliseconds: 180),
  }) : selectedColor = selectedColor ?? const Color.fromARGB(36, 255, 140, 66);

  @override
  Widget build(BuildContext context) {
    final isFilter = variant == CareHomeChipVariant.filter;
    final effectiveSelectedColor =
        isFilter ? AppColors.brandOrange : selectedColor;
    final effectiveUnselectedColor =
        isFilter ? AppColors.cardBackground : unselectedColor;
    final effectiveSelectedForeground =
        isFilter ? Colors.white : selectedForegroundColor;
    final effectiveUnselectedForeground =
        isFilter ? AppColors.textDarkSecondary : unselectedForegroundColor;
    final effectiveSelectedBorder =
        isFilter ? AppColors.brandOrange : selectedBorderColor;
    final effectiveUnselectedBorder =
        isFilter ? AppColors.innerBorder : unselectedBorderColor;
    final effectivePadding = isFilter
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
        : padding;
    final effectiveTextStyle = isFilter
        ? CareHomeTextStyles.body.copyWith(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
          )
        : textStyle ?? CareHomeTextStyles.muted;
    final foreground =
        selected ? effectiveSelectedForeground : effectiveUnselectedForeground;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeOut,
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: selected ? effectiveSelectedColor : effectiveUnselectedColor,
            borderRadius: borderRadius,
            border: Border.all(
              color: selected
                  ? effectiveSelectedBorder
                  : effectiveUnselectedBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: foreground, size: iconSize),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                textAlign: TextAlign.center,
                style: effectiveTextStyle.copyWith(
                  color: foreground,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CareHomeSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? actionStyle;
  final Color iconColor;
  final int maxLines;

  const CareHomeSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.titleStyle,
    this.subtitleStyle,
    this.actionStyle,
    this.iconColor = AppColors.brandOrange,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: subtitle == null
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, color: iconColor, size: careHomeIconSize),
          const SizedBox(width: CareHomeSpacing.xs),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: titleStyle ?? CareHomeTextStyles.sectionTitle,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: CareHomeSpacing.xxs),
                Text(
                  subtitle!,
                  style: subtitleStyle ?? CareHomeTextStyles.muted,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.brandOrange,
              textStyle: actionStyle ?? CareHomeTextStyles.button,
            ),
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class CareHomeEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData actionIcon;
  final Color iconColor;
  final Color? iconBackgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry cardPadding;
  final bool showCard;
  final bool showIconBox;
  final double iconSize;
  final double iconBoxSize;
  final double titleSpacing;
  final double messageSpacing;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  const CareHomeEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.actionIcon = Icons.refresh_rounded,
    this.iconColor = AppColors.brandOrange,
    this.iconBackgroundColor,
    this.padding = const EdgeInsets.all(CareHomeSpacing.lg),
    this.cardPadding = const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
    this.showCard = true,
    this.showIconBox = true,
    this.iconSize = 30,
    this.iconBoxSize = 58,
    this.titleSpacing = CareHomeSpacing.md,
    this.messageSpacing = CareHomeSpacing.xs,
    this.titleStyle,
    this.messageStyle,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        showIconBox
            ? CareHomeIconBox(
                icon: icon,
                color: iconColor,
                backgroundColor: iconBackgroundColor,
                size: iconBoxSize,
                iconSize: iconSize,
              )
            : Icon(icon, color: iconColor, size: iconSize),
        SizedBox(height: titleSpacing),
        Text(
          title,
          textAlign: TextAlign.center,
          style: titleStyle ?? CareHomeTextStyles.sectionTitle,
        ),
        SizedBox(height: messageSpacing),
        Text(
          message,
          textAlign: TextAlign.center,
          style: messageStyle ?? CareHomeTextStyles.body,
        ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: CareHomeSpacing.lg),
          CareHomeSecondaryButton(
            label: actionLabel!,
            icon: actionIcon,
            onPressed: onAction,
          ),
        ],
      ],
    );

    return Center(
      child: Padding(
        padding: padding,
        child: showCard
            ? CareHomeCard(
                padding: cardPadding,
                child: content,
              )
            : content,
      ),
    );
  }
}
