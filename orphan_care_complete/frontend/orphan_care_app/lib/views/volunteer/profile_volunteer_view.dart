import 'package:flutter/material.dart';

import 'volunteer_ui.dart';

const String _profileVolunteerName = 'ياسمين عادل';
const String _profileVolunteerEmail = 'Yasmine.adel@gmail.com';
const Color _profileOrange = Color(0xFFFF7A00);
const Color _profileBackground = Color(0xFFF8F8F8);
const Color _profileText = Color(0xFF1F2937);
const Color _profileMuted = Color(0xFF8A8F98);

class ProfileVolunteerView extends StatelessWidget {
  const ProfileVolunteerView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: VolunteerMobileFrame(
        child: Scaffold(
          backgroundColor: _profileBackground,
          body: Stack(
            children: [
              SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 112),
                  child: Column(
                    children: [
                      _ProfileHero(
                        name: _profileVolunteerName,
                        email: _profileVolunteerEmail,
                      ),
                      SizedBox(height: 54),
                      _ProfileMenu(),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: VolunteerBottomNavBar(selectedIndex: 3),
              ),
            ],
          ),
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
          height: 340,
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 84),
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
                  fontFamily: 'Vazirmatn',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              const _ProfileAvatar(),
              const SizedBox(height: 10),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Vazirmatn',
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          color: Colors.white.withOpacity(0.88),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // TODO: Open volunteer profile edit screen when it is available.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'تعديل البيانات قريبًا',
                                style: TextStyle(fontFamily: 'Vazirmatn'),
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.edit_square,
                            color: Colors.white.withOpacity(0.92),
                            size: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
          width: 96,
          height: 96,
          padding: const EdgeInsets.all(4),
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
              size: 48,
            ),
          ),
        ),
        PositionedDirectional(
          start: 2,
          bottom: 6,
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
                width: 30,
                height: 30,
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
                  size: 15,
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
          Expanded(child: _StatItem(value: '3', label: 'فرص')),
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
            fontFamily: 'Vazirmatn',
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
            fontFamily: 'Vazirmatn',
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
        title: 'شهاداتي',
        icon: Icons.workspace_premium_outlined,
        onTap: () => Navigator.of(context).pushNamed('/my_certificates'),
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
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 9),
                ),
              ],
            ),
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  _ProfileMenuTile(data: items[i]),
                  if (i != items.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF0F0F0),
                      ),
                    ),
                ],
              ],
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
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 60,
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              const SizedBox(width: 18),
              Icon(data.icon, color: _profileMuted, size: 23),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Vazirmatn',
                    color: _profileText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFB5BAC3),
                size: 24,
              ),
              const SizedBox(width: 14),
            ],
          ),
        ),
      ),
    );
  }
}
