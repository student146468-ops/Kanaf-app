import 'package:flutter/material.dart';
import '../utils/app_colors.dart'; // ربط ملف الألوان المطور
import '../widgets/glass_container.dart'; // ربط المكون الزجاجي الموحد 25%
import '../widgets/welcome_progress_indicator.dart';
import 'register_screen.dart'; 

/// [LoginScreen] - واجهة تسجيل الدخول لـ "تطبيق كَنَفْ" لعام 2026.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true; 

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // ✨ دالة معالجة الدخول المحدثة والمصححة بالكامل للتوجيه الشرطي الثلاثي (كما هي بدون تغيير)
  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال البريد الإلكتروني وكلمة المرور', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.brandOrange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (mounted) {
      setState(() => _isLoading = false);
      
      // 💎 التقاط الدور الممرر من شاشة الـ RoleSelection
      final String selectedRole = ModalRoute.of(context)?.settings.arguments as String? ?? 'donor';
      
      // 💎 التوجيه الشرطي الذكي والثلاثي بناءً على الدور المختار
      if (selectedRole == 'care_home') {
        Navigator.of(context).pushReplacementNamed('/care_home_home'); 
      } else if (selectedRole == 'volunteer') {
        Navigator.of(context).pushReplacementNamed('/volunteer_home'); 
      } else {
        Navigator.of(context).pushReplacementNamed('/supporter_home'); 
      }
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
        backgroundColor: AppColors.scaffoldBackground, // استخدام الخلفية الداكنة الفخمة من ملف الألوان
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
                // 1. تثبيت الخلفية البصرية الجديدة باستخدام صورة child.png المعتمدة بالملي
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/child.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),

                // طبقة التدرج السينمائي المدمجة بنعومة فوق الصورة لمنح لمعان وتأثير بصري تفاعلي ومريح للعين
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

                // 2. محتوى الواجهة المنظم بالكامل فوق الطبقة الكريستالية
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const WelcomeProgressIndicator(currentStep: 4),
                          const SizedBox(height: 22),
                          Text(
                            'مرحباً بك في كَنَفْ',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColors.glassTextPrimary,
                              shadows: [Shadow(color: Colors.black.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))],
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'سجّل دخولك لتتفقد احتياجات الأيتام وتصنع أثراً',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.glassTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // 3. استدعاء القالب الزجاجي الموحد لدمج العناصر وتوحيد الشفافية والـ Blur عند 25%
                          GlassContainer(
                            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 22),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // حقل البريد الإلكتروني المطور والمحمي من التمدد العشوائي واهتزاز الحجم
                                _buildGlassInputField(
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  hintText: 'البريد الإلكتروني',
                                  icon: Icons.alternate_email_rounded, 
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 18),

                                // حقل كلمة المرور المطور
                                _buildGlassInputField(
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  hintText: 'كلمة المرور',
                                  icon: Icons.lock_outline_rounded,
                                  keyboardType: TextInputType.visiblePassword,
                                  isPassword: true,
                                  obscureText: _obscurePassword,
                                  onSuffixIconTap: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                                const SizedBox(height: 14),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed('/forgot_password');
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                                      child: Text(
                                        'نسيت كلمة المرور؟',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.glassTextPrimary.withOpacity(0.85),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // زر الدخول التفاعلي الاحترافي ثلاثي الأبعاد
                                _buildGlassLoginButton(),
                                const SizedBox(height: 32),

                                Row(
                                  children: [
                                    Expanded(child: Divider(color: Colors.white.withOpacity(0.15), thickness: 1)),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 14.0),
                                      child: Text(
                                        'أو سجل الدخول عبر',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 13.5,
                                          color: AppColors.glassTextSecondary,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Divider(color: Colors.white.withOpacity(0.15), thickness: 1)),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // أيقونات التواصل الاجتماعي المودرن المريحة للعين
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildSocialIcon(
                                      iconPath: 'assets/images/google_logo.png', 
                                      fallbackIcon: Icons.g_mobiledata_rounded,
                                      onTap: () {},
                                    ),
                                    const SizedBox(width: 24),
                                    _buildSocialIcon(
                                      iconPath: 'assets/images/apple_logo.png', 
                                      fallbackIcon: Icons.apple_rounded,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 35),

                          _buildSignUpAction(),
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

  // ويدجت حقل الإدخال بتصميم زجاجي ناعم متناسق مع تثبيت الطول لمنع الاهتزاز (Height: 56)
  Widget _buildGlassInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required IconData icon,
    required TextInputType keyboardType,
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
          color: isFocused ? AppColors.brandOrange : AppColors.glassBorderWhite.withOpacity(0.2),
          width: isFocused ? 1.5 : 1.0,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: isPassword ? obscureText : false,
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
            color: isFocused ? AppColors.brandOrange : AppColors.glassTextPrimary.withOpacity(0.6), 
            size: 22,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: isFocused ? AppColors.brandOrange.withOpacity(0.8) : AppColors.glassTextPrimary.withOpacity(0.5),
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

  // زر الدخول الموحد المتناسق مع الهوية والمقاسات الثابتة (Height: 54) لمنع اهتزاز الشاشات
  Widget _buildGlassLoginButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _handleLogin,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.glassBtnActive, 
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.30),
              blurRadius: 16,
              spreadRadius: 1,
              offset: const Offset(0, 6), 
            ),
            BoxShadow(
              color: AppColors.brandOrangeDark.withOpacity(0.12),
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
                  'تسجيل الدخول',
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

  Widget _buildSocialIcon({required String iconPath, required IconData fallbackIcon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.glassBorderWhite.withOpacity(0.2), width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Image.asset(
            iconPath, 
            errorBuilder: (context, error, stackTrace) => Icon(fallbackIcon, color: AppColors.glassTextPrimary.withOpacity(0.7), size: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ليس لديك حساب؟',
          style: TextStyle(fontFamily: 'Cairo', fontSize: 14.5, color: AppColors.glassTextPrimary.withOpacity(0.85)),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => const RegisterScreen()));
          },
          child: const Text(
            'إنشاء حساب',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline, 
              decorationThickness: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
