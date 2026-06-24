import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class DonationSuccessScreen extends StatelessWidget {
  const DonationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final reference = args?['reference']?.toString() ??
        'DN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final type = args?['type']?.toString() ?? 'تبرع';
    final summary = args?['summary']?.toString() ??
        'تم تسجيل مساهمتك وربطها بالحالة المختارة.';

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
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Spacer(),
                        Container(
                          width: 104,
                          height: 104,
                          decoration: BoxDecoration(
                            color: AppColors.successGreenLight,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                                color:
                                    AppColors.successGreen.withOpacity(0.25)),
                          ),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            size: 66,
                            color: AppColors.successGreen,
                          ),
                        ),
                        const SizedBox(height: 26),
                        const Text(
                          'تم تسجيل مساهمتك بنجاح',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 23,
                            height: 1.35,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDarkPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'شكرًا لعطائك. ستظهر تحديثات مساهمتك في السجل عند توفرها من دار الرعاية.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 15,
                            height: 1.65,
                            color: AppColors.textDarkSecondary,
                          ),
                        ),
                        const SizedBox(height: 22),
                        const DonorCard(
                          child: Row(
                            children: [
                              Icon(Icons.receipt_long_outlined,
                                  color: AppColors.brandOrange),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'تم إنشاء سجل للتبرع وربطه بالاحتياج المحدد.',
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 13.5,
                                    height: 1.45,
                                    color: AppColors.textDarkSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _DonationSummaryCard(
                          reference: reference,
                          type: type,
                          summary: summary,
                        ),
                        const Spacer(),
                        DonorPrimaryButton(
                          label: 'العودة للرئيسية',
                          icon: Icons.home_outlined,
                          onTap: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/supporter_home',
                            (route) => false,
                          ),
                        ),
                        const SizedBox(height: 10),
                        DonorSecondaryButton(
                          label: 'عرض سجل التبرعات',
                          icon: Icons.history_rounded,
                          onTap: () =>
                              Navigator.pushNamed(context, '/donation_history'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonationSummaryCard extends StatelessWidget {
  const _DonationSummaryCard({
    required this.reference,
    required this.type,
    required this.summary,
  });

  final String reference;
  final String type;
  final String summary;

  @override
  Widget build(BuildContext context) {
    return DonorCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryLine(label: 'الرقم المرجعي', value: reference),
          const SizedBox(height: 8),
          _SummaryLine(label: 'نوع التبرع', value: type),
          const SizedBox(height: 8),
          _SummaryLine(label: 'الملخص', value: summary),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 94,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12.5,
              color: AppColors.textDarkMuted,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textDarkPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
