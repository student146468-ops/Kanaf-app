import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

const careHomeRefFont = 'Vazirmatn';
const careHomeRefMaxWidth = 390.0;
const careHomeRefOrange = AppColors.brandOrange;
const careHomeRefText = Color(0xFF1F2937);
const careHomeRefMuted = Color(0xFF6B7280);
const careHomeRefLine = Color(0xFFE9ECF1);
const careHomeRefSoft = Color(0xFFF8F8F8);

TextStyle get careHomeRefTitle => const TextStyle(
      fontFamily: careHomeRefFont,
      fontWeight: FontWeight.w800,
      fontSize: 18,
      color: careHomeRefText,
    );

TextStyle get careHomeRefBodyStrong => const TextStyle(
      fontFamily: careHomeRefFont,
      fontWeight: FontWeight.w800,
      fontSize: 13,
      color: careHomeRefText,
    );

TextStyle get careHomeRefBody => const TextStyle(
      fontFamily: careHomeRefFont,
      fontWeight: FontWeight.w600,
      fontSize: 12,
      color: careHomeRefText,
    );

TextStyle get careHomeRefCaption => const TextStyle(
      fontFamily: careHomeRefFont,
      fontWeight: FontWeight.w600,
      fontSize: 11,
      color: careHomeRefMuted,
    );

TextStyle get careHomeRefButton => const TextStyle(
      fontFamily: careHomeRefFont,
      fontWeight: FontWeight.w800,
      fontSize: 13,
      color: Colors.white,
    );

String careHomeValue(dynamic value, [String fallback = '-']) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? fallback : text;
}

class CareHomeRefScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int? bottomIndex;
  final bool showBack;
  final List<Widget>? actions;
  final Widget? bottomAction;
  final EdgeInsetsGeometry bodyPadding;

  const CareHomeRefScaffold({
    super.key,
    required this.title,
    required this.body,
    this.bottomIndex,
    this.showBack = true,
    this.actions,
    this.bottomAction,
    this.bodyPadding = const EdgeInsets.fromLTRB(14, 10, 14, 14),
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F3),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: careHomeRefMaxWidth),
            child: ColoredBox(
              color: Colors.white,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: CareHomeRefAppBar(
                    title: title,
                    showBack: showBack,
                    actions: actions,
                  ),
                  body: Padding(padding: bodyPadding, child: body),
                  bottomNavigationBar: bottomIndex == null
                      ? null
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                          child:
                              CareHomeRefBottomNav(currentIndex: bottomIndex!),
                        ),
                  bottomSheet: bottomAction == null
                      ? null
                      : ColoredBox(color: Colors.white, child: bottomAction!),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CareHomeRefAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const CareHomeRefAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(54);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(title, style: careHomeRefBodyStrong.copyWith(fontSize: 14)),
      leading: IconButton(
        tooltip: showBack ? 'رجوع' : 'القائمة',
        onPressed: showBack
            ? () => Navigator.of(context).maybePop()
            : () => Navigator.of(context).pushNamed('/settings'),
        icon: Icon(
          showBack ? Icons.arrow_forward_rounded : Icons.menu_rounded,
          color: careHomeRefText,
          size: 21,
        ),
      ),
      actions: actions ??
          [
            IconButton(
              tooltip: 'الإشعارات',
              onPressed: () =>
                  Navigator.of(context).pushNamed('/care_home_notifications'),
              icon: const Icon(Icons.notifications_none_rounded, size: 20),
              color: careHomeRefText,
            ),
          ],
    );
  }
}

class CareHomeRefBottomNav extends StatelessWidget {
  final int currentIndex;

  const CareHomeRefBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    const items = [
      _RefNavItem(Icons.home_rounded, 'الرئيسية', '/care_home_dashboard'),
      _RefNavItem(
          Icons.inventory_2_outlined, 'الاحتياجات', '/care_home_needs_list'),
      _RefNavItem(Icons.volunteer_activism_outlined, 'التبرعات',
          '/care_home_incoming_donations'),
      _RefNavItem(
          Icons.groups_2_outlined, 'المتطوعون', '/care_home_manage_volunteers'),
      _RefNavItem(Icons.person_outline_rounded, 'ملفي', '/care_home_profile'),
    ];

    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final active = index == currentIndex;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: active
                  ? null
                  : () =>
                      Navigator.of(context).pushReplacementNamed(item.route),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    color: active ? careHomeRefOrange : const Color(0xFF9AA1AD),
                    size: 21,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: careHomeRefCaption.copyWith(
                      fontSize: 9,
                      color: active ? careHomeRefOrange : careHomeRefMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _RefNavItem {
  final IconData icon;
  final String label;
  final String route;

  const _RefNavItem(this.icon, this.label, this.route);
}

class CareHomeRefCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;

  const CareHomeRefCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.margin = const EdgeInsets.only(bottom: 12),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: careHomeRefLine),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
    if (onTap == null) return card;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: card,
    );
  }
}

class CareHomeRefImage extends StatelessWidget {
  final String? assetPath;
  final String? imageUrl;
  final double height;
  final double? width;
  final IconData icon;

  const CareHomeRefImage({
    super.key,
    this.assetPath,
    this.imageUrl,
    this.height = 132,
    this.width,
    this.icon = Icons.image_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final image = imageUrl != null && imageUrl!.isNotEmpty
        ? Image.network(imageUrl!, fit: BoxFit.cover)
        : assetPath != null
            ? Image.asset(assetPath!, fit: BoxFit.cover)
            : Icon(icon, color: const Color(0xFFB8BDC7), size: 36);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: width ?? double.infinity,
        height: height,
        color: const Color(0xFFFFF3EC),
        alignment: Alignment.center,
        child: image,
      ),
    );
  }
}

class CareHomeRefButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outlined;
  final IconData? icon;

  const CareHomeRefButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.outlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(
            width: 18,
            height: 18,
            child:
                CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 17),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    if (outlined) {
      return SizedBox(
        height: 48,
        width: double.infinity,
        child: OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: careHomeRefOrange,
            side: const BorderSide(color: careHomeRefOrange),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: careHomeRefButton.copyWith(color: careHomeRefOrange),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: careHomeRefOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: careHomeRefButton,
        ),
        child: child,
      ),
    );
  }
}

class CareHomeRefChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const CareHomeRefChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? careHomeRefOrange : careHomeRefSoft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: careHomeRefCaption.copyWith(
            color: selected ? Colors.white : careHomeRefText,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class CareHomeRefRowTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const CareHomeRefRowTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return CareHomeRefCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: careHomeRefText, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: careHomeRefBodyStrong),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, style: careHomeRefCaption),
                ],
              ],
            ),
          ),
          trailing ??
              const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: careHomeRefMuted,
                size: 14,
              ),
        ],
      ),
    );
  }
}

class CareHomeRefEmpty extends StatelessWidget {
  final String title;
  final IconData icon;

  const CareHomeRefEmpty({
    super.key,
    required this.title,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return CareHomeRefCard(
      child: Column(
        children: [
          CareHomeRefImage(height: 94, icon: icon),
          const SizedBox(height: 12),
          Text(title,
              textAlign: TextAlign.center, style: careHomeRefBodyStrong),
        ],
      ),
    );
  }
}
