import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeaderUserInfo(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildSettingsCardGroup([
                      _buildMenuTile(context, Icons.person_outline_rounded, 'تعديل البيانات الشخصية'),
                      _buildMenuTile(context, Icons.history_toggle_off_rounded, 'سجل التبرعات الكامل'),
                    ]),
                    const SizedBox(height: 16),
                    _buildSettingsCardGroup([
                      _buildMenuTile(context, Icons.security_rounded, 'الأمان وكلمة المرور'),
                      _buildMenuTile(context, Icons.language_rounded, 'لغة التطبيق (العربية)'),
                    ]),
                    const SizedBox(height: 24),
                    _buildLogoutButton(context),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderUserInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: AppColors.orangeGradient, begin: Alignment.topCenter, end: Alignment.bottomCenter),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 42,
            backgroundColor: Colors.white,
            child: Icon(Icons.person_rounded, size: 48, color: AppColors.brandOrange),
          ),
          const SizedBox(height: 14),
          const Text(
            'أنيس المحسن الكريم',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'عضو مساهم في غريان منذ 2026',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: Colors.white.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCardGroup(List<Widget> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.innerBorder, width: 1.2),
      ),
      child: Column(children: tiles),
    );
  }

  // 💎 تم إضافة معامل الـ context لتفعيل الانتقال والتنقل بين الصفحات بشكل سليم
  Widget _buildMenuTile(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.brandOrange, size: 22),
      title: Text(title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textDarkPrimary)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textDarkMuted),
      onTap: () {
        // 💎 أ) التحقق من العنوان للربط والانتقال لسجل التبرعات الكامل
        if (title == 'سجل التبرعات الكامل') {
          Navigator.pushNamed(context, '/donation_history');
        }
      },
    );
  }

  // 💎 تم تمرير الـ context وتعديل استدعاء الـ Extension لتفعيل الخروج بأمان
  Widget _buildLogoutButton(BuildContext context) {
    return OutlinedButton.styleFrom(
      fixedSize: const Size.fromHeight(52),
      side: const BorderSide(color: Color(0xFFBA1A1A), width: 1.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ).showButton(
      onPressed: () {
        // 💎 ب) تسجيل الخروج وتفريغ طوابق الذاكرة والعودة لصفحة تسجيل الدخول
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout_rounded, color: Color(0xFFBA1A1A), size: 18),
          SizedBox(width: 8),
          Text('تسجيل الخروج من الحساب', style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFBA1A1A))),
        ],
      ),
    );
  }
}

// 💎 تحديث الـ Extension الذكي ليدعم استقبال حدث الضغط المباشر دون أي مشاكل توافقية
extension OutlinedButtonFix on ButtonStyle {
  Widget showButton({required VoidCallback onPressed, required Widget child}) {
    return OutlinedButton(style: this, onPressed: onPressed, child: child);
  }
}