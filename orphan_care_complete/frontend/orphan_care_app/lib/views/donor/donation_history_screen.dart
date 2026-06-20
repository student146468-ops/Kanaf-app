import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class DonationHistoryScreen extends StatelessWidget {
  const DonationHistoryScreen({super.key});

  // بيانات افتراضية احترافية تحاكي الواقع بالكامل
  final List<Map<String, dynamic>> _historyData = const [
    {'type': 'مالي', 'amount': '150 د.ل', 'target': 'كفالة تعليمية - غريان', 'date': '2026/05/20', 'isCompleted': true},
    {'type': 'عيني', 'amount': 'سلة تموينية متكاملة', 'target': 'مطبخ دار الأيتام', 'date': '2026/05/12', 'isCompleted': true},
    {'type': 'مالي', 'amount': '50 د.ل', 'target': 'كسوة العيد للأطفال', 'date': '2026/04/28', 'isCompleted': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('سجل مساهماتي', style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDarkPrimary)),
        ),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          itemCount: _historyData.length,
          itemBuilder: (context, index) {
            final donation = _historyData[index];
            final bool isFinancial = donation['type'] == 'مالي';

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.innerBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isFinancial ? const Color(0xFFFDF0EA) : const Color(0xFFEAF5EE),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFinancial ? Icons.account_balance_wallet_rounded : Icons.local_shipping_rounded,
                      color: isFinancial ? AppColors.brandOrange : const Color(0xFF2E6F40),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(donation['amount'], style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDarkPrimary)),
                        const SizedBox(height: 2),
                        Text(donation['target'], style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.textDarkSecondary)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(donation['date'], style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textDarkMuted)),
                      const SizedBox(height: 6),
                      Text(
                        donation['isCompleted'] ? 'مكتمل' : 'قيد التوصيل',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: donation['isCompleted'] ? const Color(0xFF2E6F40) : AppColors.brandOrange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}