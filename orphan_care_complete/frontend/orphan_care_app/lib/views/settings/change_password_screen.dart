import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'shared_mobile_ui.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // TODO: Connect password update to AppProvider/backend when available.
    _showMessage('تم حفظ كلمة المرور بنجاح.', AppColors.successGreen);
    Navigator.of(context).pop();
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Tajawal')),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KanafPage(
      title: 'تغيير كلمة المرور',
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
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
                const KanafCard(
                  color: AppColors.brandOrangeLight,
                  borderColor: Colors.white,
                  child: Row(
                    children: [
                      KanafIconBox(
                        icon: Icons.enhanced_encryption_outlined,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'اختر كلمة مرور قوية لحماية حسابك ومتابعة مساهماتك بأمان.',
                          style: kanafBodyStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const _FieldTitle('كلمة المرور الحالية'),
                _PasswordField(
                  controller: _currentController,
                  hint: 'أدخل كلمة المرور الحالية',
                  obscureText: _obscureCurrent,
                  onToggle: () =>
                      setState(() => _obscureCurrent = !_obscureCurrent),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال كلمة المرور الحالية';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const _FieldTitle('كلمة المرور الجديدة'),
                _PasswordField(
                  controller: _newController,
                  hint: '8 أحرف على الأقل',
                  obscureText: _obscureNew,
                  onToggle: () => setState(() => _obscureNew = !_obscureNew),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال كلمة المرور الجديدة';
                    }
                    if (value.trim().length < 8) {
                      return 'كلمة المرور يجب ألا تقل عن 8 أحرف';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const _FieldTitle('تأكيد كلمة المرور الجديدة'),
                _PasswordField(
                  controller: _confirmController,
                  hint: 'أعد كتابة كلمة المرور الجديدة',
                  obscureText: _obscureConfirm,
                  onToggle: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى تأكيد كلمة المرور الجديدة';
                    }
                    if (value.trim() != _newController.text.trim()) {
                      return 'كلمة المرور والتأكيد غير متطابقين';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                KanafPrimaryButton(
                  label: 'حفظ كلمة المرور',
                  icon: Icons.save_rounded,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldTitle extends StatelessWidget {
  final String title;

  const _FieldTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8, start: 4),
      child: Text(
        title,
        style: kanafSectionTitleStyle.copyWith(fontSize: 13.5),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final VoidCallback onToggle;
  final String? Function(String?) validator;

  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.obscureText,
    required this.onToggle,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      textInputAction: TextInputAction.next,
      style: const TextStyle(
        fontFamily: 'Tajawal',
        color: AppColors.textDarkPrimary,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: kanafMutedStyle,
        errorStyle: const TextStyle(fontFamily: 'Tajawal'),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.brandOrange,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
            color: AppColors.textDarkMuted,
            size: 20,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.white,
        border: _border(AppColors.innerBorder),
        enabledBorder: _border(AppColors.innerBorder),
        focusedBorder: _border(AppColors.brandOrange),
        errorBorder: _border(AppColors.errorRed),
        focusedErrorBorder: _border(AppColors.errorRed),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color),
    );
  }
}
