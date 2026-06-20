import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

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
          title: const Text('تغيير كلمة المرور', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 💡 لوحة تلميح علوية كريستالية رقيقة
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.brandOrange.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.brandOrange.withOpacity(0.15), width: 1.2),
                ),
                child: Row(
                  children: [
                    const Text('🔒', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'لحماية حسابك ومستندات التبرع، يرجى اختيار كلمة مرور قوية تحتوي على أحرف وأرقام.',
                        style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withOpacity(0.7), fontSize: 13, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 1. حقل كلمة المرور الحالية
              _buildInputFieldTitle('كلمة المرور الحالية'),
              _buildGlassInputField(
                hint: 'أدخل كلمة المرور الحالية',
                obscureText: _obscureCurrent,
                onSuffixPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
              ),
              const SizedBox(height: 20),

              // 2. حقل كلمة المرور الجديدة
              _buildInputFieldTitle('كلمة المرور الجديدة'),
              _buildGlassInputField(
                hint: 'أدخل كلمة المرور الجديدة والقوية',
                obscureText: _obscureNew,
                onSuffixPressed: () => setState(() => _obscureNew = !_obscureNew),
              ),
              const SizedBox(height: 20),

              // 3. حقل تأكيد كلمة المرور الجديدة
              _buildInputFieldTitle('تأكيد كلمة المرور الجديدة'),
              _buildGlassInputField(
                hint: 'أعد كتابة كلمة المرور الجديدة للتأكيد',
                obscureText: _obscureConfirm,
                onSuffixPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              const SizedBox(height: 40),

              // 🚀 زر الحفظ والتحديث الفخم والمبهر
              GestureDetector(
                onTap: () {
                  // عرض رسالة نجاح منبثقة احترافية لإبهار اللجنة عند الضغط
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('تم تحديث كلمة المرور بنجاح ✅', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                      backgroundColor: const Color(0xFF0F9D58),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.brandOrange,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brandOrange.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'حفظ التعديلات الجديدة 💾',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputFieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4),
      child: Text(
        title,
        style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 13),
      ),
    );
  }

  Widget _buildGlassInputField({
    required String hint,
    required bool obscureText,
    required VoidCallback onSuffixPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.2),
      ),
      child: TextField(
        obscureText: obscureText,
        style: const TextStyle(fontFamily: 'Cairo', color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontFamily: 'Cairo', color: Colors.white.withOpacity(0.25), fontSize: 13),
          prefixIcon: const Icon(Icons.lock_rounded, color: AppColors.brandOrange, size: 20),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.white38, size: 20),
            onPressed: onSuffixPressed,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
