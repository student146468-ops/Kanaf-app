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
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _newController.addListener(_refreshStrength);
  }

  @override
  void dispose() {
    _newController.removeListener(_refreshStrength);
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _refreshStrength() {
    if (mounted) setState(() {});
  }

  Future<void> _submit() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

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
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final strength = _PasswordStrength.from(_newController.text);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 68,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leadingWidth: 58,
          leading: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 12,
              top: 8,
              bottom: 8,
            ),
            child: KanafCircleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          title: Text(
            'تغيير كلمة المرور',
            style: kanafTitleStyle.copyWith(fontSize: 20),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kanafMobileMaxWidth),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 360),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 12 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      kanafHorizontalPadding,
                      8,
                      kanafHorizontalPadding,
                      28 + bottomInset,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SecurityNoticeCard(),
                        const SizedBox(height: 18),
                        _SoftCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldTitle('كلمة المرور الحالية'),
                              _PasswordField(
                                controller: _currentController,
                                hint: 'أدخل كلمة المرور الحالية',
                                obscureText: _obscureCurrent,
                                onToggle: () => setState(
                                  () => _obscureCurrent = !_obscureCurrent,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'يرجى إدخال كلمة المرور الحالية';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              const _FieldTitle('كلمة المرور الجديدة'),
                              _PasswordField(
                                controller: _newController,
                                hint: '8 أحرف على الأقل',
                                obscureText: _obscureNew,
                                onToggle: () => setState(
                                  () => _obscureNew = !_obscureNew,
                                ),
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
                              const SizedBox(height: 12),
                              _PasswordStrengthMeter(strength: strength),
                              const SizedBox(height: 16),
                              const _FieldTitle('تأكيد كلمة المرور الجديدة'),
                              _PasswordField(
                                controller: _confirmController,
                                hint: 'أعد كتابة كلمة المرور الجديدة',
                                obscureText: _obscureConfirm,
                                onToggle: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'يرجى تأكيد كلمة المرور الجديدة';
                                  }
                                  if (value.trim() !=
                                      _newController.text.trim()) {
                                    return 'كلمة المرور والتأكيد غير متطابقين';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _PasswordRequirementsCard(
                          password: _newController.text,
                        ),
                        const SizedBox(height: 22),
                        _SavePasswordButton(
                          isSaving: _isSaving,
                          onPressed: _submit,
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.shield_outlined,
                                color: AppColors.textDarkMuted,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'لن يتم تسجيل خروجك من حسابك الحالي.',
                                style: kanafMutedStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecurityNoticeCard extends StatelessWidget {
  const _SecurityNoticeCard();

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      borderColor: AppColors.brandOrange.withOpacity(0.18),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brandOrange.withOpacity(0.11),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.enhanced_encryption_outlined,
              color: AppColors.brandOrange,
              size: 24,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: kanafBodyStyle.copyWith(
                  fontSize: 14,
                  color: AppColors.textDarkSecondary,
                ),
                children: [
                  const TextSpan(
                    text: 'اختر كلمة مرور قوية لحماية حسابك ومتابعة مساهماتك ',
                  ),
                  TextSpan(
                    text: 'بأمان.',
                    style: kanafBodyStyle.copyWith(
                      fontSize: 14,
                      color: AppColors.brandOrange,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
        style: kanafSectionTitleStyle.copyWith(
          fontSize: 13.5,
          fontWeight: FontWeight.w800,
        ),
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
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: TextFormField(
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
            size: 21,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 56,
          ),
          suffixIcon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: IconButton(
              key: ValueKey(obscureText),
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: AppColors.textDarkMuted,
                size: 20,
              ),
              onPressed: onToggle,
            ),
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 56,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          border: _border(AppColors.innerBorder),
          enabledBorder: _border(AppColors.innerBorder),
          focusedBorder: _border(AppColors.brandOrange),
          errorBorder: _border(AppColors.errorRed),
          focusedErrorBorder: _border(AppColors.errorRed),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color.withOpacity(0.8)),
    );
  }
}

class _PasswordStrengthMeter extends StatelessWidget {
  const _PasswordStrengthMeter({required this.strength});

  final _PasswordStrength strength;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'قوة كلمة المرور',
              style: kanafSectionTitleStyle.copyWith(fontSize: 13),
            ),
            const Spacer(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Text(
                strength.label,
                key: ValueKey(strength.label),
                style: kanafMutedStyle.copyWith(
                  color: strength.color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(4, (index) {
            final active = index < strength.level;
            return Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  end: index == 3 ? 0 : 6,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active
                        ? strength.color
                        : AppColors.innerBorder.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _PasswordRequirementsCard extends StatelessWidget {
  const _PasswordRequirementsCard({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final checks = [
      _RequirementCheck(
        label: '8 أحرف على الأقل',
        passed: password.trim().length >= 8,
      ),
      _RequirementCheck(
        label: 'حرف كبير وحرف صغير',
        passed: RegExp(r'[A-Z]').hasMatch(password) &&
            RegExp(r'[a-z]').hasMatch(password),
      ),
      _RequirementCheck(
        label: 'رقم واحد على الأقل',
        passed: RegExp(r'\d').hasMatch(password),
      ),
      _RequirementCheck(
        label: 'رمز خاص مثل !@#\$%',
        passed:
            RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=~`;/\\[\]]').hasMatch(password),
      ),
    ];

    return _SoftCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brandOrange.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.brandOrange,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'يجب أن تحتوي كلمة المرور على:',
                  style: kanafSectionTitleStyle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 10),
                ...checks.map(
                  (check) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _RequirementRow(check: check),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow({required this.check});

  final _RequirementCheck check;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 19,
          height: 19,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: check.passed
                ? AppColors.successGreen
                : AppColors.innerBorder.withOpacity(0.65),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            check.label,
            style: kanafBodyStyle.copyWith(
              fontSize: 13.2,
              color: AppColors.textDarkSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _SavePasswordButton extends StatelessWidget {
  const _SavePasswordButton({
    required this.isSaving,
    required this.onPressed,
  });

  final bool isSaving;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isSaving ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandOrange,
          disabledBackgroundColor: AppColors.brandOrange.withOpacity(0.72),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.brandOrange.withOpacity(0.24),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isSaving
              ? const SizedBox(
                  key: ValueKey('loading'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
              : const Row(
                  key: ValueKey('label'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_rounded, size: 19),
                    SizedBox(width: 8),
                    Text('حفظ كلمة المرور'),
                  ],
                ),
        ),
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderColor = AppColors.innerBorder,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PasswordStrength {
  const _PasswordStrength({
    required this.level,
    required this.label,
    required this.color,
  });

  final int level;
  final String label;
  final Color color;

  factory _PasswordStrength.from(String password) {
    if (password.isEmpty) {
      return const _PasswordStrength(
        level: 0,
        label: 'ضعيفة',
        color: AppColors.textDarkMuted,
      );
    }

    var score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password)) {
      score++;
    }
    if (RegExp(r'\d').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=~`;/\\[\]]').hasMatch(password)) {
      score++;
    }

    return switch (score) {
      0 || 1 => const _PasswordStrength(
          level: 1,
          label: 'ضعيفة',
          color: AppColors.errorRed,
        ),
      2 => const _PasswordStrength(
          level: 2,
          label: 'متوسطة',
          color: AppColors.brandOrange,
        ),
      3 => const _PasswordStrength(
          level: 3,
          label: 'جيدة',
          color: AppColors.brandOrange,
        ),
      _ => const _PasswordStrength(
          level: 4,
          label: 'قوية',
          color: AppColors.successGreen,
        ),
    };
  }
}

class _RequirementCheck {
  const _RequirementCheck({
    required this.label,
    required this.passed,
  });

  final String label;
  final bool passed;
}
