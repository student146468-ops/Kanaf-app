import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class NeedDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> needData;

  const NeedDetailsScreen({super.key, required this.needData});

  @override
  Widget build(BuildContext context) {
    final progress = _progressValue;
    final category = _text('category', 'عام');
    final urgency = _text('urgency', 'متوسط');
    final status = _text('status', 'قيد التنفيذ');
    final daysLeft = _text('daysLeft', 'غير محدد');
    final percentage = (progress * 100).round();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: donorMobileAppBar(
          title: 'تفاصيل الاحتياج',
          leading: donorBackButton(context),
        ),
        body: Stack(
          children: [
            const Positioned.fill(child: DonorBackground()),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: donorMobileMaxWidth),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                          children: [
                            _OrphanageTile(
                                name: _text('orphanage', 'دار رعاية الأيتام')),
                            const SizedBox(height: 16),
                            DonorCard(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      DonorBadge(
                                        label: urgency,
                                        color: donorStatusColor(urgency),
                                        icon: urgency == 'عاجل'
                                            ? Icons.priority_high_rounded
                                            : Icons.flag_outlined,
                                      ),
                                      DonorBadge(
                                        label: status,
                                        color: donorStatusColor(status),
                                        icon: Icons.timelapse_outlined,
                                      ),
                                      DonorBadge(
                                        label: category,
                                        color: AppColors.textDarkSecondary,
                                        icon: _impactIcon(category),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    _text('title', 'احتياج إنساني قابل للدعم'),
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 20,
                                      height: 1.45,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textDarkPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _text(
                                      'description',
                                      'يساعد هذا الدعم في تغطية احتياج أساسي للأطفال داخل الدار مع متابعة واضحة لحالة التبرع.',
                                    ),
                                    style: const TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontSize: 15,
                                      height: 1.65,
                                      color: AppColors.textDarkSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            _ProgressCard(
                              raised: _text('raised', '0 د.ل'),
                              target: _text('target', '0 د.ل'),
                              remaining: _text('remaining', 'غير محدد'),
                              daysLeft: daysLeft,
                              progress: progress,
                              percentage: percentage,
                            ),
                            const SizedBox(height: 14),
                            _InfoCard(
                              title: _impactTitle(category),
                              body: _impactBody(category),
                              icon: _impactIcon(category),
                            ),
                            const SizedBox(height: 12),
                            const _InfoCard(
                              title: 'الأثر المتوقع',
                              body:
                                  'كل مساهمة تقرّب الاحتياج من الاكتمال وتمنح الأطفال رعاية أكثر استقرارًا وكرامة.',
                              icon: Icons.auto_awesome_outlined,
                            ),
                          ],
                        ),
                      ),
                      _ActionBar(category: category),
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

  String _text(String key, String fallback) {
    final value = needData[key];
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  double get _progressValue {
    final value = needData['progress'];
    if (value is num) return value.toDouble().clamp(0.0, 1.0);
    return 0;
  }

  String _impactTitle(String category) {
    if (category.contains('غذ')) return 'احتياج غذائي';
    if (category.contains('كس')) return 'احتياج كسوة';
    if (category.contains('صح')) return 'احتياج صحي';
    if (category.contains('مال')) return 'دعم مالي مباشر';
    return 'كيف يصل دعمك؟';
  }

  String _impactBody(String category) {
    if (category.contains('غذ')) {
      return 'يساعد الدعم في توفير مواد غذائية أساسية لوجبات الأطفال اليومية داخل الدار.';
    }
    if (category.contains('كس')) {
      return 'يساعد الدعم في توفير ملابس وأحذية مناسبة تحفظ راحة الأطفال وكرامتهم.';
    }
    if (category.contains('صح')) {
      return 'يساعد الدعم في تغطية احتياجات الرعاية الصحية والمستلزمات الأساسية.';
    }
    if (category.contains('مال')) {
      return 'يتم تسجيل المساهمة وربطها بالحالة المختارة لمتابعة أثرها بشكل واضح.';
    }
    return 'بعد إتمام التبرع يتم تسجيله في كنف وربطه بالحالة المختارة ثم تتابع الدار التنفيذ.';
  }

  IconData _impactIcon(String category) {
    if (category.contains('غذ')) return Icons.restaurant_outlined;
    if (category.contains('كس')) return Icons.checkroom_outlined;
    if (category.contains('صح')) return Icons.health_and_safety_outlined;
    if (category.contains('مال')) return Icons.savings_outlined;
    return Icons.verified_user_outlined;
  }
}

class _OrphanageTile extends StatelessWidget {
  const _OrphanageTile({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return DonorCard(
      onTap: () => Navigator.pushNamed(context, '/orphanage_profile'),
      child: Row(
        children: [
          const DonorIconBox(
              icon: Icons.home_work_outlined, color: AppColors.brandOrange),
          const SizedBox(width: 12),
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
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'دار مسجلة داخل منظومة كنف',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12.5,
                    color: AppColors.textDarkMuted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_left_rounded,
              color: AppColors.textDarkMuted),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.raised,
    required this.target,
    required this.remaining,
    required this.daysLeft,
    required this.progress,
    required this.percentage,
  });

  final String raised;
  final String target;
  final String remaining;
  final String daysLeft;
  final double progress;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return DonorCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _Metric(label: 'تم جمعه', value: raised)),
              const SizedBox(width: 10),
              Expanded(child: _Metric(label: 'المستهدف', value: target)),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.surfaceLight,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.brandOrange),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              DonorBadge(
                label: '$percentage% مكتمل',
                color: AppColors.brandOrangeDark,
                icon: Icons.insights_outlined,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'متبقي $remaining • $daysLeft',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 13,
                    color: AppColors.textDarkSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
              color: AppColors.textDarkMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.textDarkPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DonorCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.skyBlueDark, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 13.5,
                    height: 1.5,
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

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return donorMobileBottomBar(
      height: 86,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.innerBorder)),
        ),
        child: Row(
          children: [
            Expanded(
              child: DonorPrimaryButton(
                label: category.contains('مال') ? 'ادعم ماليًا' : 'ادعم ماليًا',
                icon: Icons.savings_outlined,
                onTap: () =>
                    Navigator.pushNamed(context, '/financial_donation'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DonorSecondaryButton(
                label: 'تبرع عيني',
                icon: Icons.inventory_2_outlined,
                color: AppColors.successGreen,
                onTap: () => Navigator.pushNamed(context, '/inkind_donation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
