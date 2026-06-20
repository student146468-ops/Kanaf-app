import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'apply_opportunity_view.dart'; // الربط المباشر مع الواجهة رقم 20

class VolunteerOpportunityDetailsView extends StatelessWidget {
  const VolunteerOpportunityDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          // 1. الخلفية السينمائية العلوية (تدرج دافئ يعوض الصورة ويعطي فخامة وهوية بصرية مستقرة)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.brandOrange,
                    AppColors.brandOrangeDark,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // لمسة فنية دافئة لمحاكاة الإضاءة السينمائية
                  Positioned(
                    right: -50,
                    top: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                        color: Color(0x1AE25E14),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. المحتوى التفصيلي المنساب فوق الخلفية
          SafeArea(
            child: Column(
              children: [
                // شريط علوي شفاف مريح للتنقل والرجوع
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.glassBgNormal,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.glassBorderNormal),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                      const Text(
                        'تفاصيل الفرصة التطوعية',
                        style: TextStyle(
                          color: AppColors.glassTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(width: 44), // لموازنة السهم في الطرف الآخر هندسياً
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 120, left: 20, right: 20, bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        // كرت العنوان الرئيسي والجهة الحاضنة (Solid & Sharp)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.innerBorder),
                            boxShadow: const [
                              BoxShadow(color: AppColors.innerShadow, blurRadius: 15, offset: Offset(0, 8))
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.brandOrangeLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'تعليم وتطوير',
                                  style: TextStyle(color: AppColors.brandOrange, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'تدريس أساسيات الحاسوب والبرمجة للأيتام',
                                style: TextStyle(color: AppColors.textDarkPrimary, fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: const [
                                  Icon(Icons.location_on_outlined, color: AppColors.brandOrange, size: 18),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'دار رعاية الأيتام المركزية - غريان، ليبيا',
                                      style: TextStyle(color: AppColors.textDarkSecondary, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),

                        // كرت الوقت والدقيق والجدولة (المحددات الزمنية)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.innerBorder),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildInfoTimeline(Icons.calendar_today_rounded, 'الأيام', 'السبت والإثنين'),
                              Container(width: 1, height: 40, color: AppColors.innerBorder),
                              _buildInfoTimeline(Icons.access_time_rounded, 'الوقت', '16:00 - 18:00'),
                              Container(width: 1, height: 40, color: AppColors.innerBorder),
                              _buildInfoTimeline(Icons.hourglass_top_rounded, 'المدة', '4 ساعات / أسبوع'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // قسم المهام المطلوبة (شرح تتابعي عالي القراءة والنقاء)
                        const Text(
                          '📋 المهام والمسؤوليات المطلوبة:',
                          style: TextStyle(color: AppColors.textDarkPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        _buildBulletPoint('شرح المبادئ الأساسية لأنظمة التشغيل وملفات الحاسوب للأطفال.'),
                        _buildBulletPoint('تقديم مقدمة مبسطة وممتعة ومحفزة عن المنطق البرمجي وكيف تفكر الآلة.'),
                        _buildBulletPoint('متابعة التطبيقات العملية للأطفال داخل معمل الحاسوب الخاص بالدار وتوجيههم.'),

                        const SizedBox(height: 24),

                        // قسم الشروط والمؤهلات (لضمان كفاءة التجربة الإنسانية)
                        const Text(
                          '⚡ الشروط والمؤهلات:',
                          style: TextStyle(color: AppColors.textDarkPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        _buildBulletPoint('أن يكون المتقدم طالباً أو خريجاً في تخصص هندسة البرمجيات أو تقنية المعلومات.'),
                        _buildBulletPoint('القدرة العالية على تبسيط المعلومات والتعامل الصبور والراقي مع فئة الأطفال الأيتام.'),
                        _buildBulletPoint('الالتزام التام بالمواعيد المحددة بالتنسيق مع المشرفين في مدينة غريان.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. شريط التقديم السفلي العائم والمثبت بلمسة فخمة جداً (Interactive Bottom Bar)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(28), topLeft: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(color: AppColors.innerShadow, blurRadius: 20, offset: Offset(0, -4))
                ],
              ),
              child: Row(
                children: [
                  // كرت المقاعد المتبقية السريع
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('المقاعد المتاحة', style: TextStyle(color: AppColors.textDarkMuted, fontSize: 12)),
                      SizedBox(height: 4),
                      Text('2 متطوعين فقط', style: TextStyle(color: Colors.redAccent, fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(width: 24),
                  // الزر المتوهج الرئيسي للانتقال الفوري للواجهة رقم 20
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandOrange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        shadowColor: AppColors.brandOrange.withOpacity(0.3),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ApplyOpportunityView()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('تقديم طلب تطوع الآن', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // الـ Widgets المساعدة لبناء عناصر الصفحة بدقة واحترافية قابلة لإعادة الاستخدام داخل الشاشة
  static Widget _buildInfoTimeline(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.brandOrange, size: 20),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: AppColors.textDarkMuted, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: AppColors.textDarkPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  static Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, left: 8, right: 4),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(color: AppColors.brandOrange, shape: BoxShape.circle),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.textDarkSecondary, fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}