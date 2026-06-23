import 'package:flutter/material.dart';

import '../../models/donation_model.dart';
import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class DonationHistoryScreen extends StatefulWidget {
  const DonationHistoryScreen({super.key});

  @override
  State<DonationHistoryScreen> createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = AppProviderScope.of(context);
      if (provider.myDonations.isEmpty && !provider.isLoading) {
        provider.fetchMyDonations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final realDonations = provider.myDonations;
    final hasProviderData = realDonations.isNotEmpty;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: donorMobileAppBar(title: 'سجل التبرعات'),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: RefreshIndicator(
                color: AppColors.brandOrange,
                onRefresh: provider.fetchMyDonations,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  children: [
                    _SummaryCard(
                      count: realDonations.length,
                      isLive: hasProviderData,
                    ),
                    if (provider.isLoading) ...[
                      const SizedBox(height: 14),
                      const LinearProgressIndicator(
                          color: AppColors.brandOrange),
                    ],
                    if (provider.errorMessage != null && !hasProviderData) ...[
                      const SizedBox(height: 14),
                      const _NoticeCard(
                          message:
                              'تعذر جلب السجل من الخادم حاليًا. اسحب للأسفل للمحاولة مرة أخرى.'),
                    ],
                    const SizedBox(height: 18),
                    if (hasProviderData)
                      ...realDonations.map(_buildProviderDonation)
                    else
                      const _EmptyHistory(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProviderDonation(DonationModel donation) {
    final isFinancial = donation.amount != null && donation.amount! > 0;
    final amount = isFinancial
        ? '${donation.amount!.toStringAsFixed(donation.amount! % 1 == 0 ? 0 : 2)} د.ل'
        : _safeText(donation.itemType, 'تبرع عيني');
    final target =
        _safeText(donation.description, donation.category ?? 'مساهمة إنسانية');
    final date = _formatDate(donation.donationDate ?? donation.createdAt);
    final progress = _progressForStatus(donation.status);

    return _DonationCard(
      type: isFinancial ? 'مالي' : 'عيني',
      amount: amount,
      target: target,
      date: date,
      status: _safeText(donation.status, 'قيد المتابعة'),
      progress: progress,
      onTap: () => _showDonationDetails(
        type: isFinancial ? 'مالي' : 'عيني',
        amount: amount,
        target: target,
        date: date,
        status: _safeText(donation.status, 'قيد المتابعة'),
        description: _safeText(donation.description, 'لا توجد تفاصيل إضافية.'),
      ),
    );
  }

  double _progressForStatus(String status) {
    if (status.contains('مكتمل') ||
        status.contains('استلام') ||
        status.toLowerCase().contains('completed')) {
      return 1;
    }
    if (status.contains('رفض') || status.contains('فشل')) {
      return 0;
    }
    return 0.55;
  }

  void _showDonationDetails({
    required String type,
    required String amount,
    required String target,
    required String date,
    required String status,
    required String description,
  }) {
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
                    'تفاصيل التبرع',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDarkPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _DetailRow(label: 'النوع', value: type),
                  _DetailRow(label: 'القيمة', value: amount),
                  _DetailRow(label: 'الحالة', value: status),
                  _DetailRow(label: 'التاريخ', value: date),
                  _DetailRow(label: 'الوجهة', value: target),
                  _DetailRow(label: 'الوصف', value: description),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _safeText(String? value, String fallback) {
    final text = value?.trim();
    return text == null || text.isEmpty ? fallback : text;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'غير محدد';
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}/$month/$day';
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.count, required this.isLive});

  final int count;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.innerBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.brandOrangeLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.receipt_long_rounded,
                color: AppColors.brandOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count مساهمة مسجلة',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLive
                      ? 'بياناتك محدثة من مزود التطبيق'
                      : 'لا توجد مساهمات مسجلة حتى الآن',
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 13,
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

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.brandOrangeLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.brandOrange, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 13,
                color: AppColors.brandOrangeDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonationCard extends StatelessWidget {
  const _DonationCard({
    required this.type,
    required this.amount,
    required this.target,
    required this.date,
    required this.status,
    required this.progress,
    required this.onTap,
  });

  final String type;
  final String amount;
  final String target;
  final String date;
  final String status;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isFinancial = type == 'مالي';
    final statusColor = _statusColor(status);
    final percentage = (progress * 100).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.innerBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isFinancial
                        ? AppColors.brandOrangeLight
                        : AppColors.successGreenLight,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    isFinancial
                        ? Icons.savings_rounded
                        : Icons.inventory_2_rounded,
                    color: isFinancial
                        ? AppColors.brandOrange
                        : AppColors.successGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              amount,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDarkPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 5),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        target,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 13.5,
                          height: 1.4,
                          color: Color(0xFF526577),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              size: 14, color: AppColors.textDarkMuted),
                          const SizedBox(width: 5),
                          Text(
                            date,
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12.5,
                              color: Color(0xFF66788A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 5,
                                backgroundColor: AppColors.surfaceLight,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(statusColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$percentage% مكتمل',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: statusColor,
                            ),
                          ),
                        ],
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

  Color _statusColor(String status) {
    if (status.contains('مكتمل') || status.contains('استلام')) {
      return AppColors.successGreen;
    }
    if (status.contains('رفض') || status.contains('فشل')) {
      return AppColors.errorRed;
    }
    return AppColors.brandOrange;
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.innerBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.brandOrangeLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.volunteer_activism_rounded,
              color: AppColors.brandOrange,
              size: 32,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'لا توجد تبرعات بعد',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDarkPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'عند إتمام أول مساهمة ستظهر هنا مع حالتها وتفاصيلها.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14,
              height: 1.45,
              color: Color(0xFF526577),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/supporter_home'),
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
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 13,
                color: AppColors.textDarkMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textDarkPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
