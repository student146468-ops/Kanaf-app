import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class CareHomeProfileScreen extends StatelessWidget {
  const CareHomeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = AppProviderScope.of(context).dashboardStats;
    final activeNeeds = stats['active_needs']?.toString() ?? '14';
    final volunteers = stats['volunteers']?.toString() ?? '8';
    final monthlySupport = stats['monthly_support']?.toString() ?? '4,250 د.ل';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Stack(
              children: [
                const Positioned.fill(child: _CareHomeBackground()),
                SafeArea(
                  child: Column(
                    children: [
                      _HeaderBar(
                        title: 'ملف دار الرعاية',
                        onBack: () => Navigator.of(context).pop(),
                        onEdit: () => Navigator.of(context)
                            .pushNamed('/care_home_edit_profile'),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          child: Column(
                            children: [
                              const _ProfileHero(),
                              const SizedBox(height: 14),
                              const _InfoCard(
                                title: 'نبذة عن الدار',
                                icon: Icons.article_outlined,
                                child: Text(
                                  'نعمل على تنظيم الاحتياجات اليومية للأطفال، وتسهيل وصول المتبرعين والمتطوعين إلى الأولويات الحقيقية داخل الدار.',
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 14,
                                    height: 1.55,
                                    color: AppColors.textDarkSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: _MetricCard(
                                      label: 'احتياجات نشطة',
                                      value: activeNeeds,
                                      icon: Icons.inventory_2_outlined,
                                      color: AppColors.brandOrange,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _MetricCard(
                                      label: 'طلبات تطوع',
                                      value: volunteers,
                                      icon: Icons.groups_2_outlined,
                                      color: const Color(0xFF60A5FA),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _MetricCard(
                                label: 'دعم وارد هذا الشهر',
                                value: monthlySupport,
                                icon: Icons.account_balance_wallet_outlined,
                                color: const Color(0xFF34D399),
                                wide: true,
                              ),
                              const SizedBox(height: 14),
                              const _InfoCard(
                                title: 'معلومات التواصل',
                                icon: Icons.contact_phone_outlined,
                                child: Column(
                                  children: [
                                    _DetailRow(
                                      icon: Icons.person_outline_rounded,
                                      label: 'المسؤول',
                                      value: 'فريق إدارة كنف الرعائي',
                                    ),
                                    SizedBox(height: 12),
                                    _DetailRow(
                                      icon: Icons.phone_outlined,
                                      label: 'الهاتف',
                                      value: '+218 91 000 0000',
                                    ),
                                    SizedBox(height: 12),
                                    _DetailRow(
                                      icon: Icons.location_on_outlined,
                                      label: 'الموقع',
                                      value: 'غريان - ليبيا',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              _PrimaryAction(
                                label: 'إدارة الاحتياجات',
                                icon: Icons.format_list_bulleted_rounded,
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/care_home_needs_list'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CareHomeBackground extends StatelessWidget {
  const _CareHomeBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.white, AppColors.scaffoldBackground],
        ),
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  const _HeaderBar({
    required this.title,
    required this.onBack,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _CircleButton(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textDarkPrimary,
              ),
            ),
          ),
          _CircleButton(icon: Icons.edit_outlined, onTap: onEdit),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.innerBorder),
        ),
        child: Icon(icon, color: AppColors.textDarkPrimary, size: 19),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero();

  @override
  Widget build(BuildContext context) {
    return CareHomeCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                      const LinearGradient(colors: AppColors.orangeGradient),
                  border: Border.all(color: AppColors.innerBorder, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brandOrange.withOpacity(0.20),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.home_work_outlined,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              Positioned(
                bottom: -2,
                left: -2,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.innerBorder),
                  ),
                  // TODO: Connect camera action to image upload when profile media is available.
                  child: const Icon(
                    Icons.photo_camera_outlined,
                    color: AppColors.brandOrange,
                    size: 17,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'دار الأمان لرعاية الأيتام',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textDarkPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_outlined,
                  color: AppColors.brandOrange, size: 18),
              const SizedBox(width: 6),
              Text(
                'غريان - ليبيا',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDarkSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CareHomeCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.brandOrange, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDarkPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool wide;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return CareHomeCard(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: wide ? 16 : 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12,
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
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textDarkSecondary, size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 12,
            color: AppColors.textDarkMuted.withOpacity(0.75),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDarkPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: AppColors.orangeGradient),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandOrange.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 21),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
