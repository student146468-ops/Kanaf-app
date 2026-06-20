import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class FinancialDonationScreen extends StatefulWidget {
  const FinancialDonationScreen({super.key});

  @override
  State<FinancialDonationScreen> createState() => _FinancialDonationScreenState();
}

class _FinancialDonationScreenState extends State<FinancialDonationScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedQuickAmount = '';
  String _selectedPaymentMethod = 'سداد';

  final List<String> _quickAmounts = ['20', '50', '100', '200', '500'];
  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'سداد', 'icon': Icons.phonelink_setup_rounded},
    {'name': 'تداول', 'icon': Icons.credit_card_rounded},
    {'name': 'إدفع لي', 'icon': Icons.account_balance_wallet_rounded},
    {'name': 'بطاقة مصرفية', 'icon': Icons.payment_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDarkPrimary, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('تبرع مالي آمن', style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDarkPrimary)),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('أدخل قيمة التبرع (دينار ليبي):', style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDarkSecondary)),
                    const SizedBox(height: 12),
                    _buildAmountInputField(),
                    const SizedBox(height: 16),
                    _buildQuickAmountBar(),
                    const SizedBox(height: 28),
                    const Text('اختر وسيلة الدفع الإلكتروني:', style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDarkSecondary)),
                    const SizedBox(height: 12),
                    _buildPaymentMethodsList(),
                  ],
                ),
              ),
            ),
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInputField() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      onChanged: (val) => setState(() => _selectedQuickAmount = ''),
      textAlign: TextAlign.center,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.brandOrangeDark),
      decoration: InputDecoration(
        hintText: '0.00 د.ل',
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        filled: true,
        fillColor: AppColors.scaffoldBackground,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.innerBorder, width: 1.2)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.brandOrange, width: 1.5)),
      ),
    );
  }

  Widget _buildQuickAmountBar() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _quickAmounts.length,
        itemBuilder: (context, index) {
          final amt = _quickAmounts[index];
          final bool isSelected = _selectedQuickAmount == amt;
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedQuickAmount = amt;
                  _amountController.text = amt;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.brandOrange : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSelected ? AppColors.brandOrange : AppColors.innerBorder, width: 1.2),
                ),
                child: Center(
                  child: Text(
                    '+$amt د.ل',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textDarkSecondary),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentMethodsList() {
    return Column(
      children: _paymentMethods.map((method) {
        final bool isSelected = _selectedPaymentMethod == method['name'];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? AppColors.brandOrange : AppColors.innerBorder, width: isSelected ? 1.5 : 1.2),
          ),
          child: ListTile(
            onTap: () => setState(() => _selectedPaymentMethod = method['name']),
            leading: Icon(method['icon'], color: isSelected ? AppColors.brandOrange : AppColors.textDarkSecondary),
            title: Text(method['name'], style: TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, color: AppColors.textDarkPrimary)),
            trailing: Radio<String>(
              value: method['name'],
              groupValue: _selectedPaymentMethod,
              activeColor: AppColors.brandOrange,
              onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPayButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.innerBorder))),
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(gradient: const LinearGradient(colors: AppColors.orangeGradient), borderRadius: BorderRadius.circular(16)),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          onPressed: () {
            // 💎 تم الربط هنا لفتح شاشة النجاح السينمائية وشكر المتبرع
            Navigator.pushNamed(context, '/donation_success');
          },
          child: const Text('تأكيد وإتمام التبرع المالي', style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }
}