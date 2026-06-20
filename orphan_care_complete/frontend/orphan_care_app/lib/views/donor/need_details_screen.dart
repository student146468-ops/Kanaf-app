import 'package:flutter/material.dart';
import '../../utils/app_colors.dart'; // تأكدي من صحة المسار لملف الألوان الخاص بكِ

class NeedDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> needData;

  const NeedDetailsScreen({super.key, required this.needData});

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
          title: const Text(
            'تفاصيل الاحتياج الإنساني',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDarkPrimary),
          ),
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
                    // بطاقة الجهة الطالبة للاحتياج بتصميم مودرن
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.innerBorder),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(color: Color(0xFFFDF0EA), shape: BoxShape.circle),
                            child: const Icon(Icons.home_work_rounded, color: AppColors.brandOrange, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  needData['orphanage'],
                                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDarkPrimary),
                                ),
                                const Text(
                                  'جهة موثوقة ومسجلة in منظومة كَنَفْ',
                                  style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textDarkMuted),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textDarkMuted.withOpacity(0.5)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // عنوان تفاصيل الاحتياج والقصة الإنسانية خلفه
                    Text(
                      needData['title'],
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDarkPrimary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'تفاصيل وقصة الاحتياج:',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDarkSecondary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'يهدف هذا النداء الإنساني إلى سد النقص وتغطية الاحتياجات الأساسية لضمان استقرار الأطفال النفسي والدراسي داخل الدار. مساهمتكم الكريمة تضمن بقاء هؤلاء الأطفال في بيئة تعليمية آمنة ومتكافئة تمنحهم الأمل والفرص لبناء مستقبلهم المشرق بكل كرامة.',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13.5,
                        color: AppColors.textDarkSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // كارت مؤشرات الدعم المالي والتقدم الحالي الحقيقي
                    _buildMetricsCard(),
                  ],
                ),
              ),
            ),
            // بار الأزرار التفاعلية الممتد في الأسفل
            _buildActionBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        border: Border.all(color: AppColors.innerBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('تم جمع', style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textDarkMuted)),
                  Text(needData['raised'], style: const TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.brandOrangeDark)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('المبلغ المستهدف', style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textDarkMuted)),
                  Text(needData['target'], style: const TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDarkPrimary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: needData['progress'],
            backgroundColor: AppColors.innerBorder,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brandOrange),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.hourglass_bottom_rounded, size: 14, color: AppColors.brandOrange),
              const SizedBox(width: 4),
              Text(
                'الزمن المتبقي لإغلاق الحالة: ${needData['daysLeft']}',
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textDarkSecondary),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.innerBorder)),
      ),
      child: Row(
        children: [
          // زر تبرع مالي سريع ممتد ومتوهج
          Expanded(
            child: Container(
              height: 52,
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
                  // 💎 أ) ربط الزر للانتقال لواجهة التبرع المالي الآمن
                  Navigator.pushNamed(context, '/financial_donation');
                },
                child: const Text(
                  'تبرع مالي سريع',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // زر تبرع عيني ذكي بلون مختلف للتمييز البصري المريح
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: const Size.fromHeight(52), // الارتفاع الصحيح هندسياً لمنع خطأ الـ Compiler
                side: const BorderSide(color: Color(0xFF2E6F40), width: 1.5), // لون زيتي دافئ للجانب العيني
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                // 💎 ب) ربط الزر للانتقال لواجهة اختيار نوع التبرع العيني
                Navigator.pushNamed(context, '/inkind_donation');
              },
              child: const Text(
                'تقديم تبرع عيني',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2E6F40)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}