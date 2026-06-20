import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class DonationSuccessScreen extends StatelessWidget {
  const DonationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // أيقونة النجاح المتوهجة بهوية كنف
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: const BoxDecoration(
                    color: AppColors.brandOrangeLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.volunteer_activism_rounded,
                    size: 80,
                    color: AppColors.brandOrange,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'تُقْبَل صدقتكم وتُجبر قلوبهم! ✨',
                  textAlign: TextAlign.center, // تم الإصلاح هنا ليكون النوع TextAlign وليس Alignment
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'شكراً لك يا باغي الخير، تم تسجيل تبرعك الكريم بنجاح في منظومة كَنَفْ وجاري توجيهه مباشرةً لسد احتياج أطفالنا في دار رعاية الأيتام بغريان.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    color: AppColors.textDarkSecondary,
                    height: 1.6,
                  ),
                ),
                const Spacer(),
                // أزرار التحكم والتنقل المودرن
                Container(
                  height: 52,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: AppColors.orangeGradient),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      // 💎 أ) العودة للرئيسية وتفريغ الطوابق السابقة لأمان التطبيق
                      Navigator.pushNamedAndRemoveUntil(context, '/supporter_home', (route) => false);
                    },
                    child: const Text(
                      'العودة للرئيسية',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // زر عرض سجل تبرعاتي المودرن
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size.fromHeight(52),
                    side: const BorderSide(color: AppColors.innerBorder, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    // 💎 ب) الانتقال لسجل التبرعات التاريخي الخاص بالداعم
                    Navigator.pushNamed(context, '/donation_history');
                  },
                  child: const Text(
                    'عرض سجل تبرعاتي',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDarkSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}