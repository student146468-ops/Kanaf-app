import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class FinancialDonationScreen extends StatefulWidget {
  const FinancialDonationScreen({super.key});

  @override
  State<FinancialDonationScreen> createState() =>
      _FinancialDonationScreenState();
}

class _FinancialDonationScreenState extends State<FinancialDonationScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedQuickAmount = '';
  String _selectedPaymentMethod = 'السداد عبر المصرف';
  String _selectedDonationMode = 'تبرع مرة واحدة';
  String? _amountError;
  bool _isProcessing = false;

  static const Color _primaryOrange = Color(0xFFFF8C42);
  static const Color _screenBackground = Color(0xFFF5F5F5);
  static const Color _cardBorder = Color(0xFFEAEAEA);

  final List<String> _donationModes = const [
    'تبرع مرة واحدة',
    'تبرع شهري',
  ];

  final List<String> _quickAmounts = const ['20', '50', '100', '200'];

  final List<Map<String, dynamic>> _paymentMethods = const [
    {
      'name': 'السداد عبر المصرف',
      'icon': Icons.account_balance_outlined,
    },
    {
      'name': 'بطاقة مدى المحلية',
      'icon': Icons.credit_card_rounded,
    },
    {
      'name': 'تحويل مصرفي',
      'icon': Icons.swap_horiz_rounded,
    },
    {
      'name': 'محفظة إلكترونية',
      'icon': Icons.account_balance_wallet_outlined,
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    if (provider.currentUser.isEmpty && !provider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) provider.fetchCurrentUser(notifyLoading: false);
      });
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _screenBackground,
        appBar: const DonorAppBar(
          title: 'التبرع المالي',
        ),
        body: SafeArea(
          top: false,
          child: DonorMobileFrame(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    children: [
                      _DonationModeTabs(
                        modes: _donationModes,
                        selectedMode: _selectedDonationMode,
                        onSelected: (mode) {
                          setState(() => _selectedDonationMode = mode);
                        },
                      ),
                      const SizedBox(height: DonorSpacing.xxl),
                      const DonorSectionTitle('اختر مبلغ التبرع'),
                      const SizedBox(height: DonorSpacing.md),
                      _buildQuickAmounts(),
                      const SizedBox(height: DonorSpacing.lg),
                      _buildAmountField(),
                      const SizedBox(height: DonorSpacing.xxl),
                      const DonorSectionTitle('اختر طريقة الدفع'),
                      const SizedBox(height: DonorSpacing.md),
                      _buildPaymentMethods(),
                    ],
                  ),
                ),
                donorMobileBottomBar(
                  height: 86,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: AppColors.innerBorder),
                      ),
                    ),
                    child: DonorPrimaryButton(
                      label: _isProcessing ? 'جاري التأكيد...' : 'متابعة الدفع',
                      icon: _isProcessing
                          ? Icons.hourglass_top_rounded
                          : Icons.lock_outline_rounded,
                      onTap: _isProcessing ? null : _submit,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return DonorInputField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      onChanged: (_) {
        setState(() {
          _selectedQuickAmount = '';
          _amountError = null;
        });
      },
      style: DonorTextStyles.title.copyWith(
        fontSize: 25,
        color: AppColors.textDarkPrimary,
      ),
      hintText: 'أدخل مبلغًا آخر',
      hintStyle: DonorTextStyles.muted.copyWith(
        color: AppColors.textDarkMuted,
      ),
      errorText: _amountError,
      errorStyle: const TextStyle(fontFamily: 'Vazirmatn'),
      suffixIconWidget: const Icon(
        Icons.savings_outlined,
        color: _primaryOrange,
      ),
      focusedBorderColor: _primaryOrange,
      fillColor: Colors.white,
      enabledBorderWidth: 1,
      focusedBorderWidth: 1.2,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 17,
        horizontal: 16,
      ),
    );
  }

  Widget _buildQuickAmounts() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = DonorSpacing.sm;
        final itemWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: _quickAmounts.map((amount) {
            final selected = _selectedQuickAmount == amount;
            return SizedBox(
              width: itemWidth,
              height: 50,
              child: _AmountChoiceButton(
                label: '$amount د.ل',
                selected: selected,
                onTap: () {
                  setState(() {
                    _selectedQuickAmount = amount;
                    _amountController.text = amount;
                    _amountError = null;
                  });
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: _paymentMethods.map((method) {
        final selected = _selectedPaymentMethod == method['name'];
        return Padding(
          padding: const EdgeInsets.only(bottom: DonorSpacing.sm),
          child: _PaymentMethodCard(
            name: method['name'] as String,
            icon: method['icon'] as IconData,
            selected: selected,
            onTap: () => setState(
              () => _selectedPaymentMethod = method['name'] as String,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _amountError = 'أدخل قيمة صحيحة للتبرع');
      return;
    }
    _showDonationSummary(amount);
  }

  void _showDonationSummary(double amount) {
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
                  Text(
                    'مراجعة التبرع',
                    style: DonorTextStyles.title.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 14),
                  _SummaryRow(
                    label: 'القيمة',
                    value: '${_formatAmount(amount)} د.ل',
                  ),
                  _SummaryRow(
                    label: 'وسيلة الدفع',
                    value: _selectedPaymentMethod,
                  ),
                  const SizedBox(height: 14),
                  DonorPrimaryButton(
                    label: 'تأكيد وإتمام التبرع',
                    icon: Icons.check_circle_outline_rounded,
                    onTap: () {
                      Navigator.pop(context);
                      _confirmDonation(amount);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDonation(double amount) async {
    setState(() => _isProcessing = true);
    final provider = AppProviderScope.of(context);
    if (provider.currentUser.isEmpty) {
      await provider.fetchCurrentUser(notifyLoading: false);
    }
    if (!mounted) return;

    if (amount > 50000) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر تنفيذ العملية لهذه القيمة. يرجى مراجعة قيمة التبرع.',
            style: TextStyle(fontFamily: 'Vazirmatn'),
          ),
        ),
      );
      return;
    }

    final donorName = provider.currentUser['username']?.toString().trim() ?? '';
    if (donorName.isEmpty) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر تحديد بيانات المستخدم لحفظ التبرع.',
            style: TextStyle(fontFamily: 'Vazirmatn'),
          ),
        ),
      );
      return;
    }
    final saved = await provider.submitDonation({
      'donor_name': donorName,
      'item_type': 'تبرع مالي ${_formatAmount(amount)} د.ل',
      'status': 'قيد التنفيذ',
    });
    if (!mounted) return;
    if (!saved) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? 'تعذر حفظ التبرع حاليًا.',
            style: const TextStyle(fontFamily: 'Vazirmatn'),
          ),
        ),
      );
      return;
    }

    setState(() => _isProcessing = false);
    Navigator.pushNamed(
      context,
      '/donation_success',
      arguments: {
        'type': 'تبرع مالي',
        'reference': 'FN-${DateTime.now().millisecondsSinceEpoch}',
        'summary': '${_formatAmount(amount)} د.ل عبر $_selectedPaymentMethod',
      },
    );
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(amount % 1 == 0 ? 0 : 2);
  }
}

