import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../donor/donor_mobile_chrome.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkModeEnabled = false;

  static const Color _primaryOrange = Color(0xFFFF8C42);
  static const Color _screenBackground = Color(0xFFF5F5F5);

  void _showSoonMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _primaryOrange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _screenBackground,
        appBar: DonorTopBar(
          title: 'الإعدادات',
          leading: Padding(
            padding: const EdgeInsetsDirectional.only(start: DonorSpacing.md),
            child: DonorTopBarActionButton(
              icon: Icons.arrow_forward_ios_rounded,
              tooltip: 'رجوع',
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: DonorMobileFrame(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 28),
              children: [
                _DonorSettingsSection(
                  title: 'الإعدادات الأساسية',
                  children: [
                    _DonorSettingsTile(
                      icon: Icons.person_outline_rounded,
                      title: 'الحساب',
                      subtitle: 'تعديل بيانات الحساب قريبًا',
                      onTap: () => _showSoonMessage(
                        'تعديل بيانات الحساب قريبًا',
                      ),
                    ),
                    _DonorSettingsTile(
                      icon: Icons.language_rounded,
                      title: 'اللغة',
                      subtitle: 'العربية',
                      onTap: () => _showSoonMessage(
                        'اللغة العربية مفعلة حاليًا',
                      ),
                    ),
                    _DonorSettingsSwitchTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'الوضع الداكن',
                      subtitle: 'تخصيص مظهر التطبيق',
                      value: _darkModeEnabled,
                      onChanged: (value) {
                        setState(() => _darkModeEnabled = value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: DonorSpacing.lg),
                _DonorSettingsSection(
                  title: 'الخصوصية والأمان',
                  children: [
                    _DonorSettingsTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'تغيير كلمة المرور',
                      subtitle: 'إدارة حماية الحساب',
                      onTap: () =>
                          Navigator.of(context).pushNamed('/change_password'),
                    ),
                    _DonorSettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'سياسة الخصوصية',
                      subtitle: 'تفاصيل حماية بياناتك',
                      onTap: () => _showSoonMessage(
                        'سياسة الخصوصية ستتوفر قريبًا',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DonorSpacing.lg),
                _DonorSettingsSection(
                  title: 'الدعم والمعلومات',
                  children: [
                    _DonorSettingsTile(
                      icon: Icons.help_outline_rounded,
                      title: 'مركز المساعدة',
                      subtitle: 'الدعم والأسئلة الشائعة',
                      onTap: () => _showSoonMessage(
                        'مركز المساعدة سيتوفر قريبًا',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DonorSpacing.xxl),
                _DonorLogoutAction(
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DonorSettingsSection extends StatelessWidget {
  const _DonorSettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, bottom: 10),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DonorTextStyles.sectionTitle.copyWith(fontSize: 15),
          ),
        ),
        DonorCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1)
                  const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DonorSettingsTile extends StatelessWidget {
  const _DonorSettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: DonorRadii.large,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 16,
            vertical: 11,
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textDarkSecondary, size: 22),
              const SizedBox(width: DonorSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DonorTextStyles.sectionTitle.copyWith(
                        fontSize: 14.5,
                        color: AppColors.textDarkPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DonorTextStyles.muted.copyWith(
                          color: AppColors.textDarkSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: DonorSpacing.sm),
              trailing ??
                  const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.textDarkMuted,
                    size: 24,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonorSettingsSwitchTile extends StatelessWidget {
  const _DonorSettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _DonorSettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        activeColor: _SettingsScreenState._primaryOrange,
        activeTrackColor: _SettingsScreenState._primaryOrange.withOpacity(0.28),
        inactiveThumbColor: AppColors.textDarkMuted,
        inactiveTrackColor: AppColors.innerBorder,
        onChanged: onChanged,
      ),
    );
  }
}

class _DonorLogoutAction extends StatelessWidget {
  const _DonorLogoutAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DonorSecondaryButton(
      label: 'تسجيل الخروج',
      icon: Icons.logout_rounded,
      color: AppColors.errorRed,
      onTap: onTap,
    );
  }
}
