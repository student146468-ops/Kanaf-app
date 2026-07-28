import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../utils/app_colors.dart';
import '../utils/auth_navigation.dart';
import 'login_screen.dart';

const String _phoneValidationMessage =
    'رقم الهاتف يجب أن يتكون من 10 أرقام ويبدأ بـ 091 أو 092 أو 093 أو 094.';
const String _passwordValidationMessage =
    'كلمة المرور ضعيفة. يجب أن تتكون من 8 خانات على الأقل وتحتوي على حروف وأرقام.';

class RegisterScreen extends StatefulWidget {
  final String? selectedRole;

  const RegisterScreen({super.key, this.selectedRole});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ApiService _apiService = ApiService();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() => setState(() {}));
    _phoneFocusNode.addListener(() => setState(() {}));
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
    _confirmPasswordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  String? _selectedRoleFromRoute() {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final routeRole = arguments is String ? arguments : null;
    return AuthNavigation.normalizeRole(widget.selectedRole ?? routeRole);
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^(091|092|093|094)[0-9]{7}$').hasMatch(phoneNumber);
  }

  bool _isValidPassword(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Za-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  void _showRegisterError(String message, {Color color = AppColors.errorRed}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: color,
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'الرجاء ملء كافة الحقول لإنشاء الحساب بنجاح',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: AppColors.brandOrange,
        ),
      );
      return;
    }

    if (!_isValidPhoneNumber(_phoneController.text)) {
      _showRegisterError(_phoneValidationMessage);
      return;
    }

    if (!_isValidPassword(_passwordController.text)) {
      _showRegisterError(_passwordValidationMessage);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'كلمة المرور وتأكيدها غير متطابقين',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    final selectedRole = _selectedRoleFromRoute();
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'الرجاء اختيار نوع الحساب قبل إنشاء الحساب',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: AppColors.brandOrange,
        ),
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/role_selection',
        (route) => false,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final fullName = _nameController.text.trim();
      final response = await _apiService.register({
        'username': _emailController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'password_confirm': _confirmPasswordController.text,
        'first_name': fullName,
        'phone_number': _phoneController.text.trim(),
        'role': selectedRole,
      });

      if (!mounted) return;
      setState(() => _isLoading = false);
      AuthNavigation.navigateByRole(
        context,
        AuthNavigation.roleFromAuthResponse(response),
      );
    } catch (error) {
      debugPrint('Register failed: $error');
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _friendlyErrorMessage(error),
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerWidth = size.width > 600 ? 430.0 : double.infinity;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            width: containerWidth,
            height: double.infinity,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.vertical -
                        56,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'إنشاء حساب جديد',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: AppColors.brandOrange,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'أدخل بياناتك للمتابعة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: Color(0xFF6B7280),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _RegisterInputField(
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            hintText: 'الاسم الكامل',
                            icon: Icons.badge_outlined,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 16),
                          _RegisterInputField(
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            hintText: 'رقم الهاتف',
                            icon: Icons.phone_android_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          _RegisterInputField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            hintText: 'البريد الإلكتروني',
                            icon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          _RegisterInputField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            hintText: 'كلمة المرور',
                            icon: Icons.lock_outline_rounded,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(
                                  () => _obscurePassword = !_obscurePassword,
                                );
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: _passwordFocusNode.hasFocus
                                    ? AppColors.brandOrange
                                    : const Color(0xFF9CA3AF),
                                size: 21,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _RegisterInputField(
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocusNode,
                            hintText: 'تأكيد كلمة المرور',
                            icon: Icons.lock_outline_rounded,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(
                                  () => _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                                );
                              },
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: _confirmPasswordFocusNode.hasFocus
                                    ? AppColors.brandOrange
                                    : const Color(0xFF9CA3AF),
                                size: 21,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brandOrange,
                                disabledBackgroundColor:
                                    AppColors.brandOrange.withOpacity(0.58),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'إنشاء حساب جديد',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _LoginFooter(selectedRole: _selectedRoleFromRoute()),
                        ],
                      ),
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

  String _friendlyErrorMessage(Object error) {
    if (error is ApiServiceException) return error.message;
    return 'تعذر إكمال إنشاء الحساب حالياً. حاول مرة أخرى.';
  }
}

class _RegisterInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  const _RegisterInputField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.icon,
    required this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isFocused = focusNode.hasFocus;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFocused ? AppColors.brandOrange : const Color(0xFFE5E7EB),
          width: isFocused ? 1.6 : 1,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscureText,
        cursorColor: AppColors.brandOrange,
        style: const TextStyle(
          fontFamily: 'Tajawal',
          color: Color(0xFF1F2937),
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Tajawal',
            color: Color(0xFF9CA3AF),
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: Icon(
            icon,
            color: isFocused ? AppColors.brandOrange : const Color(0xFF9CA3AF),
            size: 21,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          suffixIcon: suffixIcon,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class _LoginFooter extends StatelessWidget {
  final String? selectedRole;

  const _LoginFooter({this.selectedRole});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'لديك حساب بالفعل؟',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 14.5,
            color: Color(0xFF4B5563),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => const LoginScreen(),
                settings: RouteSettings(arguments: selectedRole),
              ),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.brandOrange,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            minimumSize: const Size(44, 40),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          child: const Text('تسجيل الدخول'),
        ),
      ],
    );
  }
}
