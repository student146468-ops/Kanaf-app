import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

const double kanafMobileMaxWidth = 430;
const double kanafHorizontalPadding = 20;
const double kanafRadius = 18;

const TextStyle kanafTitleStyle = TextStyle(
  fontFamily: 'Cairo',
  color: AppColors.textDarkPrimary,
  fontSize: 18,
  fontWeight: FontWeight.w900,
  height: 1.25,
);

const TextStyle kanafSectionTitleStyle = TextStyle(
  fontFamily: 'Cairo',
  color: AppColors.textDarkPrimary,
  fontSize: 16,
  fontWeight: FontWeight.w900,
  height: 1.35,
);

const TextStyle kanafBodyStyle = TextStyle(
  fontFamily: 'Tajawal',
  color: AppColors.textDarkSecondary,
  fontSize: 13.8,
  height: 1.55,
  fontWeight: FontWeight.w600,
);

const TextStyle kanafMutedStyle = TextStyle(
  fontFamily: 'Tajawal',
  color: AppColors.textDarkMuted,
  fontSize: 12.6,
  height: 1.45,
  fontWeight: FontWeight.w600,
);

class KanafPage extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showBack;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;

  const KanafPage({
    super.key,
    required this.title,
    required this.body,
    this.showBack = true,
    this.actions,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth < kanafMobileMaxWidth
                ? constraints.maxWidth
                : kanafMobileMaxWidth;
            return Center(
              child: SizedBox(
                width: width,
                height: constraints.maxHeight,
                child: Scaffold(
                  backgroundColor: AppColors.scaffoldBackground,
                  appBar: AppBar(
                    toolbarHeight: 64,
                    backgroundColor: AppColors.scaffoldBackground,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                    leadingWidth: 58,
                    leading: showBack
                        ? Padding(
                            padding: const EdgeInsetsDirectional.only(
                              start: 12,
                              top: 8,
                              bottom: 8,
                            ),
                            child: KanafCircleButton(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () => Navigator.of(context).pop(),
                            ),
                          )
                        : null,
                    title: Text(title, style: kanafTitleStyle),
                    actions: actions,
                  ),
                  body: body,
                  bottomNavigationBar: bottomNavigationBar == null
                      ? null
                      : SafeArea(
                          top: false,
                          child: bottomNavigationBar!,
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class KanafCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color borderColor;
  final VoidCallback? onTap;

  const KanafCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = Colors.white,
    this.borderColor = AppColors.innerBorder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(kanafRadius),
      border: Border.all(color: borderColor),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.035),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    );

    if (onTap == null) {
      return Container(
        width: double.infinity,
        padding: padding,
        decoration: decoration,
        child: child,
      );
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(kanafRadius),
      child: InkWell(
        onTap: onTap,
        hoverColor: AppColors.brandOrangeLight.withOpacity(0.35),
        splashColor: AppColors.brandOrangeLight,
        borderRadius: BorderRadius.circular(kanafRadius),
        child: Ink(
          width: double.infinity,
          padding: padding,
          decoration: decoration,
          child: child,
        ),
      ),
    );
  }
}

class KanafIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final Color? backgroundColor;

  const KanafIconBox({
    super.key,
    required this.icon,
    this.color = AppColors.brandOrange,
    this.size = 44,
    this.iconSize = 22,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: color, size: iconSize),
    );
  }
}

class KanafCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const KanafCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = AppColors.textDarkPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        hoverColor: AppColors.brandOrangeLight.withOpacity(0.4),
        splashColor: AppColors.brandOrangeLight,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: color, size: 19),
        ),
      ),
    );
  }
}

class KanafBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const KanafBadge({
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
        color: color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: color,
              fontSize: 11.6,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class KanafMetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const KanafMetaChip({
    super.key,
    required this.icon,
    required this.label,
    this.color = AppColors.textDarkSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: color,
              fontSize: 11.8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class KanafPrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool expanded;

  const KanafPrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 19),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class KanafSecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const KanafSecondaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brandOrange,
          side: const BorderSide(color: AppColors.innerBorder),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w900,
            fontSize: 14.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class KanafEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const KanafEmptyState({
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
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            KanafIconBox(icon: icon, size: 62, iconSize: 31),
            const SizedBox(height: 14),
            Text(title,
                textAlign: TextAlign.center, style: kanafSectionTitleStyle),
            const SizedBox(height: 7),
            Text(message, textAlign: TextAlign.center, style: kanafBodyStyle),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 18),
              KanafPrimaryButton(
                label: actionLabel!,
                icon: Icons.arrow_back_rounded,
                onPressed: onAction!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Color kanafStatusColor(String status) {
  switch (status) {
    case 'عاجل':
    case 'مهم':
    case 'غير مقروء':
      return AppColors.errorRed;
    case 'مكتمل':
    case 'مقبول':
    case 'مقروء':
      return AppColors.successGreen;
    case 'قيد التنفيذ':
    case 'متابعة':
      return AppColors.skyBlueDark;
    default:
      return AppColors.brandOrange;
  }
}
