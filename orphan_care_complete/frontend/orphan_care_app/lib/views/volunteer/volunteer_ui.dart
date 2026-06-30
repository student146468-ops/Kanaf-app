import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

export 'volunteer_bottom_nav_bar.dart';

const double volunteerMobileMaxWidth = 480;
const double volunteerRadius = 18;
const double volunteerCardPadding = 16;
const double volunteerHorizontalPadding = 20;
const double volunteerAppBarHeight = 64;
const double volunteerIconBoxSize = 44;
const double volunteerIconSize = 22;

const TextStyle volunteerTitleStyle = TextStyle(
  fontFamily: 'Vazirmatn',
  color: AppColors.textDarkPrimary,
  fontSize: 18,
  fontWeight: FontWeight.w900,
);

const TextStyle volunteerSectionTitleStyle = TextStyle(
  fontFamily: 'Vazirmatn',
  color: AppColors.textDarkPrimary,
  fontSize: 16,
  fontWeight: FontWeight.w900,
);

const TextStyle volunteerBodyStyle = TextStyle(
  fontFamily: 'Vazirmatn',
  color: AppColors.textDarkSecondary,
  fontSize: 13.5,
  height: 1.5,
  fontWeight: FontWeight.w600,
);

const TextStyle volunteerMutedStyle = TextStyle(
  fontFamily: 'Vazirmatn',
  color: AppColors.textDarkMuted,
  fontSize: 12.5,
  height: 1.45,
  fontWeight: FontWeight.w600,
);

String _readableEmptyTitle(IconData icon, String title) {
  if (!title.contains('ظ') && !title.contains('ط')) return title;
  if (icon == Icons.workspace_premium_outlined) return 'لا توجد شهادات بعد';
  if (icon == Icons.event_busy_outlined) {
    return 'لا توجد مواعيد تطوعية لهذا اليوم';
  }
  if (icon == Icons.notifications_none_rounded) return 'لا توجد إشعارات الآن';
  if (icon == Icons.history_toggle_off_rounded) {
    return 'ابدأ أول تجربة تطوعية لك';
  }
  return 'لا توجد بيانات حالياً';
}

String _readableEmptyMessage(IconData icon, String message) {
  if (!message.contains('ظ') && !message.contains('ط')) return message;
  if (icon == Icons.workspace_premium_outlined) {
    return 'بعد إكمال مساهمة تطوعية موثقة ستظهر شهادات التقدير هنا.';
  }
  if (icon == Icons.event_busy_outlined) {
    return 'بعد قبولك في فرصة تطوعية سيظهر موعدها هنا بوضوح.';
  }
  if (icon == Icons.notifications_none_rounded) {
    return 'سنخبرك هنا عند قبول الطلبات أو صدور الشهادات أو نشر فرص جديدة.';
  }
  if (icon == Icons.history_toggle_off_rounded) {
    return 'سيظهر سجل مساهماتك هنا بعد قبولك في أول فرصة.';
  }
  return 'ستظهر البيانات هنا عند توفرها.';
}

String _readableEmptyAction(String actionLabel) {
  if (!actionLabel.contains('ظ') && !actionLabel.contains('ط')) {
    return actionLabel;
  }
  return 'استكشاف الفرص';
}

String _readableButtonLabel(String label, IconData icon) {
  if (!label.contains('ظ') && !label.contains('ط')) return label;
  if (icon == Icons.send_rounded) return 'تقديم طلب تطوع';
  if (icon == Icons.explore_rounded || icon == Icons.explore_outlined) {
    return 'استكشاف الفرص';
  }
  if (icon == Icons.home_rounded) return 'العودة للرئيسية';
  if (icon == Icons.restart_alt_rounded) return 'إعادة ضبط';
  if (icon == Icons.logout_rounded) return 'تسجيل الخروج';
  if (icon == Icons.filter_alt_rounded) return 'عرض النتائج';
  return label;
}

class VolunteerMobileFrame extends StatelessWidget {
  final Widget child;

