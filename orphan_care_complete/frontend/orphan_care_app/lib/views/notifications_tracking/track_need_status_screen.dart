import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../settings/shared_mobile_ui.dart';

class TrackNeedStatusScreen extends StatelessWidget {
  const TrackNeedStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with AppProvider tracking data when available.
    final List<Map<String, dynamic>> trackingSteps = [
      {
        'title': 'تم استلام التبرع بنجاح',
        'subtitle': 'تم توثيق المساهمة داخل منظومة دار الرعاية.',
        'date': '01 يونيو 2026 - 10:30 ص',
        'isCompleted': true,
        'isActive': false,
      },
      {
        'title': 'شراء وتجهيز المواد',
        'subtitle': 'توفير الكسوة الشتوية والأغطية المطلوبة من الموردين.',
        'date': '02 يونيو 2026 - 04:15 م',
        'isCompleted': true,
        'isActive': false,
      },
      {
        'title': 'الفرز والتغليف',
        'subtitle': 'تجهيز الصناديق وتسميتها حسب الفئات العمرية للأطفال.',
        'date': '03 يونيو 2026 - 09:00 ص',
        'isCompleted': true,
        'isActive': true,
      },
      {
        'title': 'الشحن والتوصيل',
        'subtitle': 'انطلاق عملية التسليم للجهة المستفيدة.',
        'date': 'جاري العمل عليها',
        'isCompleted': false,
        'isActive': false,
      },
      {
        'title': 'التسليم والتوثيق',
        'subtitle': 'إغلاق الاحتياج وإرسال تحديث نهائي للمساهمين.',
        'date': 'مرحلة مستقبلية',
        'isCompleted': false,
        'isActive': false,
      },
    ];

    return KanafPage(
      title: 'تتبع حالة الاحتياج',
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _NeedSummaryCard(),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    child: Text('مسار التنفيذ', style: kanafSectionTitleStyle),
                  ),
                  KanafBadge(
                    label: 'قيد التنفيذ',
                    color: AppColors.skyBlueDark,
                    icon: Icons.timeline_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              KanafCard(
                child: Column(
                  children: [
                    for (int i = 0; i < trackingSteps.length; i++)
                      _TrackingStep(
                        step: trackingSteps[i],
                        isLast: i == trackingSteps.length - 1,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NeedSummaryCard extends StatelessWidget {
  const _NeedSummaryCard();

  @override
  Widget build(BuildContext context) {
    return const KanafCard(
      color: AppColors.brandOrangeLight,
      borderColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KanafIconBox(
                icon: Icons.inventory_2_outlined,
                backgroundColor: Colors.white,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'تأمين كسوة شتوية وأغطية دافئة لـ 25 طفلًا',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textDarkPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              KanafBadge(
                label: '#KNF-9921',
                color: AppColors.brandOrange,
                icon: Icons.qr_code_2_rounded,
              ),
              KanafBadge(
                label: 'قيد التنفيذ',
                color: AppColors.skyBlueDark,
                icon: Icons.timeline_rounded,
              ),
              KanafBadge(
                label: 'عاجل',
                color: AppColors.errorRed,
                icon: Icons.flag_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrackingStep extends StatelessWidget {
  final Map<String, dynamic> step;
  final bool isLast;

  const _TrackingStep({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isCompleted = step['isCompleted'] == true;
    final isActive = step['isActive'] == true;
    final color = isActive
        ? AppColors.brandOrange
        : isCompleted
            ? AppColors.successGreen
            : AppColors.textDarkMuted;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(isCompleted || isActive ? 1 : 0.16),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted
                    ? Icons.check_rounded
                    : isActive
                        ? Icons.sync_rounded
                        : Icons.circle_outlined,
                color: isCompleted || isActive ? Colors.white : color,
                size: 17,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 62,
                color: color.withOpacity(0.22),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        step['title'] as String,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: isActive
                              ? AppColors.brandOrange
                              : AppColors.textDarkPrimary,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    if (isActive)
                      const KanafBadge(
                        label: 'الحالية',
                        color: AppColors.brandOrange,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(step['subtitle'] as String, style: kanafBodyStyle),
                const SizedBox(height: 5),
                Text(step['date'] as String, style: kanafMutedStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
