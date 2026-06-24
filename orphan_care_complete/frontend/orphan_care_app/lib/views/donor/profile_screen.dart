import 'package:flutter/material.dart';

import '../../models/donation_model.dart';
import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        backgroundColor: AppColors.scaffoldBackground,
        body: Stack(
          children: [
            const Positioned.fill(child: DonorBackground()),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: donorMobileMaxWidth),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 16),
                      _buildImpactRow(
                        total: donations.length,
                        completed: completedCount,
                        pending: pendingCount,
                      ),
                      if (donations.isEmpty) ...[
                        const SizedBox(height: 12),
                        DonorEmptyState(
                          icon: Icons.volunteer_activism_outlined,
                          title: 'ابدئي أول مساهمة لك',
                          message:
                              'لم يتم تسجيل أي مساهمة بعد. يمكنك استكشاف الاحتياجات المتاحة والبدء بخطوة بسيطة.',
                          actionLabel: 'استكشاف الاحتياجات',
                          onAction: () =>
                              Navigator.pushNamed(context, '/supporter_home'),
                        ),
                      ],
                      const SizedBox(height: 18),
                      _MenuGroup(
                        children: [
                          _MenuTile(
                            icon: Icons.person_outline_rounded,
                            title: 'ملخص الحساب',
                            subtitle: 'عرض بيانات المتبرع الحالية',
                            onTap: () =>
                                _showAccountSummary(context, donations),
                          ),
                          _MenuTile(
                            icon: Icons.receipt_long_outlined,
                            title: 'سجل التبرعات',
                            subtitle: 'متابعة مساهماتك وحالاتها',
                            onTap: () => Navigator.pushNamed(
                                context, '/donation_history'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _MenuGroup(
                        children: [
                          _MenuTile(
                            icon: Icons.lock_outline_rounded,
                            title: 'الأمان وكلمة المرور',
                            subtitle: 'إدارة حماية الحساب',
                            onTap: () => Navigator.pushNamed(
                                context, '/change_password'),
                          ),
                          _MenuTile(
                            icon: Icons.settings_outlined,
                            title: 'إعدادات التطبيق',
                            subtitle: 'الإشعارات واللغة والمظهر',
                            onTap: () =>
                                Navigator.pushNamed(context, '/settings'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      DonorSecondaryButton(
                        label: 'تسجيل الخروج',
                        icon: Icons.logout_rounded,
                        color: AppColors.errorRed,
                        onTap: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return DonorCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.brandOrangeLight,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.innerBorder),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 36,
                  color: AppColors.brandOrange,
                ),
              ),
              Positioned(
                bottom: -3,
                left: -3,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.innerBorder),
                  ),
                  // TODO: Connect camera action to profile image upload when API is available.
                  child: const Icon(
                    Icons.photo_camera_outlined,
                    size: 16,
                    color: AppColors.brandOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رؤى علي',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'عضوة في مجتمع كنف للعطاء',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 13.5,
                    color: AppColors.textDarkSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactRow({
    required int total,
    required int completed,
    required int pending,
  }) {
    return Row(
      children: [
        Expanded(child: _ImpactCard(value: '$total', label: 'مساهمات')),
        const SizedBox(width: 10),
        Expanded(child: _ImpactCard(value: '$completed', label: 'مكتملة')),
        const SizedBox(width: 10),
        Expanded(child: _ImpactCard(value: '$pending', label: 'قيد المتابعة')),
      ],
    );
  }

  void _showAccountSummary(
      BuildContext context, List<DonationModel> donations) {
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
                  const Text(
                    'ملخص الحساب',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDarkPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'يعرض التطبيق حاليًا ملخصًا آمنًا من سجل المساهمات المتاح.',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      height: 1.55,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SummaryRow(
                    icon: Icons.receipt_long_outlined,
                    label: 'عدد المساهمات المسجلة',
                    value: '${donations.length}',
                  ),
                  const SizedBox(height: 10),
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
    return DonorCard(
      padding: const EdgeInsets.all(14),
      color: AppColors.scaffoldBackground,
      child: Row(
        children: [
          Icon(icon, color: AppColors.brandOrange, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 13.5,
                color: AppColors.textDarkSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13.5,
              fontWeight: FontWeight.w900,
              color: AppColors.textDarkPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DonorCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.brandOrangeDark,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
              color: AppColors.textDarkSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DonorCard(
      padding: EdgeInsets.zero,
      child: Column(children: children),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: DonorIconBox(icon: icon, color: AppColors.brandOrange, size: 42),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: AppColors.textDarkPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 12.5,
          color: AppColors.textDarkSecondary,
        ),
      ),
      trailing: const Icon(Icons.chevron_left_rounded,
          color: AppColors.textDarkMuted),
    );
  }
}
