import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class KanafBottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final VoidCallback onTap;
  final bool showDot;

  const KanafBottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
    this.showDot = false,
  });
}

class KanafBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<KanafBottomNavItem> items;
  final double maxWidth;

  const KanafBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    this.maxWidth = 480,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  for (int index = 0; index < items.length; index++)
                    Expanded(
                      child: _KanafBottomNavTile(
                        item: items[index],
                        selected: selectedIndex == index,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KanafBottomNavTile extends StatelessWidget {
  final KanafBottomNavItem item;
  final bool selected;

  const _KanafBottomNavTile({
    required this.item,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.brandOrange : const Color(0xFF6B7280);

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandOrangeLight : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 26,
              height: 24,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(
                    selected ? item.activeIcon : item.icon,
                    color: color,
                    size: 23,
                  ),
                  if (item.showDot)
                    Positioned(
                      top: -2,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.brandOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
