import 'package:flutter/material.dart';
import '../utils/app_colors.dart'; 
import '../widgets/glass_container.dart'; // 💎 استيراد القالب الزجاجي الموحد لضمان وحدة الهوية البصرية
import '../widgets/welcome_progress_indicator.dart';

/// [ForgotPasswordScreen] - واجهة استعادة كلمة المرور لـ "تطبيق كَنَفْ"
/// تم تحديثها باستخدام [GlassContainer] الموحد هندسياً لمنع تعارض الـ const وتداخل الأنماط.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  // 🔄 دالة معالجة الإرسال والربط التفاعلي مع واجهة الـ OTP
  Future<void> _handleResetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال البريد الإلكتروني أولاً', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.brandOrange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // محاكاة الاتصال بالخادم لإرسال الرمز الآمن لـ كنف
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال رمز التحقق المكون من 6 أرقام لبريدك الإلكتروني', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.green,
        ),
      );
      
      // 🚀 الانتقال الانسيابي الفوري لواجهة الـ OTP الكريستالية المسجلة في الـ main
      Navigator.of(context).pushNamed('/otp');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final containerWidth = isWebOrDesktop ? 420.0 : double.infinity;

    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Scaffold(
        backgroundColor: const Color(0xFF131313), 
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
                // 1️⃣ خلفية الطفل المعتمدة للهوية الإنسانية للتطبيق طافية وبدون قص
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/child.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),

                // 2️⃣ طبقة التباين المتدرجة المطعمة بالبرتقالي الداكن لضمان حماية ووضوح النصوص
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.10),
                          AppColors.brandOrangeDark.withOpacity(0.24),
                          Colors.black.withOpacity(0.72),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3️⃣ المحتوى الداخلي وعنصر الإدخال الكريستالي
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const WelcomeProgressIndicator(currentStep: 6),
                          const SizedBox(height: 22),
                          Text(
                            'استعادة الحساب',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColors.glassTextPrimary,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'أدخل بريدك الإلكتروني لإرسال رمز التحقق وتعيين كلمة المرور',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.glassTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // 💎 تطبيق القالب الكريستالي الموحد [GlassContainer] بدقة لمنع تكرار الكود
                          GlassContainer(
                            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 22),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildGlassInputField(
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  hintText: 'البريد الإلكتروني',
                                  icon: Icons.alternate_email_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 28),

                                // زر الإرسال القياسي المانع للهزة البصرية
                                _buildGlassSubmitButton(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 35),

                          // زر العودة الخلفي الرشيق
                          _buildBackToLoginAction(),
                        ],
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

  Widget _buildGlassInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    final bool isFocused = focusNode.hasFocus;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFocused ? AppColors.brandOrange : Colors.white.withOpacity(0.12),
          width: isFocused ? 1.5 : 1.0,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        cursorColor: AppColors.brandOrange,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          color: AppColors.glassTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: AppColors.glassTextSecondary,
          ),
          prefixIcon: Icon(
            icon, 
            color: isFocused ? AppColors.brandOrange : Colors.white.withOpacity(0.7), 
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildGlassSubmitButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _handleResetPassword,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.glassBtnActive, 
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
          child: _isLoading
              ? const SizedBox(
                  width: 22, 
                  height: 22, 
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5, 
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'إرسال رمز التحقق',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildBackToLoginAction() {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back_ios_rounded, 
              color: Colors.white.withOpacity(0.85), 
              size: 14,
            ),
            const SizedBox(width: 8),
            Text(
              'العودة لتسجيل الدخول',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationThickness: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
