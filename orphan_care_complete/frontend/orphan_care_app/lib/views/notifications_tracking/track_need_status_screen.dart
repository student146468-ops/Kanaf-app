import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class TrackNeedStatusScreen extends StatelessWidget {
  const TrackNeedStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> trackingSteps = [
      {'title': 'تم استلام التبرع بنجاح', 'subtitle': 'تم توثيق القيمة المالية بالمنظومة الإلكترونية للدار.', 'date': '01 يونيو 2026 - 10:30 ص', 'isCompleted': true, 'isActive': false},
      {'title': 'شراء وتجهيز المواد', 'subtitle': 'توفير الكسوة الشتوية والأغطية المطلوبة من الموردين.', 'date': '02 يونيو 2026 - 04:15 م', 'isCompleted': true, 'isActive': false},
      {'title': 'الفرز والتغليف الكريستالي', 'subtitle': 'تجهيز الصناديق وتسميتها وفق الفئات العمرية للأطفال.', 'date': '03 يونيو 2026 - 09:00 ص', 'isCompleted': true, 'isActive': true},
      {'title': 'شحن وتوصيل الطلبية', 'subtitle': 'انطلاق سيارات الدعم متوجهة لبلدية غريان لتسليم الأمانات.', 'date': 'جاري العمل عليها', 'isCompleted': false, 'isActive': false},
      {'title': 'التسليم ليد الأطفال والتوثيق', 'subtitle': 'إتمام التوزيع وإرسال تقرير الإغلاق المعتمد للمتبرعين.', 'date': 'مرحلة مستقبلية', 'isCompleted': false, 'isActive': false},
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('تتبع حالة الاحتياج', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // كرت تعريفي علوي بالطلب
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📦 رقم التتبع الهوياتي: #KNF-9921', style: TextStyle(fontFamily: 'Cairo', color: AppColors.brandOrange, fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    const Text('تأمين كسوة شتوية وأغطية دافئة لـ 25 طفلاً', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    Row(
                      // تم إزالة كلمة const من هنا وتعديل اللون بالسطر الأسفل ليصبح متوافقاً ومعيارياً
                      children: [
                        const Icon(Icons.location_on_rounded, color: Colors.white54, size: 16),
                        const SizedBox(width: 4),
                        Text('الجهة المستفيدة: جمعية دار الأيتام بغريان', style: const TextStyle(fontFamily: 'Cairo', color: Colors.white60, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text('مسار التقدم الميداني', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 20),
              
              // الـ Stepper المطور يدوياً لضمان الفخامة البصرية
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: trackingSteps.length,
                itemBuilder: (context, index) {
                  final step = trackingSteps[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // خط التتبع والأيقونات
                      Column(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: step['isActive']
                                  ? AppColors.brandOrange
                                  : (step['isCompleted'] ? const Color(0xFF0F9D58) : const Color(0xFF2C2C2C)),
                              shape: BoxShape.circle,
                              boxShadow: step['isActive']
                                  ? [BoxShadow(color: AppColors.brandOrange.withOpacity(0.4), blurRadius: 10, spreadRadius: 2)]
                                  : [],
                            ),
                            child: Icon(
                              step['isCompleted'] ? Icons.check_rounded : Icons.radio_button_checked_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          if (index != trackingSteps.length - 1)
                            Container(
                              width: 3,
                              height: 60,
                              color: step['isCompleted'] ? const Color(0xFF0F9D58) : const Color(0xFF2C2C2C),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // تفاصيل الخطوة اللوجستية
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step['title'],
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: step['isActive'] ? AppColors.brandOrange : (step['isCompleted'] ? Colors.white : Colors.white38),
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                step['subtitle'],
                                style: TextStyle(fontFamily: 'Cairo', color: step['isCompleted'] ? Colors.white70 : Colors.white30, fontSize: 13, height: 1.4),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                step['date'],
                                style: TextStyle(fontFamily: 'Cairo', color: step['isActive'] ? AppColors.brandOrange.withOpacity(0.7) : Colors.white38, fontSize: 11),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
