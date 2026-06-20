import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class MyVolunteerHistoryView extends StatelessWidget {
  const MyVolunteerHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDarkPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'سجل مشاركاتي التاريخي',
          style: TextStyle(color: AppColors.textDarkPrimary, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. لوحة الشرف والإنجازات (Glassmorphism inspired)
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.brandOrange, AppColors.brandOrangeDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: AppColors.brandOrange.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                        child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('لوحة الشرف التطوعية', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                          Text('عطاؤكِ يصنع الفارق للأيتام', style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Tajawal')),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('32 س', 'إجمالي الساعات'),
                      _buildStat('4', 'فرص مكتملة'),
                      _buildStat('مستوى 3', 'وسام العطاء'),
                    ],
                  ),
                ],
              ),
            ),

            // 2. سجل المشاركات
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  _buildHistoryCard(
                    title: 'دورة مفاهيم البرمجة المرئية',
                    location: 'دار رعاية الأيتام - غريان',
                    date: 'أبريل 2026',
                    hours: '18 ساعة',
                  ),
                  const SizedBox(height: 16),
                  _buildHistoryCard(
                    title: 'تهيئة مختبر الحاسوب وتقنية المعلومات',
                    location: 'قاعة التقنية - غريان',
                    date: 'فبراير 2026',
                    hours: '10 ساعات',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'Tajawal')),
      ],
    );
  }

  Widget _buildHistoryCard({required String title, required String location, required String date, required String hours}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.innerBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.brandOrangeLight, borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.history_edu_rounded, color: AppColors.brandOrangeDark),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                    Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Tajawal')),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Text('$hours مكتملة', style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}