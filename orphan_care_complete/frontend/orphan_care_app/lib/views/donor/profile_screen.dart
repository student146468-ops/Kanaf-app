import 'package:flutter/material.dart';

import '../../models/donation_model.dart';
import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final donations = provider.myDonations;
    final completedCount = donations
        .where((donation) =>
            donation.status.contains('مكتمل') ||
            donation.status.contains('استلام') ||
            donation.status.toLowerCase().contains('completed'))
        .length;
    final pendingCount =
        donations.isEmpty ? 0 : donations.length - completedCount;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
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
                    _StartContributionCard(
                      onTap: () =>
                          Navigator.pushNamed(context, '/supporter_home'),
                    ),
                  ],
                  const SizedBox(height: 18),
                  _MenuGroup(
                    children: [
                      _MenuTile(
                        icon: Icons.person_rounded,
                        title: 'ملخص الحساب',
                        subtitle: 'عرض بيانات المتبرع الحالية',
                        onTap: () => _showAccountSummary(context, donations),
                      ),
                      _MenuTile(
                        icon: Icons.receipt_long_rounded,
                        title: 'سجل التبرعات',
                        subtitle: 'متابعة مساهماتك وحالاتها',
                        onTap: () =>
                            Navigator.pushNamed(context, '/donation_history'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _MenuGroup(
                    children: [
                      _MenuTile(
                        icon: Icons.lock_rounded,
                        title: 'الأمان وكلمة المرور',
                        subtitle: 'إدارة حماية الحساب',
                        onTap: () =>
                            Navigator.pushNamed(context, '/change_password'),
                      ),
                      _MenuTile(
                        icon: Icons.settings_rounded,
                        title: 'إعدادات التطبيق',
                        subtitle: 'الإشعارات واللغة والمظهر',
                        onTap: () => Navigator.pushNamed(context, '/settings'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('تسجيل الخروج'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      foregroundColor: AppColors.errorRed,
                      side: const BorderSide(color: AppColors.errorRed),
                      textStyle: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
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

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.innerBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.brandOrangeLight,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.person_rounded,
                size: 34, color: AppColors.brandOrange),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الداعم الكريم',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'عضو في مجتمع كنف للعطاء',
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
                    'لا توجد بيانات ملف شخصي منفصلة في مزود التطبيق الحالي، لذلك يتم عرض ملخص آمن من سجل مساهماتك المتاح.',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      height: 1.55,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SummaryRow(
                    icon: Icons.receipt_long_rounded,
                    label: 'عدد المساهمات المسجلة',
                    value: '${donations.length}',
                  ),
                  const SizedBox(height: 10),
                  const _SummaryRow(
                    icon: Icons.verified_user_rounded,
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.innerBorder),
      ),
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
              fontWeight: FontWeight.w800,
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.innerBorder),
      ),
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
              color: Color(0xFF526577),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.innerBorder),
      ),
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
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.brandOrangeLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppColors.brandOrange, size: 21),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: AppColors.textDarkPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 12.5,
          color: Color(0xFF66788A),
        ),
      ),
      trailing: const Icon(Icons.chevron_left_rounded,
          color: AppColors.textDarkMuted),
    );
  }
}

class _StartContributionCard extends StatelessWidget {
  const _StartContributionCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.brandOrangeLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brandOrange.withOpacity(0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.volunteer_activism_rounded,
              color: AppColors.brandOrange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ابدأ أول مساهمة لك',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'لم يتم تسجيل أي مساهمة بعد. يمكنك استكشاف الاحتياجات المتاحة والبدء بخطوة بسيطة.',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 13.5,
                    height: 1.45,
                    color: Color(0xFF526577),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.search_rounded, size: 17),
                    label: const Text('استكشف الاحتياجات الآن'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.brandOrangeDark,
                      textStyle: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
