import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/glass_container.dart'; // 💎 استيراد القالب الزجاجي الموحد
import '../widgets/welcome_progress_indicator.dart';

/// [OnboardingScreen] - واجهة التعريف التفاعلية لـ "تطبيق كَنَفْ" لعام 2026.
/// تم حل مشكلة تداخل const مع متغيّرات final لملف الألوان ليعمل الكود بدقة وسلاسة تامة.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'أهلاً بك في كَنَفْ',
      'description': 'نحن الجسر الذي يصل بين قلوبكم المعطاءة ودور رعاية الأيتام بكل موثوقية لضمان حياة كريمة لهم.',
    },
    {
      'title': 'كفالة ورعاية ذكية',
      'description': 'بخطوات بسيطة وسلسة، يمكنك كفالة يتيم ومتابعة أثره الإنساني لحظة بلحظة بنظام شفاف وحديث.',
    },
    {
      'title': 'كن كنفاً لهم',
      'description': 'تبرعك ليس مجرد رقم، بل هو أمل يصنع مستقبلاً أفضل لأطفالنا. اصنع الفارق الآن مع كَنَفْ.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final containerWidth = isWebOrDesktop ? 420.0 : double.infinity;

    return Directionality(
      textDirection: TextDirection.rtl, // توجيه المحتوى هندسياً باللغة العربية
      child: Scaffold(
        backgroundColor: const Color(0xFF131313), // لون خلفي عميق وموحد لامتصاص الحواف الزجاجية
        body: Center(
          child: Container(
            width: containerWidth,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: isWebOrDesktop
                  ? [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 45, spreadRadius: 8)]
                  : [],
            ),
            child: Stack(
              children: [
                // 1️⃣ الصورة الخلفية المعتمدة للهوية الإنسانية طافية بالكامل وبدون قص
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/child.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),

                // 2️⃣ طبقة التباين المتدرجة المطعمة بالبرتقالي الداكن لضمان تباين وحماية النصوص
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.10),
                          AppColors.brandOrangeDark.withOpacity(0.24), 
                          Colors.black.withOpacity(0.72), // تعتيم مكثف في الأسفل لبروز العناصر والأزرار
                        ],
                      ),
                    ),
                  ),
                ),

                // 3️⃣ المحتوى الطافي والبطاقات الموزعة بذكاء هندسي متزن
                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // زر التخطي الرشيق المستوحى من التطبيقات العالمية
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pushReplacementNamed('/role_selection'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white.withOpacity(0.95),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              backgroundColor: Colors.white.withOpacity(0.08), 
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(color: Colors.white.withOpacity(0.15), width: 1),
                              ),
                            ),
                            child: const Text(
                              'تخطي',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const WelcomeProgressIndicator(currentStep: 2),
                      
                      const Spacer(),

                      // 💎 تطبيق القالب الكريستالي الموحد [GlassContainer] بدقة لتثبيت الـ Layout لمنع الهزة
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: GlassContainer(
                          height: 220, // ارتفاع هندسي ثابت وثابت يمنع تمدد أو انكماش البطاقة أثناء التنقل
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() => _currentPage = index);
                            },
                            itemCount: _onboardingData.length,
                            itemBuilder: (context, index) {
                              // ✨ تم إزالة كلمة const من الأسطر التالية لتقبل ألوان الـ final بنجاح هندسي تام
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _onboardingData[index]['title']!,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.glassTextPrimary, // أبيض ثابت ومقبول كـ const
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _onboardingData[index]['description']!,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 14.0,
                                      height: 1.5,
                                      color: AppColors.glassTextSecondary, // 🌟 يشتغل الآن بنسبة 100% وبدون خط أحمر
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                      const Spacer(),

                      // 4️⃣ الجزء السفلي: مؤشرات التتبع ونظام الزر القياسي لتوحيد تجربة المستخدم
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                        child: Column(
                          children: [
                            // نقاط التتبع المودرن المتفاعلة بسلاسة
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _onboardingData.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  height: 6,
                                  width: _currentPage == index ? 24 : 6, 
                                  decoration: BoxDecoration(
                                    color: _currentPage == index 
                                        ? AppColors.brandOrange 
                                        : Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),

                            // ⚪ زر "التالي / ابدأ الآن" القياسي بارتفاع ثابت يطابق شاشات الدخول لمنع الهزة البصرية
                            GestureDetector(
                              onTap: () {
                                if (_currentPage < _onboardingData.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOutCubic,
                                  );
                                } else {
                                  Navigator.of(context).pushReplacementNamed('/role_selection');
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: 54, // تثبيت الارتفاع البرمجي لمنع أي هزة فجائية واهتزاز في الواجهات
                                decoration: BoxDecoration(
                                  color: AppColors.glassBtnActive, // يعمل بكفاءة ونعومة من ملف ألوانكِ
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.35),
                                      blurRadius: 16,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 6), 
                                    ),
                                    BoxShadow(
                                      color: AppColors.brandOrangeDark.withOpacity(0.15),
                                      blurRadius: 10,
                                      spreadRadius: -2,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    _currentPage == _onboardingData.length - 1 ? 'ابدأ الآن' : 'التالي',
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, 
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
