import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'volunteer_ui.dart';

class ApplyOpportunityView extends StatefulWidget {
  const ApplyOpportunityView({super.key});

  @override
  State<ApplyOpportunityView> createState() => _ApplyOpportunityViewState();
}

class _ApplyOpportunityViewState extends State<ApplyOpportunityView> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _skillsController = TextEditingController();
  bool _hasAttachment = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    final provider = AppProviderScope.of(context);

    await provider.applyAsVolunteer({
      'name': 'متطوع كنف',
      'specialty': _skillsController.text.trim(),
      'points': 0,
      'status': 'pending',
      'hours_worked': 0,
      'motivation': _reasonController.text.trim(),
      'opportunity': 'دعم تعليمي في أساسيات الحاسوب',
      'has_attachment': _hasAttachment,
    });

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    _showResultSheet(provider.errorMessage);
  }

  void _showResultSheet(String? errorMessage) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final hasError = errorMessage != null;
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VolunteerIconBox(
                icon: hasError
                    ? Icons.cloud_off_rounded
                    : Icons.check_circle_outline_rounded,
                color: hasError ? AppColors.errorRed : AppColors.successGreen,
                backgroundColor: hasError
                    ? AppColors.errorRedLight
                    : AppColors.successGreenLight,
                size: 58,
                iconSize: 32,
              ),
              const SizedBox(height: 14),
              Text(
                hasError ? 'تم حفظ الطلب محليًا' : 'تم إرسال طلبك بنجاح',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDarkPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hasError
                    ? 'لم يتوفر اتصال بالخادم الآن، لكن بيانات الطلب جاهزة للربط الحقيقي لاحقًا.'
                    : 'سيتم مراجعة الطلب وإشعارك بالحالة من صفحة الإشعارات.',
                textAlign: TextAlign.center,
                style: volunteerBodyStyle,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: VolunteerPrimaryButton(
                  label: 'العودة للرئيسية',
                  icon: Icons.home_rounded,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home_volunteer',
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return VolunteerAppScaffold(
      title: 'تقديم طلب تطوع',
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              volunteerHorizontalPadding,
              10,
              volunteerHorizontalPadding,
              28,
            ),
            children: [
              const _OpportunitySummary(),
              const SizedBox(height: 18),
              const VolunteerSectionTitle(
                title: 'ما الدافع الذي ترغب بمشاركته؟',
              ),
              const SizedBox(height: 8),
              _InputField(
                controller: _reasonController,
                hint: 'اكتب كيف يمكن لوقتك أو خبرتك أن تخدم هذه الفرصة.',
                maxLines: 4,
                validatorMessage: 'اكتب دافعك للتطوع في هذه الفرصة.',
              ),
              const SizedBox(height: 18),
              const VolunteerSectionTitle(
                title: 'المهارات أو الخبرات المناسبة',
              ),
              const SizedBox(height: 8),
              _InputField(
                controller: _skillsController,
                hint: 'مثال: تعليم، حاسوب، تنظيم، أنشطة أطفال.',
                maxLines: 3,
                validatorMessage: 'اكتب مهارة واحدة على الأقل.',
              ),
              const SizedBox(height: 18),
              _AttachmentTile(
                selected: _hasAttachment,
                onTap: () => setState(() => _hasAttachment = !_hasAttachment),
              ),
              const SizedBox(height: 26),
              VolunteerPrimaryButton(
                label: _isSubmitting ? 'جار إرسال الطلب' : 'إرسال الطلب',
                icon: Icons.send_rounded,
                loading: _isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OpportunitySummary extends StatelessWidget {
  const _OpportunitySummary();

  @override
  Widget build(BuildContext context) {
    return const VolunteerCard(
      child: Row(
        children: [
          VolunteerIconBox(icon: Icons.volunteer_activism_rounded),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('الفرصة التي ستتقدم لها', style: volunteerMutedStyle),
                SizedBox(height: 3),
                Text(
                  'دعم تعليمي في أساسيات الحاسوب',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textDarkPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
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

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String validatorMessage;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.maxLines,
    required this.validatorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontFamily: 'Tajawal',
        color: AppColors.textDarkPrimary,
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w700,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return validatorMessage;
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: volunteerMutedStyle,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
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

class _AttachmentTile extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _AttachmentTile({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      onTap: onTap,
      color: selected ? AppColors.brandOrangeLight : Colors.white,
      borderColor: selected ? AppColors.brandOrange : AppColors.innerBorder,
      child: Row(
        children: [
          VolunteerIconBox(
            icon: selected ? Icons.task_alt_rounded : Icons.attach_file_rounded,
            color:
                selected ? AppColors.brandOrange : AppColors.textDarkSecondary,
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              selected
                  ? 'تم إرفاق ملف تعريفي مؤقت'
                  : 'إرفاق سيرة أو ملف تعريفي اختياري',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: selected
                    ? AppColors.brandOrangeDark
                    : AppColors.textDarkSecondary,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            child: selected
                ? const Icon(
                    Icons.check_circle_rounded,
                    key: ValueKey('selected'),
                    color: AppColors.brandOrange,
                    size: 22,
                  )
                : const Icon(
                    Icons.add_circle_outline_rounded,
                    key: ValueKey('empty'),
                    color: AppColors.textDarkMuted,
                    size: 22,
                  ),
          ),
        ],
      ),
    );
  }
}
