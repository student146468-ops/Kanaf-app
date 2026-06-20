import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/glass_container.dart'; // 💎 استيراد القالب الزجاجي الموحد لضمان وحدة الهوية البصرية
import '../widgets/welcome_progress_indicator.dart';

/// [ResetPasswordScreen] - واجهة تعيين كلمة المرور الجديدة لـ "تطبيق كَنَفْ"
/// مصممة بأسلوب زجاجي كريستالي فخم لامتصاص الخلفية الإنسانية وتقديم تجربة أمان تفاعلية ومودرن.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // تفعيل مستمعي التركيز لإضاءة الحقول بالإطار البرتقالي فوراً عند تفاعل المستخدم
    _passwordFocusNode.addListener(() => setState(() {}));
    _confirmPasswordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  // 🔐 دالة معالجة وتأكيد كلمة المرور الجديدة هندسياً
  Future<void> _handleResetPassword() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال كلمة المرور وتأكيدها أولاً', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.brandOrange,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كلمتا المرور غير متطابقتين، يرجى التثبت مجدداً', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.brandOrange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // محاكاة تحديث كلمة المرور وتأمينها داخل خوادم كنف الآمنة
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث كلمة المرور بنجاح، يمكنك تسجيل الدخول الآن', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.green,
        ),
      );

      // 🚀 توجيه انسيابي مباشر لواجهة تسجيل الدخول وتطهير المكدس
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
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

                // 3️⃣ المحتوى الداخلي وعناصر الإدخال الكريستالية المتناسقة
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const WelcomeProgressIndicator(currentStep: 7),
                          const SizedBox(height: 22),
                          Text(
                            'تعيين كلمة المرور',
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
                            'قم بإنشاء كلمة مرور جديدة قوية لحماية حسابك في كَنَفْ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.glassTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // 💎 تطبيق القالب الكريستالي الموحد [GlassContainer] بدقة وثبات
                          GlassContainer(
                            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 22),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // حقل كلمة المرور الجديدة
                                _buildGlassInputField(
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  hintText: 'كلمة المرور الجديدة',
                                  icon: Icons.lock_outline_rounded,
                                  isPassword: true,
                                  obscureText: _obscurePassword,
                                  onSuffixIconTap: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                                const SizedBox(height: 20),

                                // حقل تأكيد كلمة المرور الجديدة
                                _buildGlassInputField(
                                  controller: _confirmPasswordController,
                                  focusNode: _confirmPasswordFocusNode,
                                  hintText: 'تأكيد كلمة المرور',
                                  icon: Icons.enhanced_encryption_outlined,
                                  isPassword: true,
                                  obscureText: _obscureConfirmPassword,
                                  onSuffixIconTap: () {
                                    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                                  },
                                ),
                                const SizedBox(height: 32),

                                // زر حفظ وتحديث كلمة المرور القياسي المانع للهزة البصرية
                                _buildGlassSubmitButton(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 35),
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

  // 🧱 دالة بناء حقول الإدخال المحمية زجاجياً والمدعومة بـ FocusNode تفاعلي
  Widget _buildGlassInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixIconTap,
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
        obscureText: isPassword ? obscureText : false,
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
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: isFocused ? AppColors.brandOrange.withOpacity(0.8) : Colors.white.withOpacity(0.6),
                    size: 20,
                  ),
                  onPressed: onSuffixIconTap,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  // 🧱 زر التحديث ثلاثي الأبعاد المانع للتسطح مع تأثير الـ Glow الرقيق
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
                  'تحديث كلمة المرور',
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
}
