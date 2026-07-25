import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class VolunteerMiniHamburgerButton extends StatelessWidget {
  const VolunteerMiniHamburgerButton({super.key});

  static const _historyRoute = '/my_volunteer_history';
  static const _profileRoute = '/volunteer_profile';
  static const _settingsRoute = '/settings';

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 44,
      child: PopupMenuButton<String>(
        tooltip: 'القائمة',
        color: Colors.white,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.08),
        offset: const Offset(0, 42),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: EdgeInsets.zero,
        child: const Center(
          child: Icon(
            Icons.menu_rounded,
            color: AppColors.textDarkPrimary,
            size: 25,
          ),
        ),
        onSelected: (routeName) => _navigate(context, routeName),
        itemBuilder: (context) => const [
          PopupMenuItem<String>(
            value: _historyRoute,
            child: _VolunteerMenuItem(
              icon: Icons.history_edu_outlined,
              label: 'السجل',
            ),
          ),
          PopupMenuItem<String>(
            value: _profileRoute,
            child: _VolunteerMenuItem(
              icon: Icons.person_outline_rounded,
              label: 'الحساب',
            ),
          ),
          PopupMenuItem<String>(
            value: _settingsRoute,
            child: _VolunteerMenuItem(
              icon: Icons.settings_outlined,
              label: 'الإعدادات',
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, String routeName) {
    if (ModalRoute.of(context)?.settings.name == routeName) return;
    Navigator.of(context).pushNamed(routeName);
  }
}

class _VolunteerMenuItem extends StatelessWidget {
  const _VolunteerMenuItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.brandOrange, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDarkPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
