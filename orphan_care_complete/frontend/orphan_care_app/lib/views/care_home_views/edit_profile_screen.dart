import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{
    'name': TextEditingController(),
    'email': TextEditingController(),
    'phone': TextEditingController(),
    'city': TextEditingController(),
    'address': TextEditingController(),
    'description': TextEditingController(),
    'manager_name': TextEditingController(),
    'license_number': TextEditingController(),
    'children_count': TextEditingController(),
    'visit_hours': TextEditingController(),
  };
  bool _filled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = AppProviderScope.of(context);
      await provider.fetchCareHomeProfile();
      if (mounted) _fill(provider.careHomeProfile);
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _fill(Map<String, dynamic> profile) {
    if (_filled) return;
    _filled = true;
    for (final entry in _controllers.entries) {
      entry.value.text = profile[entry.key]?.toString() ?? '';
    }
    setState(() {});
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = AppProviderScope.of(context);
    final data = <String, dynamic>{
      for (final entry in _controllers.entries)
        entry.key: entry.value.text.trim(),
    };
    data['children_count'] =
        int.tryParse(_controllers['children_count']?.text.trim() ?? '0') ?? 0;
    final success = await provider.updateCareHomeProfile(data);
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(provider.errorMessage ?? 'تعذر تحديث الملف'),
            backgroundColor: AppColors.errorRed),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final provider = AppProviderScope.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: Container(
            width: isWebOrDesktop ? 430 : double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  CareHomeTopBar(
                    title: 'تعديل ملف الدار',
                    onBack: () => Navigator.of(context).pop(),
                    includeSafeArea: false,
                  ),
                  Expanded(
                    child: provider.isLoading && !_filled
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: CareHomeSpacing.lg,
                                vertical: CareHomeSpacing.md),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  _field('name', 'اسم الدار',
                                      Icons.home_work_rounded,
                                      requiredField: true),
                                  _field('email', 'البريد الإلكتروني',
                                      Icons.email_outlined),
                                  _field('phone', 'رقم الهاتف',
                                      Icons.phone_outlined),
                                  _field('city', 'المدينة',
                                      Icons.location_city_outlined),
                                  _field('address', 'العنوان',
                                      Icons.place_outlined,
                                      maxLines: 2),
                                  _field('description', 'الوصف',
                                      Icons.description_outlined,
                                      maxLines: 4),
                                  _field('manager_name', 'اسم المسؤول',
                                      Icons.person_outline_rounded),
                                  _field('license_number', 'رقم الترخيص',
                                      Icons.badge_outlined),
                                  _field('children_count', 'عدد الأطفال',
                                      Icons.groups_outlined,
                                      keyboardType: TextInputType.number),
                                  _field('visit_hours', 'ساعات الزيارة',
                                      Icons.schedule_outlined),
                                  const SizedBox(height: CareHomeSpacing.lg),
                                  CareHomePrimaryButton(
                                      label: 'حفظ التعديلات',
                                      loading: provider.isSaving,
                                      onPressed: _save),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String key, String hint, IconData icon,
      {int maxLines = 1,
      bool requiredField = false,
      TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: CareHomeSpacing.md),
      child: CareHomeInputField(
        controller: _controllers[key],
        label: '',
        hint: hint,
        icon: icon,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (value) =>
            requiredField && (value == null || value.trim().isEmpty)
                ? 'هذا الحقل مطلوب'
                : null,
      ),
    );
  }
}
