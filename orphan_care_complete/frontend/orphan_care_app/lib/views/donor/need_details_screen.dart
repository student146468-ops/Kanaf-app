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
    final daysLeft = _text('daysLeft', 'غير محدد');

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: donorMobileAppBar(
          title: 'تفاصيل الاحتياج',
          leading: IconButton(
            tooltip: 'رجوع',
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textDarkPrimary,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      children: [
                        _OrphanageTile(
                            name: _text('orphanage', 'دار رعاية الأيتام')),
                        const SizedBox(height: 18),
                        Text(
                          _text('title', 'احتياج إنساني قابل للدعم'),
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 20,
                            height: 1.45,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDarkPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _text(
                            'description',
                            'يساعد هذا الدعم في تغطية احتياج أساسي للأطفال داخل الدار، مع متابعة واضحة لحالة التبرع حتى يصل أثره إلى مكانه الصحيح.',
                          ),
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 15,
                            height: 1.65,
                            color: Color(0xFF526577),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _DetailBadge(
                              label: urgency,
                              icon: urgency == 'عاجل'
                                  ? Icons.priority_high_rounded
                                  : Icons.flag_rounded,
                              color: urgency == 'عاجل'
                                  ? AppColors.brandOrangeDark
                                  : AppColors.successGreen,
                            ),
                            _DetailBadge(
                              label: 'متبقي $daysLeft',
                              icon: Icons.schedule_rounded,
                              color: AppColors.skyBlueDark,
                            ),
                            _DetailBadge(
                              label: category,
                              icon: _impactIcon(category),
                              color: AppColors.textDarkSecondary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _ProgressCard(
                          raised: _text('raised', '0 د.ل'),
                          target: _text('target', '0 د.ل'),
                          daysLeft: _text('daysLeft', 'غير محدد'),
                          progress: progress,
                        ),
                        const SizedBox(height: 16),
                        _InfoCard(
                          title: _impactTitle(category),
                          body: _impactBody(category),
                          icon: _impactIcon(category),
                        ),
                        const SizedBox(height: 12),
                        const _InfoCard(
                          title: 'الأثر المتوقع',
                          body:
                              'كل مساهمة تقرب الحالة من الاكتمال وتمنح الأطفال رعاية أكثر استقرارًا وكرامة.',
                          icon: Icons.auto_awesome_rounded,
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
    if (category.contains('كس')) return 'احتياج كساء';
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
    return 'بعد إتمام التبرع يتم تسجيله في كنف وربطه بالحالة المختارة، ثم تتابع الدار التنفيذ وتحديث حالة الاحتياج.';
  }

  IconData _impactIcon(String category) {
    if (category.contains('غذ')) return Icons.ramen_dining_rounded;
    if (category.contains('كس')) return Icons.checkroom_rounded;
    if (category.contains('صح')) return Icons.health_and_safety_rounded;
    if (category.contains('مال')) return Icons.savings_rounded;
    return Icons.verified_user_rounded;
  }
}

class _OrphanageTile extends StatelessWidget {
  const _OrphanageTile({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.pushNamed(context, '/orphanage_profile'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.innerBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.brandOrangeLight,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.apartment_rounded,
                    color: AppColors.brandOrange),
              ),
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
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDarkPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'جهة مسجلة داخل منظومة كنف',
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
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.raised,
    required this.target,
    required this.daysLeft,
    required this.progress,
  });

  final String raised;
  final String target;
  final String daysLeft;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.innerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _Metric(
                    label: 'تم جمع',
                    value: raised,
                    color: AppColors.brandOrangeDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Metric(
                    label: 'المستهدف',
                    value: target,
                    color: AppColors.textDarkPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
              const Icon(Icons.insights_rounded,
                  color: AppColors.brandOrange, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'اكتمل $percentage% من الاحتياج',
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDarkSecondary,
                  ),
                ),
              ),
              Text(
                'متبقي $daysLeft',
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                  color: AppColors.textDarkMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailBadge extends StatelessWidget {
  const _DetailBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric(
      {required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

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
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard(
      {required this.title, required this.body, required this.icon});

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.innerBorder),
      ),
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
                    fontWeight: FontWeight.w800,
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
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.innerBorder)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 340;
          final financialButton = FilledButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, '/financial_donation'),
            icon: const Icon(Icons.savings_rounded, size: 18),
            label: Text(category.contains('مال') ? 'ادعم ماليًا' : 'تبرع مالي'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.brandOrange,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              textStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          );
          final inKindButton = OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/inkind_donation'),
            icon: const Icon(Icons.inventory_2_rounded, size: 18),
            label: Text(category.contains('مال') ? 'تبرع عيني' : 'قدّم عينيًا'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.successGreen,
              minimumSize: const Size.fromHeight(52),
              side: const BorderSide(color: AppColors.successGreen, width: 1.2),
              textStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          );

          if (isCompact) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: double.infinity, child: financialButton),
                const SizedBox(height: 10),
                SizedBox(width: double.infinity, child: inKindButton),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: financialButton),
              const SizedBox(width: 10),
              Expanded(child: inKindButton),
            ],
          );
        },
      ),
    );
  }
}