class _DonationModeTabs extends StatelessWidget {
  const _DonationModeTabs({
    required this.modes,
    required this.selectedMode,
    required this.onSelected,
  });

  final List<String> modes;
  final String selectedMode;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return DonorCard(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: modes.map((mode) {
          final selected = mode == selectedMode;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: InkWell(
                onTap: () => onSelected(mode),
                borderRadius: DonorRadii.medium,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? _FinancialDonationScreenState._primaryOrange
                        : Colors.transparent,
                    borderRadius: DonorRadii.medium,
                  ),
                  child: Text(
                    mode,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DonorTextStyles.button.copyWith(
                      fontSize: 13,
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
    );
  }
}

class _AmountChoiceButton extends StatelessWidget {
  const _AmountChoiceButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: DonorRadii.medium,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? _FinancialDonationScreenState._primaryOrange
                : Colors.white,
            borderRadius: DonorRadii.medium,
            border: Border.all(
              color: selected
                  ? _FinancialDonationScreenState._primaryOrange
                  : _FinancialDonationScreenState._cardBorder,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DonorTextStyles.button.copyWith(
              fontSize: 14,
              color: selected ? Colors.white : AppColors.textDarkPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.name,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const activeColor = _FinancialDonationScreenState._primaryOrange;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: DonorRadii.medium,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? activeColor.withOpacity(0.08) : Colors.white,
            borderRadius: DonorRadii.medium,
            border: Border.all(
              color: selected
                  ? activeColor
                  : _FinancialDonationScreenState._cardBorder,
              width: selected ? 1.2 : 1,
            ),
          ),
          child: Row(
            children: [
              DonorIconBox(
                icon: icon,
                color: selected ? activeColor : AppColors.textDarkSecondary,
                size: 42,
              ),
              const SizedBox(width: DonorSpacing.md),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DonorTextStyles.sectionTitle.copyWith(
                    fontSize: 14,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
              ),
              const SizedBox(width: DonorSpacing.xs),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected ? activeColor : AppColors.textDarkMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: DonorTextStyles.muted.copyWith(
                color: AppColors.textDarkMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
