import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class MyScheduleView extends StatefulWidget {
  const MyScheduleView({super.key});

  @override
  State<MyScheduleView> createState() => _MyScheduleViewState();
}

class _MyScheduleViewState extends State<MyScheduleView> {
  int _selectedDayIndex = 2; // الإثنين كبداية نشطة

  final List<Map<String, String>> _weeklyDays = const [
    {'day': 'السبت', 'date': '30'},
    {'day': 'الأحد', 'date': '31'},
    {'day': 'الإثنين', 'date': '01'},
    {'day': 'الثلاثاء', 'date': '02'},
    {'day': 'الأربعاء', 'date': '03'},
    {'day': 'الخميس', 'date': '04'},
  ];

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
          'جدول مواعيدي التطوعية',
          style: TextStyle(color: AppColors.textDarkPrimary, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. شريط التقويم الذكي المحدث
            Container(
              height: 110,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _weeklyDays.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedDayIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDayIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 65,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.brandOrange : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? AppColors.brandOrangeDark : AppColors.innerBorder),
                        boxShadow: isSelected 
                          ? [BoxShadow(color: AppColors.brandOrange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))]
                          : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_weeklyDays[index]['day']!, style: TextStyle(color: isSelected ? Colors.white : AppColors.textDarkMuted, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Tajawal')),
                          const SizedBox(height: 4),
                          Text(_weeklyDays[index]['date']!, style: TextStyle(color: isSelected ? Colors.white : AppColors.textDarkPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 2. القائمة الرئيسية للمواعيد
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                children: [
                  _buildScheduleCard(
                    time: '16:00 - 18:00',
                    title: 'تدريس أساسيات البرمجة ومنطق الحاسوب',
                    location: 'دار رعاية الأيتام المركزية - غريان',
                    statusLabel: 'قادمة اليوم',
                    statusColor: AppColors.brandOrange,
                    icon: Icons.computer_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildScheduleCard(
                    time: '18:15 - 19:15',
                    title: 'ورشة ألعاب ذهنية تفاعلية للأطفال',
                    location: 'قاعة الأنشطة الذكية بدار غريان',
                    statusLabel: 'مجدولة',
                    statusColor: const Color(0xFF2196F3),
                    icon: Icons.lightbulb_outline_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard({
    required String time,
    required String title,
    required String location,
    required String statusLabel,
    required Color statusColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.innerBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time_rounded, color: statusColor, size: 16),
                  const SizedBox(width: 6),
                  Text(time, style: TextStyle(color: statusColor, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(statusLabel, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.scaffoldBackground, borderRadius: BorderRadius.circular(16)),
                child: Icon(icon, color: AppColors.textDarkPrimary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Tajawal', height: 1.4))),
            ],
          ),
          const Divider(height: 30),
          Row(
            children: [
              const Icon(Icons.location_on_rounded, color: AppColors.textDarkMuted, size: 16),
              const SizedBox(width: 6),
              Expanded(child: Text(location, style: const TextStyle(color: AppColors.textDarkSecondary, fontSize: 12, fontFamily: 'Tajawal'))),
            ],
          ),
        ],
      ),
    );
  }
}