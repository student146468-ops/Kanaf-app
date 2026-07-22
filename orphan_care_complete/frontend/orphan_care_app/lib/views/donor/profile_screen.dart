import 'package:flutter/material.dart';

import '../../models/donation_model.dart';
import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color _primaryOrange = Color(0xFFFF8C42);
  static const Color _screenBackground = Color(0xFFF7F7F7);
  static const String _donorName = 'رؤى علي';
  static const String _donorSubtitle = 'متبرع';

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final donations = provider.myDonations;
    final completedCount = donations.where((donation) {
      final status = donation.status.toLowerCase();
      return donation.status.contains('مكتمل') ||
          donation.status.contains('استلام') ||
          status.contains('completed');
    }).length;
    final pendingCount =
        donations.isEmpty ? 0 : donations.length - completedCount;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _screenBackground,
        body: SafeArea(
          bottom: false,
          child: DonorMobileFrame(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 360),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 12 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsetsDirectional.fromSTEB(20, 14, 20, 24),
                children: [
                  _ProfileHeader(
                    name: _donorName,
                    subtitle: _donorSubtitle,
                    total: donations.length,
                    completed: completedCount,
                    pending: pendingCount,
                    onEditTap: () => _showAccountSummary(context, donations),
                    onCameraTap: () => _showPhotoOptions(context),
                  ),
                  const SizedBox(height: 18),
                  _ProfileMenuSection(
                    children: [
                      _ProfileMenuTile(
                        icon: Icons.person_outline_rounded,
                        title: 'ملخص الحساب',
                        subtitle: 'عرض بيانات المتبرع الحالية',
                        onTap: () => _showAccountSummary(context, donations),
                      ),
                      _ProfileMenuTile(
                        icon: Icons.receipt_long_outlined,
                        title: 'سجل التبرعات',
                        subtitle: 'متابعة مساهماتك وحالاتها',
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/donation_history',
                        ),
                      ),
                      _ProfileMenuTile(
                        icon: Icons.lock_outline_rounded,
                        title: 'الأمان وكلمة المرور',
                        subtitle: 'إدارة حماية الحساب',
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/change_password',
                        ),
                      ),
                      _ProfileMenuTile(
                        icon: Icons.settings_outlined,
                        title: 'إعدادات التطبيق',
                        subtitle: 'الإشعارات واللغة والمظهر',
                        onTap: () => Navigator.pushNamed(context, '/settings'),
                      ),
                      _ProfileMenuTile(
                        icon: Icons.support_agent_rounded,
                        title: 'الدعم والمساعدة',
                        subtitle: 'الحصول على مساعدة أو طرح سؤال',
                        onTap: () => _showSupportSheet(context),
                      ),
                      _ProfileMenuTile(
                        icon: Icons.info_outline_rounded,
                        title: 'عن كنف',
                        subtitle: 'معلومات عن التطبيق ورسالته',
                        onTap: () => Navigator.pushNamed(context, '/about_app'),
                      ),
                      _ProfileMenuTile(
                        icon: Icons.logout_rounded,
                        title: 'تسجيل الخروج',
                        subtitle: 'إنهاء الجلسة الحالية',
                        isDestructive: true,
                        onTap: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: donorMobileBottomBar(
          child: _profileBottomNavigation(context),
        ),
      ),
    );
  }

  void _showAccountSummary(
    BuildContext context,
    List<DonationModel> donations,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.innerBorder,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: DonorSpacing.xl),
                  Text(
                    'ملخص الحساب',
                    style: DonorTextStyles.title.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: DonorSpacing.sm),
                  Text(
                    'يعرض التطبيق حاليًا ملخصًا آمنًا من سجل المساهمات المتاح.',
                    style: DonorTextStyles.body.copyWith(
                      height: 1.55,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                  const SizedBox(height: DonorSpacing.lg),
                  _SummaryRow(
                    icon: Icons.receipt_long_outlined,
                    label: 'عدد المساهمات المسجلة',
                    value: '${donations.length}',
                  ),
                  const SizedBox(height: DonorSpacing.sm),
                  const _SummaryRow(
                    icon: Icons.verified_user_outlined,
                    label: 'حالة الحساب',
                    value: 'نشط',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.innerBorder,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'تعديل الصورة الشخصية',
                    style: DonorTextStyles.title.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 14),
                  _SheetActionTile(
                    icon: Icons.photo_library_outlined,
                    title: 'اختيار صورة من المعرض',
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),
                  _SheetActionTile(
                    icon: Icons.photo_camera_outlined,
                    title: 'التقاط صورة جديدة',
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSupportSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.innerBorder,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'الدعم والمساعدة',
                    style: DonorTextStyles.title.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'يمكنك التواصل مع فريق كنف للحصول على المساعدة أو متابعة حالة مساهماتك.',
                    style: DonorTextStyles.body.copyWith(
                      height: 1.55,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _profileBottomNavigation(BuildContext context) {
    return NavigationBar(
      selectedIndex: 2,
      height: 72,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      indicatorColor: AppColors.brandOrangeLight,
      onDestinationSelected: (index) {
        if (index == 0) {
          Navigator.pushNamed(context, '/supporter_home');
        } else if (index == 1) {
          Navigator.pushNamed(context, '/donation_history');
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded, color: AppColors.brandOrange),
          label: 'الرئيسية',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon:
              Icon(Icons.receipt_long_rounded, color: AppColors.brandOrange),
          label: 'السجل',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon:
              Icon(Icons.person_rounded, color: AppColors.brandOrange),
          label: 'حسابي',
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.subtitle,
    required this.total,
    required this.completed,
    required this.pending,
    required this.onEditTap,
    required this.onCameraTap,
  });

  final String name;
  final String subtitle;
  final int total;
  final int completed;
  final int pending;
  final VoidCallback onEditTap;
  final VoidCallback onCameraTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: ProfileScreen._primaryOrange,
        boxShadow: [
          BoxShadow(
            color: ProfileScreen._primaryOrange.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: _HeaderSmallButton(
                  icon: Icons.edit_outlined,
                  tooltip: 'تعديل البيانات الشخصية',
                  onTap: onEditTap,
                ),
              ),
              const SizedBox(height: 2),
              _DonorProfileAvatar(onCameraTap: onCameraTap),
              const SizedBox(height: 12),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: DonorTextStyles.title.copyWith(
                  fontSize: 21,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: DonorTextStyles.muted.copyWith(
                  fontSize: 13.5,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              _ImpactStatsCard(
                total: total,
                completed: completed,
                pending: pending,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderSmallButton extends StatelessWidget {
  const _HeaderSmallButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.26)),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }
}

class _DonorProfileAvatar extends StatelessWidget {
  const _DonorProfileAvatar({required this.onCameraTap});

  final VoidCallback onCameraTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      height: 112,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Hero(
            tag: 'donor-profile-avatar',
            child: Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Container(
                  color: ProfileScreen._primaryOrange.withOpacity(0.16),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 54,
                    color: ProfileScreen._primaryOrange,
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 4,
            end: 2,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onCameraTap,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.photo_camera_outlined,
                    color: ProfileScreen._primaryOrange,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactStatsCard extends StatelessWidget {
  const _ImpactStatsCard({
    required this.total,
    required this.completed,
    required this.pending,
  });

  final int total;
  final int completed;
  final int pending;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _StatItem(value: '$total', label: 'عدد المساهمات')),
          const _StatDivider(),
          Expanded(child: _StatItem(value: '$completed', label: 'المكتملة')),
          const _StatDivider(),
          Expanded(child: _StatItem(value: '$pending', label: 'قيد المتابعة')),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: DonorTextStyles.title.copyWith(
            fontSize: 18,
            color: ProfileScreen._primaryOrange,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: DonorTextStyles.muted.copyWith(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textDarkPrimary,
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
      height: 36,
      color: AppColors.innerBorder,
    );
  }
}

class _ProfileMenuSection extends StatelessWidget {
  const _ProfileMenuSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < children.length; index++) ...[
            children[index],
            if (index != children.length - 1)
              Divider(
                height: 1,
                indent: 72,
                endIndent: 18,
                color: AppColors.innerBorder.withOpacity(0.75),
              ),
          ],
        ],
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color =
        isDestructive ? AppColors.errorRed : ProfileScreen._primaryOrange;

    return ListTile(
      onTap: onTap,
      minVerticalPadding: 10,
      contentPadding:
          const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 21),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: DonorTextStyles.sectionTitle.copyWith(
          fontSize: 14.2,
          color: isDestructive ? AppColors.errorRed : AppColors.textDarkPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: DonorTextStyles.muted.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textDarkSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_left_rounded,
        color: isDestructive ? AppColors.errorRed : AppColors.textDarkMuted,
      ),
    );
  }
}

class _SheetActionTile extends StatelessWidget {
  const _SheetActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Icon(icon, color: ProfileScreen._primaryOrange, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: DonorTextStyles.sectionTitle.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(icon, color: ProfileScreen._primaryOrange, size: 20),
          const SizedBox(width: DonorSpacing.sm),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DonorTextStyles.body.copyWith(
                fontSize: 13.5,
                color: AppColors.textDarkSecondary,
              ),
            ),
          ),
          const SizedBox(width: DonorSpacing.sm),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DonorTextStyles.button.copyWith(
              fontSize: 13.5,
              color: AppColors.textDarkPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: card,
      ),
    );
  }
}