  const VolunteerMobileFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final volunteerTheme = theme.copyWith(
      textTheme: theme.textTheme.apply(fontFamily: 'Vazirmatn'),
      primaryTextTheme: theme.primaryTextTheme.apply(fontFamily: 'Vazirmatn'),
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SizedBox(
              width: constraints.maxWidth < volunteerMobileMaxWidth
                  ? constraints.maxWidth
                  : volunteerMobileMaxWidth,
              height: constraints.maxHeight,
              child: Theme(
                data: volunteerTheme,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}

class VolunteerAppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;

  const VolunteerAppScaffold({
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
      child: VolunteerMobileFrame(
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(volunteerAppBarHeight),
            child: VolunteerTopBar(
              title: title,
              showBack: showBack,
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

class VolunteerTopBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool includeSafeArea;

  const VolunteerTopBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.includeSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final bar = Container(
      height: volunteerAppBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(18),
        ),
        border: Border.all(color: AppColors.innerBorder.withOpacity(0.75)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: 0,
            child: showBack
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onBack ?? () => Navigator.maybePop(context),
                      borderRadius: BorderRadius.circular(14),
                      child: const SizedBox(
                        width: 46,
                        height: 46,
                        child: Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.textDarkPrimary,
                          size: 31,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(width: 46),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 56),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: volunteerTitleStyle,
            ),
          ),
          if (actions != null && actions!.isNotEmpty)
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
}

class VolunteerCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color borderColor;
  final VoidCallback? onTap;
  final BorderRadiusGeometry? borderRadius;

  const VolunteerCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(volunteerCardPadding),
    this.color = Colors.white,
    this.borderColor = AppColors.innerBorder,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(volunteerRadius);
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
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
        hoverColor: AppColors.brandOrangeLight.withOpacity(0.28),
        splashColor: AppColors.brandOrangeLight.withOpacity(0.45),
        highlightColor: AppColors.brandOrangeLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(volunteerRadius),
        child: content,
      ),
    );
  }
}

class VolunteerIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final Color? backgroundColor;

  const VolunteerIconBox({
    super.key,
    required this.icon,
    this.color = AppColors.brandOrange,
    this.size = volunteerIconBoxSize,
    this.iconSize = volunteerIconSize,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: iconSize),
    );
  }
}

class VolunteerIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const VolunteerIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          hoverColor: AppColors.brandOrangeLight.withOpacity(0.35),
          splashColor: AppColors.brandOrangeLight,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.innerBorder),
            ),
            child: Icon(icon, color: AppColors.textDarkPrimary, size: 19),
          ),
        ),
      ),
    );
  }
}

class VolunteerStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const VolunteerStatusBadge({
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
        color: color.withOpacity(0.10),
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
              fontFamily: 'Vazirmatn',
              color: color,
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class VolunteerMetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool prominent;

  const VolunteerMetaChip({
    super.key,
    required this.icon,
    required this.label,
    this.color = AppColors.textDarkSecondary,
    this.prominent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: prominent ? 11 : 10,
        vertical: prominent ? 8 : 7,
      ),
      decoration: BoxDecoration(
        color: prominent ? color.withOpacity(0.09) : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: prominent ? color.withOpacity(0.16) : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              color: prominent ? color : AppColors.textDarkSecondary,
              fontSize: 11.8,
              fontWeight: prominent ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class VolunteerSectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const VolunteerSectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: volunteerSectionTitleStyle),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.brandOrange,
              textStyle: const TextStyle(
                fontFamily: 'Vazirmatn',
                fontWeight: FontWeight.w800,
              ),
            ),
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class VolunteerPrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool loading;

  const VolunteerPrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayLabel = _readableButtonLabel(label, icon);

    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandOrange,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.brandOrange.withOpacity(0.55),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.2,
                ),
              )
            : Icon(icon, size: 19),
        label: Text(
          displayLabel,
          style: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class VolunteerSecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const VolunteerSecondaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final displayLabel = _readableButtonLabel(label, icon);

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(displayLabel),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.brandOrangeDark,
        side: BorderSide(color: AppColors.brandOrange.withOpacity(0.35)),
        textStyle: const TextStyle(
          fontFamily: 'Vazirmatn',
          fontWeight: FontWeight.w900,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class VolunteerEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const VolunteerEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle = _readableEmptyTitle(icon, title);
    final displayMessage = _readableEmptyMessage(icon, message);
    final displayActionLabel = _readableEmptyAction(actionLabel);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: VolunteerCard(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VolunteerIconBox(
                icon: icon,
                size: 58,
                iconSize: 30,
                color: AppColors.brandOrange,
              ),
              const SizedBox(height: 14),
              Text(
                displayTitle,
                textAlign: TextAlign.center,
                style: volunteerSectionTitleStyle,
              ),
              const SizedBox(height: 7),
              Text(
                displayMessage,
                textAlign: TextAlign.center,
                style: volunteerBodyStyle,
              ),
              const SizedBox(height: 18),
              VolunteerSecondaryButton(
                label: displayActionLabel,
                icon: Icons.explore_outlined,
                onPressed: onAction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
