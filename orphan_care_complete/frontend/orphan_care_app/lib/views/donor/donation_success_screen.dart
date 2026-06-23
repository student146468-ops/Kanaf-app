import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Spacer(),
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        color: AppColors.successGreenLight,
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        size: 72,
                        color: AppColors.successGreen,
                      ),
                    ),
                    const SizedBox(height: 28),
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
                      'شكرًا لعطائك. سيتم توجيه تبرعك للحالة المختارة، ويمكنك متابعة مساهماتك من السجل في أي وقت.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 15,
                        height: 1.65,
                        color: AppColors.textDarkSecondary,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.innerBorder),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.receipt_long_rounded,
                              color: AppColors.brandOrange),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'تم إنشاء سجل للتبرع، وستظهر تحديثاته عند توفرها من الدار.',
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
                    FilledButton.icon(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/supporter_home',
                        (route) => false,
                      ),
                      icon: const Icon(Icons.home_rounded, size: 18),
                      label: const Text('العودة للرئيسية'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: AppColors.brandOrange,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/donation_history'),
                      icon: const Icon(Icons.history_rounded, size: 18),
                      label: const Text('عرض سجل التبرعات'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        foregroundColor: AppColors.textDarkSecondary,
                        side: const BorderSide(color: AppColors.innerBorder),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.innerBorder),
      ),
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
          width: 92,
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
              fontWeight: FontWeight.w700,
              color: AppColors.textDarkPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
