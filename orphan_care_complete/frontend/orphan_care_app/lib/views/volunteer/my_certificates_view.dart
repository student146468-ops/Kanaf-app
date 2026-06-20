import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class MyCertificatesView extends StatelessWidget {
  const MyCertificatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.innerBorder),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDarkPrimary, size: 16),
          ),
        ),
        title: const Text(
          'شهادات التقدير المعتمدة',
          style: TextStyle(color: AppColors.textDarkPrimary, fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.brandOrange, AppColors.brandOrangeDark]),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: AppColors.brandOrange.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('وثقّي إنجازاتكِ الإنسانية', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                        SizedBox(height: 4),
                        Text('كل ساعة عطاء توثق هنا بشهادة معتمدة.', style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Tajawal')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildCertificateCard(context, 'شهادة تميز في التدريب البرمجي', 'إدارة دار رعاية الأيتام - غريان', '28 أبريل 2026', '18 ساعة'),
                  const SizedBox(height: 16),
                  _buildCertificateCard(context, 'شهادة شكر لتطوير البنية التحتية', 'قاعة التقنية - غريان', '20 فبراير 2026', '10 ساعات'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificateCard(BuildContext context, String title, String issuer, String date, String hours) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.innerBorder),
        // تم استبدال 'Colors.black05' التي كانت تسبب الخطأ بـ 'Colors.black.withOpacity(0.05)'
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.brandOrangeLight, borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.brandOrangeDark),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                    Text(issuer, style: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Tajawal')),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandOrangeLight,
                  foregroundColor: AppColors.brandOrangeDark,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text('تحميل', style: TextStyle(fontFamily: 'Tajawal')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}