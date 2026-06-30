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
    {'name': 'إدفع لي', 'icon': Icons.account_balance_wallet_outlined},
    {'name': 'بطاقة مصرفية', 'icon': Icons.payments_outlined},
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
                            const _HeaderNote(),
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
                      donorMobileBottomBar(
                        height: 84,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                top: BorderSide(color: AppColors.innerBorder)),
                          ),
                          child: DonorPrimaryButton(
                            label: _isProcessing
                                ? 'جاري التأكيد...'
                                : 'مراجعة التبرع',
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
          ],
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
            const Icon(Icons.savings_outlined, color: AppColors.brandOrange),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        enabledBorder: _border(AppColors.innerBorder),
        focusedBorder: _border(AppColors.brandOrange),
        errorBorder: _border(AppColors.errorRed),
        focusedErrorBorder: _border(AppColors.errorRed),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: 1.2),
    );
  }

  Widget _buildQuickAmounts() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _quickAmounts.map((amount) {
        final selected = _selectedQuickAmount == amount;
        return ChoiceChip(
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            child: Text('$amount د.ل'),
          ),
          selected: selected,
          showCheckmark: false,
          selectedColor: AppColors.brandOrange,
          backgroundColor: Colors.white,
          side: BorderSide(
              color: selected ? AppColors.brandOrange : AppColors.innerBorder),
          labelStyle: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w900,
            fontSize: 13.5,
            color: selected ? Colors.white : AppColors.textDarkSecondary,
          ),
          onSelected: (_) {
            setState(() {
              _selectedQuickAmount = amount;
              _amountController.text = amount;
              _amountError = null;
            });
          },
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
          child: DonorCard(
            padding: const EdgeInsets.all(14),
            color: selected
                ? AppColors.brandOrangeLight.withOpacity(0.34)
                : Colors.white,
            onTap: () => setState(
                () => _selectedPaymentMethod = method['name'] as String),
            child: Row(
              children: [
                DonorIconBox(
                  icon: method['icon'] as IconData,
                  color: selected
                      ? AppColors.brandOrange
                      : AppColors.textDarkSecondary,
                  size: 42,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    method['name'] as String,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
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
  const _HeaderNote();

  @override
  Widget build(BuildContext context) {
    return const DonorCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, color: AppColors.skyBlueDark),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'اختر قيمة مناسبة، وسيتم تسجيل مساهمتك وربطها بالاحتياج المحدد.',
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
        fontWeight: FontWeight.w900,
        color: AppColors.textDarkPrimary,
      ),
    );
  }
}
