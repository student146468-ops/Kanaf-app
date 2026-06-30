import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController =
      TextEditingController(text: 'دار الأمان لرعاية الأيتام');
  final _locationController = TextEditingController(text: 'غريان - ليبيا');
  final _phoneController = TextEditingController(text: '+218 91 000 0000');
  final _summaryController = TextEditingController(
    text:
        'تنظيم دعم دور رعاية الأيتام وربط المتبرعين والمتطوعين بالاحتياجات الحقيقية داخل الدار.',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم حفظ بيانات الملف محليًا وهي جاهزة للربط الحقيقي لاحقًا.',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: Color(0xFF10B981),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Stack(
              children: [
                const Positioned.fill(child: _CareHomeBackground()),
                SafeArea(
                  child: Column(
                    children: [
                      _HeaderBar(
                        title: 'تعديل ملف الدار',
                        onBack: () => Navigator.of(context).pop(),
                        onSave: _saveProfile,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                          child: Form(
                            key: _formKey,
                            child: CareHomeCard(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'البيانات الأساسية',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textDarkPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _InputField(
                                    controller: _nameController,
                                    label: 'اسم دار الرعاية',
                                    icon: Icons.home_work_outlined,
                                    validator: _required,
                                  ),
                                  const SizedBox(height: 14),
                                  _InputField(
                                    controller: _locationController,
                                    label: 'الموقع',
                                    icon: Icons.location_on_outlined,
                                    validator: _required,
                                  ),
                                  const SizedBox(height: 14),
                                  _InputField(
                                    controller: _phoneController,
                                    label: 'رقم التواصل',
                                    icon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                    validator: _required,
                                  ),
                                  const SizedBox(height: 14),
                                  _InputField(
                                    controller: _summaryController,
                                    label: 'نبذة مختصرة',
                                    icon: Icons.notes_outlined,
                                    maxLines: 5,
                                    validator: _required,
                                  ),
                                  const SizedBox(height: 20),
                                  _SaveButton(onTap: _saveProfile),
                                ],
                              ),
                            ),
                          ),
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
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }
}

class _CareHomeBackground extends StatelessWidget {
  const _CareHomeBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.white, AppColors.scaffoldBackground],
        ),
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onSave;

  const _HeaderBar({
    required this.title,
    required this.onBack,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _RoundIconButton(
              icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textDarkPrimary,
              ),
            ),
          ),
          _RoundIconButton(icon: Icons.check_rounded, onTap: onSave),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.innerBorder),
        ),
        child: Icon(icon, color: AppColors.textDarkPrimary, size: 19),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?) validator;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(
        fontFamily: 'Tajawal',
        color: AppColors.textDarkPrimary,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.brandOrange, size: 20),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        labelStyle: TextStyle(
          fontFamily: 'Tajawal',
          color: AppColors.textDarkSecondary,
        ),
        errorStyle: const TextStyle(fontFamily: 'Tajawal'),
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: _border(AppColors.innerBorder),
        enabledBorder: _border(AppColors.innerBorder),
        focusedBorder: _border(AppColors.brandOrange.withOpacity(0.85)),
        errorBorder: _border(AppColors.errorRed.withOpacity(0.7)),
        focusedErrorBorder: _border(AppColors.errorRed),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SaveButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: AppColors.orangeGradient),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandOrange.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_outlined, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'حفظ التعديلات',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
