import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'volunteer_ui.dart';

const String _profileVolunteerName = 'ياسمين عادل';

class ProfileVolunteerView extends StatelessWidget {
  const ProfileVolunteerView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final volunteer =
        provider.volunteers.isNotEmpty ? provider.volunteers.first : null;
    const name = _profileVolunteerName;
    final specialty = volunteer?.specialty.isNotEmpty == true
        ? volunteer!.specialty
        : 'التطوع وصناعة الأثر';
    final hours = volunteer?.hoursWorked ?? 0;
    final completed = hours > 0 ? 1 : 0;
    final certificates = hours >= 10 ? 1 : 0;
    final hasProgress = hours > 0 || completed > 0 || certificates > 0;

    return VolunteerAppScaffold(
      title: 'الملف الشخصي',
      showBack: false,
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            volunteerHorizontalPadding,
            10,
            volunteerHorizontalPadding,
            28,
          ),
          children: [
            _ProfileHeader(name: name, specialty: specialty),
            const SizedBox(height: 14),
            hasProgress
                ? _StatsRow(
                    hours: hours,
                    completed: completed,
                    certificates: certificates,
                  )
                : _EncouragementCard(
                    onAction: () =>
                        Navigator.of(context).pushNamed('/volunteer_search'),
                  ),
            const SizedBox(height: 22),
            const VolunteerSectionTitle(title: 'متابعة التطوع'),
            const SizedBox(height: 10),
            _MenuGroup(
              items: [
                _MenuItemData(
                  icon: Icons.event_note_outlined,
                  color: AppColors.brandOrange,
                  title: 'مواعيدي التطوعية',
                  subtitle: 'راجع الجلسات القادمة ومواقعها',
                  onTap: () => Navigator.of(context).pushNamed('/my_schedule'),
                ),
                _MenuItemData(
                  icon: Icons.history_edu_outlined,
                  color: AppColors.successGreen,
                  title: 'سجل التطوع',
                  subtitle: 'تابع الساعات والفرص المكتملة',
                  onTap: () =>
                      Navigator.of(context).pushNamed('/my_volunteer_history'),
                ),
                _MenuItemData(
                  icon: Icons.workspace_premium_outlined,
                  color: const Color(0xFFFFB300),
                  title: 'شهاداتي',
                  subtitle: 'شهادات التقدير والإنجاز',
                  onTap: () =>
                      Navigator.of(context).pushNamed('/my_certificates'),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const VolunteerSectionTitle(title: 'الحساب'),
            const SizedBox(height: 10),
            _MenuGroup(
              items: [
                _MenuItemData(
                  icon: Icons.manage_accounts_outlined,
                  color: const Color(0xFF4A90E2),
                  title: 'إعدادات الحساب',
                  subtitle: 'تعديل البيانات الشخصية',
                  onTap: () => Navigator.of(context).pushNamed('/settings'),
                ),
                _MenuItemData(
                  icon: Icons.lock_reset_rounded,
                  color: const Color(0xFF7E57C2),
                  title: 'تغيير كلمة المرور',
                  subtitle: 'تحديث بيانات الأمان',
                  onTap: () =>
                      Navigator.of(context).pushNamed('/change_password'),
                ),
              ],
            ),
            const SizedBox(height: 22),
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
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String specialty;

  const _ProfileHeader({required this.name, required this.specialty});

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      child: Row(
        children: [
          const _ProfileAvatar(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textDarkPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(specialty, style: volunteerBodyStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    // TODO: Connect this visual camera affordance to profile photo upload later.
    return Tooltip(
      message: 'تغيير الصورة الشخصية',
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const VolunteerIconBox(
            icon: Icons.person_rounded,
            color: AppColors.brandOrange,
            size: 62,
            iconSize: 34,
          ),
          Positioned(
            left: -2,
            bottom: -2,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.brandOrange,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.photo_camera_rounded,
                color: Colors.white,
                size: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int hours;
  final int completed;
  final int certificates;

  const _StatsRow({
    required this.hours,
    required this.completed,
    required this.certificates,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            value: '$hours',
            label: 'ساعة',
            icon: Icons.schedule_rounded,
            color: AppColors.brandOrange,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            value: '$completed',
            label: 'فرصة',
            icon: Icons.handshake_outlined,
            color: AppColors.successGreen,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            value: '$certificates',
            label: 'شهادة',
            icon: Icons.workspace_premium_outlined,
            color: const Color(0xFFFFB300),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        children: [
          VolunteerIconBox(
            icon: icon,
            color: color,
            size: 36,
            iconSize: 19,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(label, style: volunteerMutedStyle),
        ],
      ),
    );
  }
}

class _EncouragementCard extends StatelessWidget {
  final VoidCallback onAction;

  const _EncouragementCard({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      color: AppColors.brandOrangeLight,
      borderColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              VolunteerIconBox(
                icon: Icons.rocket_launch_rounded,
                backgroundColor: Colors.white,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'ابدأ أول تجربة تطوعية لك',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textDarkPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'انطلق في أول فرصة تطوع وساهم بوقتك ومهاراتك في صنع أثر حقيقي.',
            style: volunteerBodyStyle,
          ),
          const SizedBox(height: 14),
          VolunteerPrimaryButton(
            label: 'استكشاف الفرص',
            icon: Icons.explore_rounded,
            onPressed: onAction,
          ),
        ],
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  final List<_MenuItemData> items;

  const _MenuGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _MenuRow(data: items[i]),
            if (i != items.length - 1)
              const Divider(
                height: 1,
                color: AppColors.divider,
                indent: 16,
                endIndent: 16,
              ),
          ],
        ],
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuItemData({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class _MenuRow extends StatelessWidget {
  final _MenuItemData data;

  const _MenuRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        hoverColor: data.color.withOpacity(0.08),
        splashColor: data.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(volunteerRadius),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              VolunteerIconBox(
                icon: data.icon,
                color: data.color,
                size: 42,
                iconSize: 21,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textDarkPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(data.subtitle, style: volunteerMutedStyle),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textDarkMuted,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
