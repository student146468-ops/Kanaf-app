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
  String _selectedFilter = 'الكل';

  static const Color _primaryOrange = Color(0xFFFF8C42);
  static const Color _screenBackground = Color(0xFFFFFFFF);
  static const Color _completedGreen = Color(0xFF4F8A64);
  static const Color _infoBlue = Color(0xFF3977B8);
  static const Color _softRed = Color(0xFFB85C4C);

  final List<String> _filters = const ['الكل', 'مالي', 'عيني'];

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
    final donations = provider.myDonations;
    final hasProviderData = donations.isNotEmpty;
    final filteredDonations = _filteredDonations(donations);
    final hasVisibleData = filteredDonations.isNotEmpty;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _screenBackground,
        appBar: DonorAppBar(
          title: 'سجل التبرعات',
          leading: donorBackButton(context),
        ),
        body: SafeArea(
          top: false,
          child: DonorMobileFrame(
            child: RefreshIndicator(
              color: _primaryOrange,
              onRefresh: provider.fetchMyDonations,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 26),
                children: [
                  _DonationHistoryFilterBar(
                    filters: _filters,
                    selectedFilter: _selectedFilter,
                    onSelected: (value) {
                      setState(() => _selectedFilter = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  _HistoryInfoBanner(
                    message: provider.errorMessage != null && !hasProviderData
                        ? 'تعذر جلب السجل من الخادم حاليًا. اسحب للأسفل للمحاولة مرة أخرى.'
                        : 'تابع تبرعاتك السابقة، وراجع تفاصيل كل مساهمة في أي وقت.',
                  ),
                  const SizedBox(height: 16),
                  _DonationSummaryCard(
                    totalAmount: _totalFinancialAmount(donations),
                    donationsCount: donations.length,
                    lastDonation: _lastDonationDate(donations),
                  ),
                  if (provider.isLoading) ...[
                    const SizedBox(height: DonorSpacing.xxl),
                    const _HistoryLoading(),
                  ],
                  const SizedBox(height: 22),
                  if (hasVisibleData) ...[
                    Text(
                      'آخر التبرعات',
                      style: DonorTextStyles.title.copyWith(
                        fontSize: 18,
                        color: AppColors.textDarkPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...filteredDonations.toList().asMap().entries.map(
                          (entry) => _buildProviderDonation(
                            entry.value,
                            entry.key,
                          ),
                        ),
                  ] else if (!provider.isLoading)
                    _DonationEmptyState(
                      message: hasProviderData
                          ? 'لا توجد تبرعات ضمن هذا النوع حاليًا.'
                          : 'عند إتمام أول مساهمة ستظهر هنا مع تفاصيلها.',
                      onAction: () =>
                          Navigator.pushNamed(context, '/supporter_home'),
                    ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: DonorBottomNavigationBar(
          currentIndex: 1,
          onTap: (index) => donorNavigateByBottomIndex(context, index),
        ),
      ),
    );
  }

  List<DonationModel> _filteredDonations(List<DonationModel> donations) {
    if (_selectedFilter == 'الكل') return donations;
    return donations.where((donation) {
      final isFinancial = donation.amount != null && donation.amount! > 0;
      return _selectedFilter == 'مالي' ? isFinancial : !isFinancial;
    }).toList();
  }

  double _totalFinancialAmount(List<DonationModel> donations) {
    return donations.fold<double>(
      0,
      (total, donation) => total + (donation.amount ?? 0),
    );
  }

  String _lastDonationDate(List<DonationModel> donations) {
    if (donations.isEmpty) return 'لا يوجد';
    final dates = donations
        .map((donation) => donation.donationDate ?? donation.createdAt)
        .whereType<DateTime>()
        .toList()
      ..sort((a, b) => b.compareTo(a));
    if (dates.isEmpty) return 'غير محدد';
    return _formatDate(dates.first);
  }

  Widget _buildProviderDonation(DonationModel donation, int index) {
    final isFinancial = donation.amount != null && donation.amount! > 0;
    final amountOrQuantity = isFinancial
        ? '${donation.amount!.toStringAsFixed(donation.amount! % 1 == 0 ? 0 : 2)} د.ل'
        : _safeText(donation.itemType, 'تبرع عيني');
    final target =
        _safeText(donation.description, donation.category ?? 'مساهمة إنسانية');
    final date = _formatDate(donation.donationDate ?? donation.createdAt);
    final status = _normalizeStatus(donation.status);
    final type = isFinancial ? 'تبرع مالي' : 'تبرع عيني';

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 260 + (index * 60).clamp(0, 240)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 8 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: _DonationHistoryCard(
          type: type,
          amountOrQuantity: amountOrQuantity,
          target: target,
          date: date,
          status: status,
          isFinancial: isFinancial,
          onTap: () => _showDonationDetails(
            type: type,
            amount: amountOrQuantity,
            target: target,
            date: date,
            status: status,
            description:
                _safeText(donation.description, 'لا توجد تفاصيل إضافية.'),
          ),
        ),
      ),
    );
  }

  String _normalizeStatus(String status) {
    final lower = status.toLowerCase();
    if (status.contains('مكتمل') ||
        status.contains('استلام') ||
        lower.contains('completed')) {
      return 'مكتمل';
    }
    if (status.contains('رفض') ||
        status.contains('فشل') ||
        status.contains('ملغي') ||
        lower.contains('rejected')) {
      return 'مرفوض';
    }
    return 'قيد التنفيذ';
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
          child: _DonationDetailsBottomSheet(
            type: type,
            amount: amount,
            status: status,
            date: date,
            target: target,
            description: description,
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

class _DonationHistoryFilterBar extends StatelessWidget {
  const _DonationHistoryFilterBar({
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: filters.map((filter) {
            final selected = filter == selectedFilter;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InkWell(
                  onTap: () => onSelected(filter),
                  borderRadius: BorderRadius.circular(999),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? _DonationHistoryScreenState._primaryOrange
                          : Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      filter,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DonorTextStyles.button.copyWith(
                        fontSize: 12.5,
                        color:
                            selected ? Colors.white : AppColors.textDarkPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _HistoryLoading extends StatelessWidget {
  const _HistoryLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          strokeWidth: 2.6,
          color: _DonationHistoryScreenState._primaryOrange,
        ),
      ),
    );
  }
}

class _HistoryInfoBanner extends StatelessWidget {
  const _HistoryInfoBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  _DonationHistoryScreenState._primaryOrange.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: _DonationHistoryScreenState._primaryOrange,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: DonorTextStyles.body.copyWith(
                fontSize: 13.2,
                fontWeight: FontWeight.w600,
                height: 1.45,
                color: AppColors.textDarkPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonationSummaryCard extends StatelessWidget {
  const _DonationSummaryCard({
    required this.totalAmount,
    required this.donationsCount,
    required this.lastDonation,
  });

  final double totalAmount;
  final int donationsCount;
  final String lastDonation;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              label: 'إجمالي التبرعات',
              value: '${_formatAmount(totalAmount)} د.ل',
            ),
          ),
          const _SummaryDivider(),
          Expanded(
            child: _SummaryItem(
              label: 'عدد التبرعات',
              value: donationsCount.toString(),
            ),
          ),
          const _SummaryDivider(),
          Expanded(
            child: _SummaryItem(
              label: 'آخر تبرع',
              value: lastDonation,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(amount % 1 == 0 ? 0 : 2);
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: DonorTextStyles.muted.copyWith(
            fontSize: 11.5,
            color: AppColors.textDarkMuted,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: DonorTextStyles.button.copyWith(
            fontSize: 13.5,
            color: _DonationHistoryScreenState._primaryOrange,
          ),
        ),
      ],
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 38,
      color: AppColors.innerBorder.withOpacity(0.8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _DonationHistoryCard extends StatelessWidget {
  const _DonationHistoryCard({
    required this.type,
    required this.amountOrQuantity,
    required this.target,
    required this.date,
    required this.status,
    required this.isFinancial,
    required this.onTap,
  });

  final String type;
  final String amountOrQuantity;
  final String target;
  final String date;
  final String status;
  final bool isFinancial;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: SizedBox(
        height: 82,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _DonationIconCircle(isFinancial: isFinancial),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DonorTextStyles.title.copyWith(
                      fontSize: 14.8,
                      color: AppColors.textDarkPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    target,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DonorTextStyles.body.copyWith(
                      fontSize: 12.8,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DonorTextStyles.muted.copyWith(
                      fontSize: 11.5,
                      color: AppColors.textDarkMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _DonationValueBlock(
              value: amountOrQuantity,
              isFinancial: isFinancial,
            ),
          ],
        ),
      ),
    );
  }
}

class _DonationIconCircle extends StatelessWidget {
  const _DonationIconCircle({required this.isFinancial});

  final bool isFinancial;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _DonationHistoryScreenState._primaryOrange.withOpacity(0.10),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isFinancial
            ? Icons.account_balance_wallet_outlined
            : Icons.inventory_2_outlined,
        color: _DonationHistoryScreenState._primaryOrange,
        size: 23,
      ),
    );
  }
}

class _DonationValueBlock extends StatelessWidget {
  const _DonationValueBlock({
    required this.value,
    required this.isFinancial,
  });

  final String value;
  final bool isFinancial;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isFinancial ? value : '—',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: DonorTextStyles.title.copyWith(
              fontSize: isFinancial ? 15.5 : 20,
              color: isFinancial
                  ? _DonationHistoryScreenState._primaryOrange
                  : AppColors.textDarkPrimary,
            ),
          ),
          const SizedBox(height: 7),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  _DonationHistoryScreenState._primaryOrange.withOpacity(0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              isFinancial ? 'مالية' : 'عينية',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DonorTextStyles.badge.copyWith(
                fontSize: 11,
                color: _DonationHistoryScreenState._primaryOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: DonorTextStyles.badge.copyWith(
          color: color,
          fontSize: 11,
        ),
      ),
    );
  }

  Color _statusColor(String value) {
    if (value.contains('مكتمل')) {
      return _DonationHistoryScreenState._completedGreen;
    }
    if (value.contains('مرفوض') || value.contains('ملغي')) {
      return _DonationHistoryScreenState._softRed;
    }
    if (value.contains('قيد')) return _DonationHistoryScreenState._infoBlue;
    return _DonationHistoryScreenState._primaryOrange;
  }
}

class _DonationDetailsBottomSheet extends StatelessWidget {
  const _DonationDetailsBottomSheet({
    required this.type,
    required this.amount,
    required this.status,
    required this.date,
    required this.target,
    required this.description,
  });

  final String type;
  final String amount;
  final String status;
  final String date;
  final String target;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 20, 24),
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
            const SizedBox(height: DonorSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'تفاصيل التبرع',
                    style: DonorTextStyles.title.copyWith(fontSize: 18),
                  ),
                ),
                IconButton(
                  tooltip: 'إغلاق',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textDarkMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DonorSpacing.md),
            _DetailRow(label: 'النوع', value: type),
            _DetailRow(label: 'القيمة', value: amount),
            Padding(
              padding: const EdgeInsets.only(bottom: DonorSpacing.sm),
              child: Row(
                children: [
                  SizedBox(
                    width: 82,
                    child: Text(
                      'الحالة',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DonorTextStyles.muted.copyWith(
                        color: AppColors.textDarkMuted,
                      ),
                    ),
                  ),
                  _StatusBadge(status: status),
                ],
              ),
            ),
            _DetailRow(label: 'التاريخ', value: date),
            _DetailRow(label: 'الوجهة', value: target),
            _DetailRow(label: 'الوصف', value: description),
          ],
        ),
      ),
    );
  }
}

class _DonationEmptyState extends StatelessWidget {
  const _DonationEmptyState({
    required this.message,
    required this.onAction,
  });

  final String message;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
      child: Column(
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color:
                  _DonationHistoryScreenState._primaryOrange.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: _DonationHistoryScreenState._primaryOrange,
              size: 38,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد تبرعات بعد',
            textAlign: TextAlign.center,
            style: DonorTextStyles.title.copyWith(
              fontSize: 18,
              color: AppColors.textDarkPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: DonorTextStyles.body.copyWith(
              fontSize: 13.5,
              height: 1.5,
              color: AppColors.textDarkSecondary,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: onAction,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: _DonationHistoryScreenState._primaryOrange,
              foregroundColor: Colors.white,
              textStyle: DonorTextStyles.button.copyWith(fontSize: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              elevation: 0,
            ),
            child: const Text('استكشف الاحتياجات الآن'),
          ),
        ],
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.innerBorder.withOpacity(0.55)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: card,
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
      padding: const EdgeInsets.only(bottom: DonorSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 82,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DonorTextStyles.muted.copyWith(
                color: AppColors.textDarkMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: DonorTextStyles.body.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textDarkPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
