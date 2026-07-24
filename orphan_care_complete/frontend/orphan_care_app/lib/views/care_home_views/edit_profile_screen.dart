import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import 'care_home_reference_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  bool _filled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppProviderScope.of(context).fetchCareHomeProfile();
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final profile = provider.careHomeProfile;
    if (!_filled && profile.isNotEmpty) {
      _name.text = careHomeValue(profile['name'], '');
      _phone.text = careHomeValue(profile['phone'], '');
      _email.text = careHomeValue(profile['email'], '');
      _address.text = careHomeValue(profile['address'], '');
      _filled = true;
    }

    return CareHomeRefScaffold(
      title: 'تعديل ملف الدار',
      bodyPadding: EdgeInsets.zero,
      bottomAction: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
        child: CareHomeRefButton(
          label: 'حفظ التعديلات',
          loading: provider.isSaving,
          onPressed: () async {
            final ok = await provider.updateCareHomeProfile({
              'name': _name.text.trim(),
              'phone': _phone.text.trim(),
              'email': _email.text.trim(),
              'address': _address.text.trim(),
            });
            if (context.mounted && ok) Navigator.of(context).pop(true);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 92),
        physics: const BouncingScrollPhysics(),
        children: [
          const CareHomeRefImage(
            assetPath: 'assets/images/image13.png',
            height: 136,
            icon: Icons.home_work_outlined,
          ),
          const SizedBox(height: 14),
          _Field(
              controller: _name, hint: 'اسم الدار', icon: Icons.badge_outlined),
          _Field(
            controller: _phone,
            hint: 'رقم الهاتف',
            icon: Icons.phone_iphone_rounded,
            keyboardType: TextInputType.phone,
          ),
          _Field(
            controller: _email,
            hint: 'البريد الإلكتروني',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          _Field(
            controller: _address,
            hint: 'العنوان',
            icon: Icons.location_on_outlined,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;

  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: careHomeRefBodyStrong,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: careHomeRefCaption,
          prefixIcon: Icon(icon, color: const Color(0xFF9AA1AD), size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: careHomeRefLine),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: careHomeRefOrange),
          ),
        ),
      ),
    );
  }
}
