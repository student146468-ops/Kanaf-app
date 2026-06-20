import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          title: const Text(
            'عن تطبيق كَنَفْ',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🌌 شعار التطبيق المودرن مع خلفية مضيئة متوهجة تبرز الهوية البصرية
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.brandOrange.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppColors.brandOrange.withOpacity(0.3), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.brandOrange.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '🤝',
                          style: TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'كَــنَـــفْ',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'لرعاية أيتام غريان والمؤسسات التابعة لها',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 📝 البطاقة الزجاجية الأولى: الرؤية والرسالة
              _buildSectionTitle('✨ رؤيتنا ورسالتنا الإنسانية'),
              _buildGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تطبيق "كَنَفْ" هو منصة تقنية برمجية متكاملة تهدف إلى سد الفجوة اللوجستية بين دور رعاية الأيتام، والمتبرعين، والمتطوعين في مدينة غريان. نسعى جاهدين لتحقيق أعلى مستويات الشفافية والموثوقية من خلال تمكين دور الرعاية من إدراج احتياجاتهم الفعلية ومتابعة مسار كفالتها وتوصيلها رقمياً بالكامل وبكل كرامة.',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 🎯 البطاقة الزجاجية الثانية: أهداف المنصة اللوجستية
              _buildSectionTitle('🎯 أهداف المنصة الرئيسية'),
              _buildGlassCard(
                child: Column(
                  children: [
                    _buildBulletPoint('⚡ رصد وحصر الاحتياجات العينية والمالية لدور الرعاية بشكل دقيق ومحدث فوراً.'),
                    _buildDivider(),
                    _buildBulletPoint('🦾 تسهيل وصول المتبرعين للحملات النشطة والموثوقة داخل نطاق البلدية الجغرافي.'),
                    _buildDivider(),
                    _buildBulletPoint('🗓️ تنظيم الفرص التطوعية وإصدار الشهادات المعتمدة رقمياً للمشتركين للتشجيع والتحفيز.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 📞 البطاقة الزجاجية الثالثة: قنوات التواصل والموقع الجغرافي
              _buildSectionTitle('📱 تواصل معنا مباشرة'),
              _buildGlassCard(
                child: Column(
                  children: [
                    _buildContactTile(
                      icon: Icons.location_on_rounded,
                      title: 'الموقع الرئيسي للمشروع',
                      subtitle: 'ليبيا - مدينة غريان',
                      iconColor: AppColors.brandOrange,
                    ),
                    _buildDivider(),
                    _buildContactTile(
                      icon: Icons.email_rounded,
                      title: 'البريد الإلكتروني الرسمي',
                      subtitle: 'support@kanaf.ly',
                      iconColor: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // الشعار الحقوقي والإصدار البرمجي النهائي لتأكيد الجاهزية المطلقة
              const Text(
                'تم التطوير بكل فخر وبمعايير جودة برمجية عالمية لعام 2026',
                style: TextStyle(fontFamily: 'Cairo', color: Colors.white24, fontSize: 11),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                'الإصدار النهائي المستقر v1.0.0',
                style: TextStyle(fontFamily: 'Cairo', color: AppColors.brandOrange, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجيت مساعد لبناء عنوان القسم الفرعي
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12, right: 4),
        child: Text(
          title,
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 15),
        ),
      ),
    );
  }

  // ويدجيت الكروت الكريستالية الزجاجية المتناسقة مع طابع التطبيق
  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06), width: 1.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }

  // أسطر قائمة الأهداف بنمط مريح للعين يمنع تشتت القراء
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, left: 10),
            child: Icon(Icons.circle, size: 6, color: AppColors.brandOrange),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: Colors.white.withOpacity(0.75), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // أسطر قائمة قنوات التواصل
  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withOpacity(0.4), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.white.withOpacity(0.05), thickness: 1, height: 16);
  }
}