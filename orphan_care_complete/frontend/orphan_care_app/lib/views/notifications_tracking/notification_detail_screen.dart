import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_container.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استقبال البيانات الممررة ديناميكياً لتجنب الأخطاء البرمجية الهيكلية
    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {
      'title': 'تحديث بخصوص الحملة',
      'body': 'لم يتم العثور على تفاصيل المحتوى، الرجاء الرجوع والمحاولة مجدداً.',
      'time': 'الآن',
      'icon': '🔔',
      'type': 'all'
    };

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
          title: const Text('تفاصيل الإشعار', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الحاوية الزجاجية الكريستالية للمحتوى
                GlassContainer(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.brandOrangeDark.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.brandOrange.withOpacity(0.3), width: 1.5),
                        ),
                        child: Center(
                          child: Text(args['icon'], style: const TextStyle(fontSize: 40)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        args['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        args['time'],
                        style: const TextStyle(fontFamily: 'Cairo', color: AppColors.brandOrange, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(height: 20),
                      Divider(color: Colors.white.withOpacity(0.15), thickness: 1),
                      const SizedBox(height: 20),
                      Text(
                        args['body'],
                        textAlign: TextAlign.center,
                        // تم التعديل هنا لإزالة المعرّف الخاطئ وجعل درجة الشفافية مدعومة ومعيارية
                        style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withOpacity(0.9), fontSize: 15, height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                
                // زر تفاعلي فخم مبهر للتنقل الفوري لربط العمليات
                if (args['type'] == 'track' || args['type'] == 'donation')
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/track_need_status');
                    },
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        color: AppColors.glassBtnActive,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.brandOrangeDark.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'تتبع خطوة بخطوة الآن 🚚',
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.brandOrangeDark),
                        ),
                      ),
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
