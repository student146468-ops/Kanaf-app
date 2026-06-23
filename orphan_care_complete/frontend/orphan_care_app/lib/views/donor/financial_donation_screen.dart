import 'package:flutter/material.dart';

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
  String _selectedPaymentMethod = 'سداد';
  String? _amountError;
  bool _isProcessing = false;

  final List<String> _quickAmounts = const ['20', '50', '100', '200', '500'];
  final List<Map<String, dynamic>> _paymentMethods = const [
    {'name': 'سداد', 'icon': Icons.phone_iphone_rounded},
    {'name': 'تداول', 'icon': Icons.credit_card_rounded},
    {'name': 'إدفع لي', 'icon': Icons.account_balance_wallet_rounded},
    {'name': 'بطاقة مصرفية', 'icon': Icons.payments_rounded},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: donorMobileAppBar(
          title: 'تبرع مالي آمن',
          leading: IconButton(
            tooltip: 'رجوع',
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textDarkPrimary, size: 18),
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
                        _HeaderNote(),
                        const SizedBox(height: 18),
                        const _SectionTitle('قيمة التبرع'),
                        const SizedBox(height: 10),
                        _buildAmountField(),
                        const SizedBox(height: 12),
                        _buildQuickAmounts(),
                        const SizedBox(height: 24),
                        const _SectionTitle('وسيلة الدفع'),
                        const SizedBox(height: 10),
                        _buildPaymentMethods(),
                      ],
                    ),
                  ),
                  _buildPayButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      onChanged: (_) {
        setState(() {
          _selectedQuickAmount = '';
          _amountError = null;
        });
      },
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: AppColors.brandOrangeDark,
      ),
      decoration: InputDecoration(
        hintText: '0 د.ل',
        errorText: _amountError,
        errorStyle: const TextStyle(fontFamily: 'Tajawal'),
        suffixIcon:
            const Icon(Icons.savings_rounded, color: AppColors.brandOrange),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.innerBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide:
              const BorderSide(color: AppColors.brandOrange, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
      ),
    );
  }

  Widget _buildQuickAmounts() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _quickAmounts.map((amount) {
        final selected = _selectedQuickAmount == amount;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.brandOrange.withOpacity(0.18),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: ChoiceChip(
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              child: Text('$amount د.ل'),
            ),
            selected: selected,
            showCheckmark: false,
            selectedColor: AppColors.brandOrangeDark,
            backgroundColor: Colors.white,
            side: BorderSide(
              color:
                  selected ? AppColors.brandOrangeDark : AppColors.innerBorder,
              width: selected ? 1.4 : 1,
            ),
            labelStyle: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w900,
              fontSize: 13.5,
              color: selected ? Colors.white : const Color(0xFF526577),
            ),
            onSelected: (_) {
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
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: _paymentMethods.map((method) {
        final selected = _selectedPaymentMethod == method['name'];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => setState(
                  () => _selectedPaymentMethod = method['name'] as String),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selected
                        ? AppColors.brandOrange
                        : AppColors.innerBorder,
                    width: selected ? 1.8 : 1,
                  ),
                  color: selected
                      ? AppColors.brandOrangeLight.withOpacity(0.35)
                      : Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.brandOrangeLight
                            : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        method['icon'] as IconData,
                        color: selected
                            ? AppColors.brandOrangeDark
                            : AppColors.textDarkSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        method['name'] as String,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDarkPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      selected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: selected
                          ? AppColors.brandOrangeDark
                          : AppColors.textDarkMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPayButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.innerBorder)),
      ),
      child: FilledButton.icon(
        onPressed: _isProcessing ? null : _submit,
        icon: _isProcessing
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.lock_rounded, size: 18),
        label: Text(_isProcessing ? 'جاري التأكيد...' : 'مراجعة التبرع'),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          backgroundColor: AppColors.brandOrange,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
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
                  const Text(
                    'مراجعة التبرع',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDarkPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _SummaryRow(
                      label: 'القيمة', value: '${_formatAmount(amount)} د.ل'),
                  _SummaryRow(
                      label: 'وسيلة الدفع', value: _selectedPaymentMethod),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmDonation(amount);
                    },
                    icon: const Icon(Icons.check_circle_rounded, size: 18),
                    label: const Text('تأكيد وإتمام التبرع'),
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
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
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
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    if (amount > 50000) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر تنفيذ العملية لهذه القيمة. يرجى مراجعة قيمة التبرع.',
            style: TextStyle(fontFamily: 'Tajawal'),
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

class _HeaderNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.innerBorder),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_rounded, color: AppColors.skyBlueDark),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'اختر قيمة مناسبة، وسيتم تسجيل مساهمتك وربطها بالحالة الإنسانية المحددة.',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                height: 1.5,
                color: AppColors.textDarkSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppColors.textDarkPrimary,
      ),
    );
  }
}
