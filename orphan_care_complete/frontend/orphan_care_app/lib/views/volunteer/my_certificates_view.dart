import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'volunteer_ui.dart';

class MyCertificatesView extends StatelessWidget {
  const MyCertificatesView({super.key});

  // TODO: Replace with AppProvider certificates when available.
  static const List<Map<String, String>> _certificates = [
    {
      'title': 'شهادة تميز في الدعم التعليمي',
      'issuer': 'دار الأمان لرعاية الأيتام',
      'date': '28 أبريل 2026',
      'hours': '18 ساعة',
    },
    {
      'title': 'شهادة شكر لتنظيم الأنشطة',
      'issuer': 'مركز كنف المجتمعي',
      'date': '20 فبراير 2026',
      'hours': '10 ساعات',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return VolunteerAppScaffold(
      title: 'شهاداتي',
      body: SafeArea(
        top: false,
        child: _certificates.isEmpty
            ? VolunteerEmptyState(
                icon: Icons.workspace_premium_outlined,
                title: 'لا توجد شهادات بعد',
                message:
                    'بعد إكمال مساهمة تطوعية موثقة ستظهر شهادات التقدير هنا.',
                actionLabel: 'استكشاف الفرص',
                onAction: () =>
                    Navigator.of(context).pushNamed('/volunteer_search'),
              )
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  volunteerHorizontalPadding,
                  10,
                  volunteerHorizontalPadding,
                  24,
                ),
                itemCount: _certificates.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == 0) return const _IntroCard();
                  return _CertificateCard(
                    certificate: _certificates[index - 1],
                  );
                },
              ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return const VolunteerCard(
      color: AppColors.brandOrangeLight,
      borderColor: Colors.white,
      child: Row(
        children: [
          VolunteerIconBox(
            icon: Icons.workspace_premium_rounded,
            backgroundColor: Colors.white,
            size: 48,
            iconSize: 25,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'توثق الشهادات مساهماتك التطوعية مع دور الرعاية وتبرز أثر وقتك.',
              style: volunteerBodyStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final Map<String, String> certificate;

  const _CertificateCard({required this.certificate});

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      child: Column(
        children: [
          Row(
            children: [
              const VolunteerIconBox(
                icon: Icons.verified_rounded,
                color: Color(0xFFFFB300),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      certificate['title']!,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textDarkPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(certificate['issuer']!, style: volunteerBodyStyle),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    VolunteerMetaChip(
                      label: certificate['date']!,
                      icon: Icons.calendar_month_outlined,
                      color: const Color(0xFF4A90E2),
                      prominent: true,
                    ),
                    VolunteerMetaChip(
                      label: certificate['hours']!,
                      icon: Icons.schedule_rounded,
                      color: AppColors.brandOrange,
                      prominent: true,
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'سيتم تفعيل تحميل "${certificate['title']}" عند ربط ملفات الشهادات.',
                        style: const TextStyle(fontFamily: 'Tajawal'),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.brandOrange,
                    ),
                  );
                },
                icon: const Icon(Icons.download_rounded, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.brandOrangeLight,
                  foregroundColor: AppColors.brandOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
