import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../volunteer/volunteer_ui.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkModeEnabled = false;

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: VolunteerMobileFrame(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(volunteerAppBarHeight),
            child: VolunteerTopBar(title: 'الإعدادات'),
          ),
          body: Container(
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SettingsGroup(
                      title: 'الحساب',
                      children: [
                        _SettingsTile(
                          icon: Icons.person_outline_rounded,
                          title: 'الحساب',
                          onTap: () => _showSoonMessage(
                            'تعديل بيانات الحساب قريبًا',
                          ),
                        ),
                        _SettingsTile(
                          icon: Icons.lock_outline_rounded,
                          title: 'تغيير كلمة المرور',
                          onTap: () => Navigator.of(context)
                              .pushNamed('/change_password'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _SettingsGroup(
                      title: 'التفضيلات',
                      children: [
                        _SettingsTile(
                          icon: Icons.language_rounded,
                          title: 'اللغة',
                          trailing: const Text(
                            'العربية',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: Color(0xFF8A8F98),
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          onTap: () => _showSoonMessage(
                            'اللغة العربية مفعلة حاليًا',
                          ),
                        ),
                        _SettingsTile(
                          icon: Icons.dark_mode_outlined,
                          title: 'الوضع الداكن',
                          trailing: Switch(
                            value: _darkModeEnabled,
                            activeColor: AppColors.brandOrange,
                            onChanged: (value) {
                              setState(() => _darkModeEnabled = value);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _SettingsGroup(
                      title: 'الدعم والمعلومات',
                      children: [
                        _SettingsTile(
                          icon: Icons.help_outline_rounded,
                          title: 'مركز المساعدة',
                          onTap: () => _showSoonMessage(
                            'مركز المساعدة سيتوفر قريبًا',
                          ),
                        ),
                        _SettingsTile(
                          icon: Icons.privacy_tip_outlined,
                          title: 'سياسة الخصوصية',
                          onTap: () => _showSoonMessage(
                            'سياسة الخصوصية ستتوفر قريبًا',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    _LogoutButton(
                      onTap: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login',
                        (route) => false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsGroup({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: Color(0xFF1F2937),
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFF0F0F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF1F1F1),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final showArrow = trailing == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 62,
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              const SizedBox(width: 18),
              Icon(icon, color: const Color(0xFF6B7280), size: 23),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xFF1F2937),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (showArrow)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFB5BAC3),
                  size: 24,
                )
              else
                trailing!,
              const SizedBox(width: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF2F0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFFFD6D0)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout_rounded,
                color: Color(0xFFE05243),
                size: 21,
              ),
              SizedBox(width: 8),
              Text(
                'تسجيل الخروج',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Color(0xFFE05243),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
