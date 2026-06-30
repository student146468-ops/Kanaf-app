import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class VolunteerBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final bool showNotificationsDot;

  const VolunteerBottomNavBar({
    super.key,
    required this.selectedIndex,
    this.onItemSelected,
    this.showNotificationsDot = true,
  });

  void _handleTap(BuildContext context, int index) {
    if (onItemSelected != null) {
      onItemSelected!(index);
      return;
    }

    if (index == selectedIndex) return;
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/volunteer_home');
        break;
      case 1:
        Navigator.of(context).pushNamed('/volunteer_notifications');
        break;
      case 2:
        Navigator.of(context).pushNamed('/volunteer_search');
        break;
      case 3:
        Navigator.of(context).pushNamed('/volunteer_profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 6),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.045),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SizedBox(
            height: 58,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: _VolunteerNavItem(
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                      label: 'الرئيسية',
                      selected: selectedIndex == 0,
                      onTap: () => _handleTap(context, 0),
                    ),
                  ),
                  Expanded(
                    child: _VolunteerNavItem(
                      icon: Icons.notifications_none_rounded,
                      activeIcon: Icons.notifications_active_rounded,
                      label: 'الإشعارات',
                      selected: selectedIndex == 1,
                      showDot: showNotificationsDot,
                      onTap: () => _handleTap(context, 1),
                    ),
                  ),
                  Expanded(
                    child: _VolunteerNavItem(
                      icon: Icons.event_note_outlined,
                      activeIcon: Icons.event_note_rounded,
                      label: 'فرص التطوع',
                      selected: selectedIndex == 2,
                      onTap: () => _handleTap(context, 2),
                    ),
                  ),
                  Expanded(
                    child: _VolunteerNavItem(
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      label: 'حسابي',
                      selected: selectedIndex == 3,
                      onTap: () => _handleTap(context, 3),
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

class _VolunteerNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final bool showDot;
  final VoidCallback onTap;

  const _VolunteerNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.brandOrange : const Color(0xFF6B7280);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF2E8) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 26,
              height: 23,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(selected ? activeIcon : icon, color: color, size: 22),
                  if (showDot)
                    const Positioned(
                      top: -2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.brandOrange,
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(width: 6, height: 6),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                color: color,
                fontSize: 10.5,
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
