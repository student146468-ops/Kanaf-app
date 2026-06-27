import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'onboarding_screen.dart'; // لربط الحركة الانسيابية بالشاشة الثانية مباشرة

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _dotController;
  final List<Animation<double>> _dotAnimations = [];

  @override
  void initState() {
    super.initState();

    // 1. أنيميشن ظهور محتويات الشاشة بنعومة عند الفتح
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();

    // 2. أنيميشن نبض الشعار الدائري بكل رقة وفخامة
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 3. أنيميشن وميض نقاط التحميل التتابعية باللون البرتقالي (RTL Flow)
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    for (int i = 0; i < 3; i++) {
      int reverseIndex = 2 - i;
      _dotAnimations.add(
        Tween<double>(begin: 0.2, end: 1.0).animate(
          CurvedAnimation(
            parent: _dotController,
            curve: Interval(
              reverseIndex * 0.25,
              0.5 + (reverseIndex * 0.25),
              curve: Curves.easeInOut,
            ),
          ),
        ),
      );
    }

    // 🌌 4. الانتقال التلقائي السلس، والمريح جداً للعين إلى الـ Onboarding بعد 4 ثوانٍ
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const OnboardingScreen(),
            transitionDuration: const Duration(
              milliseconds: 1100,
            ), // ثانية ومئة جزء لضمان تداخل لوني ناعم وسينمائي
            reverseTransitionDuration: const Duration(milliseconds: 1100),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // منحنى حركة فيزيائي ناعم جداً مريح للعين البشرية
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubic,
              );

              // تلاشي متداخل يدمج الأبيض مع صورة الطفل باحترافية
              return FadeTransition(
                opacity: curvedAnimation,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.97,
                    end: 1.0,
                  ).animate(curvedAnimation),
                  child: child,
                ),
              );
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // 1. تعديل لون الخلفية ليكون أبيض ناصع وصافي
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🎯 2. حاوية الشعار المربعة داخل دائرة محاطة بظلال ناعمة جداً وثلاثية الأبعاد
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors
                              .white, // خلفية بيضاء للدائرة ليبرز الشعار بداخلها
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 24,
                              offset: const Offset(
                                  0, 12), // إيحاء بالارتفاع عن الشاشة
                            ),
                            BoxShadow(
                              color: AppColors.brandOrange.withOpacity(0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        // قص الصورة المربعة لتصبح دائرية تماماً ومثالية هندسياً
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              20.0,
                            ), // مسافة أمان (Padding) لكي لا تلمس أطراف الـ logo الدائرة
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit
                                  .contain, // يضمن عدم تمطط أو تشوه أبعاد الشعار
                              errorBuilder: (context, error, stackTrace) {
                                // أيقونة احتياطية ذكية بلون الهوية في حال عدم قراءة مسار الصورة مؤقتاً
                                return const Icon(
                                  Icons.volunteer_activism_rounded,
                                  size: 50,
                                  color: AppColors.brandOrange,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ✍️ 3. اسم التطبيق بخط القاهرة الفخم باللون البرتقالي الرسمي ليناسب الخلفية البيضاء
                    const Text(
                      'كَــنَـــفْ',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors
                            .brandOrange, // تعديل اللون للبرتقالي لبروز مثالي فوق الأبيض
                        letterSpacing: 0,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // الشعار اللفظي الفرعي بلون رمادي كربوني مريح جداً لمنع التشتت
                    const Text(
                      'معًا نصنع أثرًا',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors
                            .textDarkSecondary, // متناسق تماماً مع الهوية والقراءة
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 🔄 4. نقاط التحميل المحدثة بلون الهوية البرتقالي لتتناسب مع بياض الواجهة
                    AnimatedBuilder(
                      animation: _dotController,
                      builder: (context, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (index) {
                            return Opacity(
                              opacity: _dotAnimations[index].value,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                width: 9,
                                height: 9,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors
                                      .brandOrange, // تومض بالبرتقالي لتعطي حيوية مبهجة للواجهة
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: SizedBox(
                height: 142,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned.fill(
                      child: ClipPath(
                        clipper: const _SplashWaveClipper(amplitude: 26),
                        child: Container(
                          color: AppColors.brandOrangeLight.withOpacity(0.55),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ClipPath(
                        clipper: const _SplashWaveClipper(amplitude: 22),
                        child: Container(
                          height: 112,
                          color: AppColors.brandOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashWaveClipper extends CustomClipper<Path> {
  final double amplitude;

  const _SplashWaveClipper({required this.amplitude});

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, amplitude)
      ..cubicTo(
        size.width * 0.22,
        amplitude * 2.1,
        size.width * 0.36,
        0,
        size.width * 0.56,
        amplitude * 0.78,
      )
      ..cubicTo(
        size.width * 0.76,
        amplitude * 1.55,
        size.width * 0.86,
        amplitude * 0.18,
        size.width,
        amplitude * 0.92,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant _SplashWaveClipper oldClipper) {
    return oldClipper.amplitude != amplitude;
  }
}
