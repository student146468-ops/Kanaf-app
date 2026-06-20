import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/glass_container.dart'; // 💎 استيراد القالب الزجاجي الموحد لضمان وحدة الهوية البصرية
import '../widgets/welcome_progress_indicator.dart';
import 'login_screen.dart'; // مستدعى لربط التدفق الانسيابي لواجهة تسجيل الدخول في الأسفل

/// [RegisterScreen] - واجهة إنشاء حساب جديد لـ "تطبيق كَنَفْ" لعام 2026.
/// تم تطويرها بالاعتماد على قالب [GlassContainer] الموحد هندسياً وإضافة كاشفات التركيز التفاعلية.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // كاشفات النصوص البرمجية للتحكم بالبيانات المدخلة بدقة وعزلها في الذاكرة
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // كاشفات التركيز التفاعلية لإضاءة الحقول بالإطار البرتقالي عند الكتابة
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  
  bool _isLoading = false;
  bool _obscurePassword = true; // ميزة حماية كلمة المرور التفاعلية

  @override
  void initState() {
    super.initState();
    // ربط مستمعي التركيز لتحديث الواجهة فوراً عند نقر الحقول
    _nameFocusNode.addListener(() => setState(() {}));
    _phoneFocusNode.addListener(() => setState(() {}));
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // تفريغ الذاكرة فور الخروج من الواجهة لمنع تسريب البيانات (Memory Leak)
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  /// ميكانيكية التحقق من البيانات وتنشيط مؤشر التحميل البصري
  void _handleRegister() {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || 
        _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء ملء كافة الحقول لإنشاء الحساب بنجاح', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.brandOrange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // محاكاة الاتصال الآمن ومعالجة طلب الحساب الخيرى الجديد
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تمت معالجة البيانات بنجاح وتأكيد الحساب', style: TextStyle(fontFamily: 'Cairo')),
            backgroundColor: Colors.green, // تعديل للون الأخضر للدلالة على النجاح
          ),
        );
        // الانتقال التلقائي للرئيسية بعد النجاح (حسب هيكلية تطبيقك)
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final containerWidth = isWebOrDesktop ? 420.0 : double.infinity;

    return Directionality(
      textDirection: TextDirection.rtl, // توجيه المحتوى هندسياً باللغة العربية
      child: Scaffold(
        backgroundColor: const Color(0xFF131313), // لون خلفي عميق ومريح للعين يمنع تشتت الحواف
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
                // 1️⃣ الصورة الخلفية المعتمدة للهوية الإنسانية (child.png) طافية بالكامل وبدون قص
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/child.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),

                // 2️⃣ طبقة متدرجة من الضوء المعتم المطعمة بالبرتقالي الداكن لضمان تباين النصوص
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.10),
                          AppColors.brandOrangeDark.withOpacity(0.24), // تطعيم زجاجي دافئ يحاكي الهوية البصرية لشاشات كنف
                          Colors.black.withOpacity(0.72), // تعتيم مكثف لبروز الحقول البيضاء والأزرار
                        ],
                      ),
                    ),
                  ),
                ),

                // 3️⃣ المحتوى الطافي والبطاقة الكريستالية الزجاجية المودرن
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const WelcomeProgressIndicator(currentStep: 5),
                          const SizedBox(height: 22),
                          // نصوص الترحيب العلوية المريحة للنظر
                          Text(
                            'انضم إلى كَنَفْ',
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
                            'كن كنفاً وسنداً لهم واصنع فرقاً اليوم',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.glassTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 25),

                          // 💎 تطبيق القالب الكريستالي الموحد [GlassContainer] بدقة لمنع تكرار الكود
                          GlassContainer(
                            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // حقل الاسم الكامل التفاعلي
                                _buildGlassInputField(
                                  controller: _nameController,
                                  focusNode: _nameFocusNode,
                                  hintText: 'الاسم كامل',
                                  icon: Icons.badge_outlined,
                                  keyboardType: TextInputType.name,
                                ),
                                const SizedBox(height: 16),

                                // حقل رقم الهاتف التفاعلي
                                _buildGlassInputField(
                                  controller: _phoneController,
                                  focusNode: _phoneFocusNode,
                                  hintText: 'رقم الهاتف',
                                  icon: Icons.phone_android_outlined,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 16),

                                // حقل البريد الإلكتروني التفاعلي
                                _buildGlassInputField(
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  hintText: 'البريد الإلكتروني',
                                  icon: Icons.mail_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),

                                // حقل كلمة المرور الآمن والتفاعلي 
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
                                const SizedBox(height: 28),

                                // ⚪ زر "تأكيد وإنشاء الحساب" المانع للهزة البصرية
                                _buildGlassRegisterButton(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),

                          // 🔗 زر العودة والانتقال لصفحة تسجيل الدخول الخالية تماماً من تضارب الـ Context
                          _buildLoginFooterAction(),
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

  // 🧱 دالة هندسة حقول الإدخال المطورة والمحمية تفاعلياً بـ FocusNode
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
        color: Colors.black.withOpacity(0.15), // عمق بصري يمنع تسطح الحقل ويحمي وضوح المدخلات
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFocused ? AppColors.brandOrange : Colors.white.withOpacity(0.12),
          width: isFocused ? 1.5 : 1.0,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: isPassword ? obscureText : false, // تفعيل الإخفاء بناءً على نوع الحقل ديناميكياً
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
          // زر العين البصري التفاعلي يظهر فقط إذا كان الحقل مخصصاً لكلمات المرور
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

  // 🧱 زر "إنشاء الحساب" ثلاثي الأبعاد مع مصفوفة ظلال بارزة لمنع تسطح الواجهة تحفيزاً للنقر
  Widget _buildGlassRegisterButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _handleRegister,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.glassBtnActive, // اللون المعتمد للأزرار الفعالة الطافية بملف ألوانكِ الذكي
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 16,
              spreadRadius: 1,
              offset: const Offset(0, 6), // دفع الظل لأسفل لإبراز البعد الفيزيائي الفخم وتحفيز النقر
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // مؤشر تحميل برتقالي متناسق
                  ),
                )
              : const Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // نص عالي التباين فوق الزر
                    letterSpacing: 0,
                  ),
                ),
        ),
      ),
    );
  }

  // 🔗 ميثود الرابط السفلي المصححة علمياً لمنع خطأ التكرار وتضارب الأسماء (Context Collision)
  Widget _buildLoginFooterAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لديك حساب بالفعل؟',
          style: TextStyle(fontFamily: 'Cairo', fontSize: 14.5, color: Colors.white.withOpacity(0.85)),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () {
            // ✅ الحل الهندسي الدقيق: تم تبديل الـ context الداخلي للـ builder إلى (ctx) ليعمل بسلاسة تامة وبدون أي تعارض
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => const LoginScreen()));
          },
          child: const Text(
            'تسجيل الدخول',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline, // خط سفلي مودرن للفت الانتباه الاحترافي للروابط
              decorationThickness: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
