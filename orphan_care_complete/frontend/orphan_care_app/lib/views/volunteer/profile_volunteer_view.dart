import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import 'volunteer_ui.dart';

const String _profileVolunteerName = 'ياسمين عادل';
const String _profileVolunteerEmail = 'yasmin.adel@example.com';
const Color _profileOrange = Color(0xFFFF7A00);
const Color _profileBackground = Color(0xFFF8F8F8);
const Color _profileText = Color(0xFF1F2937);
const Color _profileMuted = Color(0xFF8A8F98);

class ProfileVolunteerView extends StatelessWidget {
  const ProfileVolunteerView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final volunteer =
        provider.volunteers.isNotEmpty ? provider.volunteers.first : null;
    final name = volunteer?.name.isNotEmpty == true
        ? volunteer!.name
        : _profileVolunteerName;
    final email = volunteer?.email?.isNotEmpty == true
        ? volunteer!.email!
        : _profileVolunteerEmail;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: VolunteerMobileFrame(
        child: Scaffold(
          backgroundColor: _profileBackground,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 112),
              child: Column(
                children: [
                  _ProfileHero(name: name, email: email),
                  const SizedBox(height: 54),
                  const _ProfileMenu(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const _ProfileBottomBar(),
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  final String name;
  final String email;

  const _ProfileHero({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: double.infinity,
          height: 286,
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 74),
          decoration: const BoxDecoration(
            color: _profileOrange,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(42),
              bottomRight: Radius.circular(42),
            ),
          ),
          child: Column(
            children: [
              const Text(
                'الملف الشخصي',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              const _ProfileAvatar(),
              const SizedBox(height: 14),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        color: Colors.white.withOpacity(0.88),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.edit_outlined,
                    color: Colors.white.withOpacity(0.9),
                    size: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
        const Positioned(
          bottom: -34,
          left: 22,
          right: 22,
          child: _ProfileStatsCard(),
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 108,
          height: 108,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.11),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const CircleAvatar(
            backgroundColor: Color(0xFFFFF1E5),
            child: Icon(
              Icons.person_rounded,
              color: _profileOrange,
              size: 54,
            ),
          ),
        ),
        PositionedDirectional(
          start: 2,
          bottom: 7,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تغيير الصورة قريبًا')),
                );
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFFD7BA), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.photo_camera_rounded,
                  color: _profileOrange,
                  size: 17,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileStatsCard extends StatelessWidget {
  const _ProfileStatsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Row(
        children: [
          Expanded(child: _StatItem(value: '24', label: 'ساعة تطوع')),
          _StatDivider(),
          Expanded(child: _StatItem(value: '8', label: 'أنشطة')),
          _StatDivider(),
          Expanded(child: _StatItem(value: '3', label: 'فرصات')),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Cairo',
            color: _profileOrange,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Tajawal',
            color: _profileText,
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      color: const Color(0xFFEDEDED),
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  const _ProfileMenu();

  @override
  Widget build(BuildContext context) {
    final items = [
      _ProfileMenuItemData(
        title: 'سجل التطوع',
        icon: Icons.history_edu_outlined,
        onTap: () => Navigator.of(context).pushNamed('/my_volunteer_history'),
      ),
      _ProfileMenuItemData(
        title: 'تطوعاتي',
        icon: Icons.volunteer_activism_outlined,
        onTap: () => Navigator.of(context).pushNamed('/my_schedule'),
      ),
      _ProfileMenuItemData(
        title: 'المفضلة',
        icon: Icons.favorite_border_rounded,
        onTap: () => Navigator.of(context).pushNamed('/volunteer_search'),
      ),
      _ProfileMenuItemData(
        title: 'بياناتي الشخصية',
        icon: Icons.person_outline_rounded,
        onTap: () => Navigator.of(context).pushNamed('/settings'),
      ),
      _ProfileMenuItemData(
        title: 'الإعدادات',
        icon: Icons.settings_outlined,
        onTap: () => Navigator.of(context).pushNamed('/settings'),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _ProfileMenuTile(data: items[i]),
            if (i != items.length - 1) const SizedBox(height: 12),
          ],
          const SizedBox(height: 18),
          VolunteerSecondaryButton(
            label: 'تسجيل الخروج',
            icon: Icons.logout_rounded,
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItemData {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ProfileMenuItemData({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class _ProfileMenuTile extends StatelessWidget {
  final _ProfileMenuItemData data;

  const _ProfileMenuTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: _profileText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(data.icon, color: _profileMuted, size: 23),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileBottomBar extends StatelessWidget {
  const _ProfileBottomBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
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
              Expanded(
                child: _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'الرئيسية',
                  selected: false,
                  onTap: () =>
                      Navigator.of(context).pushNamed('/volunteer_home'),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.notifications_none_rounded,
                  activeIcon: Icons.notifications_active_rounded,
                  label: 'الإشعارات',
                  selected: false,
                  showDot: true,
                  onTap: () => Navigator.of(context)
                      .pushNamed('/volunteer_notifications'),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.event_note_outlined,
                  activeIcon: Icons.event_note_rounded,
                  label: 'مواعيدي',
                  selected: false,
                  onTap: () => Navigator.of(context).pushNamed('/my_schedule'),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'حسابي',
                  selected: true,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final bool showDot;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? _profileOrange : const Color(0xFF6B7280);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF2E8) : Colors.transparent,
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
                  Icon(selected ? activeIcon : icon, color: color, size: 23),
                  if (showDot)
                    Positioned(
                      top: -2,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: _profileOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Tajawal',
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
