import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'shared_mobile_ui.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  void _showSoonMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.brandOrange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KanafPage(
      title: 'الإعدادات',
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            kanafHorizontalPadding,
            8,
            kanafHorizontalPadding,
            28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProfileSummary(),
              const SizedBox(height: 22),
              const _SectionLabel('الحساب والأمان'),
              const SizedBox(height: 10),
              KanafCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SettingTile(
                      icon: Icons.lock_reset_rounded,
                      title: 'تغيير كلمة المرور',
                      subtitle: 'حدّث كلمة المرور للحفاظ على أمان حسابك.',
                      color: AppColors.brandOrange,
                      onTap: () =>
                          Navigator.of(context).pushNamed('/change_password'),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _SettingTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'الخصوصية والبيانات',
                      subtitle:
                          'إعدادات مشاركة البيانات ستتوفر عند ربط النظام.',
                      color: AppColors.successGreen,
                      onTap: () => _showSoonMessage(
                        'سيتم تفعيل إعدادات الخصوصية عند ربطها بالنظام.',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const _SectionLabel('تفضيلات التطبيق'),
              const SizedBox(height: 10),
              KanafCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SettingTile(
                      icon: Icons.notifications_active_outlined,
                      title: 'إشعارات المتابعة',
                      subtitle:
                          'تنبيهات التبرعات والتطوع وحالة الاحتياجات المهمة.',
                      color: AppColors.skyBlueDark,
                      trailing: Switch(
                        value: _notificationsEnabled,
                        activeColor: AppColors.brandOrange,
                        onChanged: (value) =>
                            setState(() => _notificationsEnabled = value),
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    const _SettingTile(
                      icon: Icons.language_rounded,
                      title: 'لغة التطبيق',
                      subtitle: 'العربية',
                      color: Color(0xFF7E57C2),
                      trailing: KanafBadge(
                        label: 'مفعّلة',
                        color: AppColors.successGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              KanafCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SettingTile(
                      icon: Icons.info_outline_rounded,
                      title: 'عن تطبيق كنف',
                      subtitle: 'فكرة المنصة وطريقة تنظيم الدعم.',
                      color: AppColors.brandOrange,
                      onTap: () =>
                          Navigator.of(context).pushNamed('/about_app'),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _SettingTile(
                      icon: Icons.logout_rounded,
                      title: 'تسجيل الخروج',
                      subtitle: 'إنهاء الجلسة الحالية والعودة لتسجيل الدخول.',
                      color: AppColors.errorRed,
                      textColor: AppColors.errorRed,
                      onTap: () =>
                          Navigator.of(context).pushReplacementNamed('/login'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const Center(
                child: Text('كنف v1.0.0', style: kanafMutedStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary();

  @override
  Widget build(BuildContext context) {
    return const KanafCard(
      color: AppColors.brandOrangeLight,
      borderColor: Colors.white,
      child: Row(
        children: [
          KanafIconBox(
            icon: Icons.person_rounded,
            backgroundColor: Colors.white,
            size: 56,
            iconSize: 29,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إعدادات حساب كنف',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textDarkPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'تحكم في أمان الحساب والتنبيهات من مكان واحد.',
                  style: kanafBodyStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: kanafSectionTitleStyle);
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color? textColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.textColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: color.withOpacity(0.08),
        splashColor: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(kanafRadius),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              KanafIconBox(icon: icon, color: color, size: 42, iconSize: 21),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: textColor ?? AppColors.textDarkPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(subtitle, style: kanafMutedStyle),
                  ],
                ),
              ),
              trailing ??
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.textDarkMuted,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
