import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            'الإعدادات العامة',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 بطاقة الملف الشخصي المصغرة بنمط زجاجي فخم
              _buildGlassCard(
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.brandOrange.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.brandOrange, width: 1.5),
                      ),
                      child: const Center(
                        child: Text('👩‍💻', style: TextStyle(fontSize: 28)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'أماني عادل أحمد',
                            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'amani@example.com',
                            style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withOpacity(0.4), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // ⚙️ المجموعة الأولى: إعدادات الحساب والأمان
              const Text(
                '🔐 الحساب والأمان',
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
              ),
              const SizedBox(height: 12),
              _buildGlassCard(
                child: Column(
                  children: [
                    _buildSettingTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'تغيير كلمة المرور',
                      iconColor: AppColors.brandOrange,
                      onTap: () => Navigator.of(context).pushNamed('/change_password'),
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      icon: Icons.shield_outlined,
                      title: 'الخصوصية ومشاركة البيانات',
                      iconColor: const Color(0xFF0F9D58),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // 🔔 المجموعة الثانية: التفضيلات والتطبيق
              const Text(
                '🎨 تفضيلات التطبيق',
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
              ),
              const SizedBox(height: 12),
              _buildGlassCard(
                child: Column(
                  children: [
                    _buildSettingTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'إشعارات النظام اللوجستية',
                      iconColor: Colors.blueAccent,
                      trailing: Switch(
                        value: true,
                        activeColor: AppColors.brandOrange,
                        onChanged: (val) {},
                      ),
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      icon: Icons.g_translate_rounded,
                      title: 'لغة التطبيق',
                      iconColor: Colors.purpleAccent,
                      trailing: const Text(
                        'العربية (أمريكا)',
                        style: TextStyle(fontFamily: 'Cairo', color: Colors.white38, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // ℹ️ المجموعة الثالثة: الدعم والمغادرة
              _buildGlassCard(
                child: Column(
                  children: [
                    _buildSettingTile(
                      icon: Icons.help_outline_rounded,
                      title: 'مركز الدعم والمساعدة',
                      iconColor: Colors.teal,
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildSettingTile(
                      icon: Icons.logout_rounded,
                      title: 'تسجيل الخروج من الحساب',
                      iconColor: Colors.redAccent,
                      textColor: Colors.redAccent,
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // رقم الإصدار فخم في الأسفل ليوحي باكتمال النظام للمناقشين
              const Center(
                child: Text(
                  'تطبيق كَنَفْ الإنساني v1.0.0 © 2026',
                  style: TextStyle(fontFamily: 'Cairo', color: Colors.white24, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجيت مساعد لبناء الكروت الزجاجية الشفافة
  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06), width: 1.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }

  // ويدجيت مساعد لبناء أسطر الإعدادات التفاعلية السلسة
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required Color iconColor,
    Color textColor = Colors.white,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontFamily: 'Cairo', color: textColor, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            trailing ?? Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white.withOpacity(0.2)),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.white.withOpacity(0.05), thickness: 1, height: 1);
  }
}