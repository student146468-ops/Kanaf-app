import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class ProfileVolunteerView extends StatelessWidget {
  const ProfileVolunteerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          // 1. التدرج الخلفي الأنيق والسينمائي العلوي للملف الشخصي
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 240,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColors.brandOrange,
                    AppColors.brandOrangeDark,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
            ),
          ),

          // 2. محتوى الصفحة المنساب عمودياً
          SafeArea(
            child: Column(
              children: [
                // شريط علوي شفاف وراقٍ لعنوان الصفحة
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'الملف الشخصي للمتطوع',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // بؤرة الصورة الشخصية والاسم مع تأثير البروز والأبعاد العميقة
                        Center(
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0x26000000),
                                            blurRadius: 14,
                                            offset: Offset(0, 6))
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor:
                                          AppColors.brandOrangeLight,
                                      child: const Icon(Icons.person_rounded,
                                          size: 55,
                                          color: AppColors.brandOrange),
                                    ),
                                  ),
                                  // زر تعديل الصورة التفاعلي ثلاثي الأبعاد
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColors.brandOrange
                                                .withOpacity(0.3),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2))
                                      ],
                                      border: Border.all(
                                          color: AppColors.innerBorder),
                                    ),
                                    child: const Icon(Icons.camera_alt_rounded,
                                        color: AppColors.brandOrangeDark,
                                        size: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'أماني أحمد',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal'),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0x26FFFFFF),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'متطوعة برمجية وتقنية 💻',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Tajawal'),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // المجموعة الأولى: روابط الوصول السريع للإنتاجية والجدولة (روابط مباشرة)
                        _buildSectionTitle('وصول سريع ومتابعة 🚀'),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.innerBorder),
                          ),
                          child: Column(
                            children: [
                              _buildProfileRow(
                                icon: Icons.calendar_month_rounded,
                                iconColor: AppColors.brandOrange,
                                iconBg: const Color(0xFFFBE9E7),
                                title: 'جدول مواعيدي التطوعية',
                                subtitle: 'استعراض الحصص القادمة بدار غريان',
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/my_schedule'),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                    height: 1, color: AppColors.innerBorder),
                              ),
                              _buildProfileRow(
                                icon: Icons.history_edu_rounded,
                                iconColor: const Color(0xFF4CAF50),
                                iconBg: const Color(0xFFE8F5E9),
                                title: 'سجل مشاركاتي التاريخي',
                                subtitle: 'لوحة الشرف وساعات العطاء الموثقة',
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/my_volunteer_history'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // المجموعة الثانية: إدارة وتعديل الحساب الشخصي (قواعد بيانات تفاعلية)
                        _buildSectionTitle('إدارة الحساب والأمان ⚙️'),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.innerBorder),
                          ),
                          child: Column(
                            children: [
                              _buildProfileRow(
                                icon: Icons.manage_accounts_rounded,
                                iconColor: const Color(0xFF2196F3),
                                iconBg: const Color(0xFFE3F2FD),
                                title: 'تعديل البيانات الشخصية',
                                subtitle:
                                    'الاسم، رقم الهاتف، والبريد الإلكتروني',
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/settings'),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                    height: 1, color: AppColors.innerBorder),
                              ),
                              _buildProfileRow(
                                icon: Icons.shield_rounded,
                                iconColor: const Color(0xFF673AB7),
                                iconBg: const Color(0xFFEDE7F6),
                                title: 'إعدادات الخصوصية والأمان',
                                subtitle: 'تغيير كلمة المرور وتوثيق الحساب',
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/change_password'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // زر تسجيل الخروج الجذاب والآمن بتأثير اللمس الحديث
                        GestureDetector(
                          onTap: () {
                            // منطق تسجيل الخروج الآمن والعودة لشاشة الاختيار
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'تم تسجيل الخروج الآمن بنجاح، في أمان الله أماني.',
                                    style: TextStyle(fontFamily: 'Tajawal')),
                                backgroundColor: AppColors.brandOrangeDark,
                              ),
                            );
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (route) => false);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(
                                  0x0DE25E14), // لون خروج برتقالي شفاف غاية في الأناقة والتناسق
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColors.brandOrange.withOpacity(0.3),
                                  width: 1.2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.logout_rounded,
                                    color: AppColors.brandOrangeDark, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'تسجيل الخروج الآمن',
                                  style: TextStyle(
                                    color: AppColors.brandOrangeDark,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ويجت مساعد لتنسيق عناوين الأقسام الرئيسية بنقاء بصري مميز
  static Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 10, left: 4),
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.textDarkPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
    );
  }

  // ويجت هندسي متطور لصناعة صفوف الخيارات بأيقونات ذات طبقات وظلال ثلاثية الأبعاد بارزة وعميقة
  static Widget _buildProfileRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // الحاوية ثلاثية الطبقات والظلال لمحاكاة بروز الأيقونة ثلاثية الأبعاد (Modern 3D-Like Container)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(
                        0, 3), // بروز الظل السفلي لإعطاء العمق البصري المحسوس
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.7),
                    blurRadius: 3,
                    offset: const Offset(-1,
                        -1), // إضاءة عكسية علوية تزيد من واقعية وتجسم الأيقونة
                  )
                ],
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            // نصوص الخيارات عالية الدقة والوضوح الفوري للقراءة والمسح
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textDarkPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textDarkMuted,
                      fontSize: 11,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.textDarkMuted, size: 14),
          ],
        ),
      ),
    );
  }
}
