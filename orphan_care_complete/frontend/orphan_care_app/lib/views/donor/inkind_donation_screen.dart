import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class InkindDonationScreen extends StatefulWidget {
  const InkindDonationScreen({super.key});

  @override
  State<InkindDonationScreen> createState() => _InkindDonationScreenState();
}

class _InkindDonationScreenState extends State<InkindDonationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedType = '';

  static const Color _primaryOrange = Color(0xFFFF8C42);
  static const Color _screenBackground = Color(0xFFF5F5F5);
  static const Color _cardBorder = Color(0xFFEAEAEA);

  final List<Map<String, dynamic>> _donationTypes = const [
    {
      'id': 'food',
      'title': 'مواد غذائية',
      'desc': 'سلات غذائية، حليب أطفال، معلبات، ومستلزمات مطبخ.',
      'icon': Icons.restaurant_outlined,
    },
    {
      'id': 'clothes',
      'title': 'ملابس وكسوة',
      'desc': 'ملابس جديدة، أحذية، بطانيات، وأغطية موسمية.',
      'icon': Icons.checkroom_outlined,
    },
    {
      'id': 'school',
      'title': 'مستلزمات تعليمية',
      'desc': 'حقائب، دفاتر، أقلام، وأدوات تساعد الأطفال على التعلم.',
      'icon': Icons.school_outlined,
    },
    {
      'id': 'health',
      'title': 'رعاية صحية',
      'desc': 'أدوية، حفاضات، مستلزمات إسعاف، وأدوات عناية أساسية.',
      'icon': Icons.health_and_safety_outlined,
    },
  ];

  @override
  void dispose() {
    _quantityController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: _screenBackground,
        appBar: const DonorAppBar(
          title: 'التبرع العيني',
        ),
        body: SafeArea(
          top: false,
          child: DonorMobileFrame(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsetsDirectional.fromSTEB(
                      20,
                      16,
                      20,
                      24 + bottomInset,
                    ),
                    children: [
                      const _DonationModeSelector(),
                      const SizedBox(height: DonorSpacing.xxl),
                      const DonorSectionTitle('اختر نوع التبرع'),
                      const SizedBox(height: DonorSpacing.md),
                      _DonationTypeGrid(
                        donationTypes: _donationTypes,
                        selectedType: _selectedType,
                        onSelected: (typeId) {
                          setState(() => _selectedType = typeId);
                        },
                      ),
                      const SizedBox(height: DonorSpacing.xxl),
                      _buildDetailsForm(),
                    ],
                  ),
                ),
                donorMobileBottomBar(
                  height: 86,
                  child: Container(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      20,
                      12,
                      20,
                      18,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: AppColors.innerBorder),
                      ),
                    ),
                    child: DonorPrimaryButton(
                      label: 'إرسال الطلب',
                      icon: Icons.send_outlined,
                      onTap: _selectedType.isNotEmpty ? _submitDonation : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DonorSectionTitle('تفاصيل التبرع'),
          const SizedBox(height: DonorSpacing.md),
          _buildTextField(
            controller: _quantityController,
            label: 'الكمية',
            hint: 'مثال: 3 سلات أو 10 قطع',
            icon: Icons.numbers_rounded,
            requiredMessage: 'أدخل كمية التبرع',
          ),
          const SizedBox(height: DonorSpacing.md),
          _buildTextField(
            controller: _descriptionController,
            label: 'الوصف',
            hint: 'اكتب وصفًا مختصرًا لما ستقدمه',
            icon: Icons.description_outlined,
            requiredMessage: 'أدخل وصف التبرع',
            maxLines: 3,
          ),
          const SizedBox(height: DonorSpacing.md),
          _buildTextField(
            controller: _contactController,
            label: 'وسيلة التواصل',
            hint: 'رقم هاتف أو بريد للتنسيق',
            icon: Icons.call_outlined,
            requiredMessage: 'أدخل وسيلة تواصل',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: DonorSpacing.md),
          _buildTextField(
            controller: _notesController,
            label: 'ملاحظات إضافية',
            hint: 'وقت مناسب للاستلام أو تفاصيل مهمة',
            icon: Icons.edit_note_outlined,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? requiredMessage,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return DonorInputField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction:
          maxLines == 1 ? TextInputAction.next : TextInputAction.newline,
      validator: requiredMessage == null
          ? null
          : (value) {
              if (value == null || value.trim().isEmpty) return requiredMessage;
              return null;
            },
      style: DonorTextStyles.body.copyWith(
        fontSize: 14,
        color: AppColors.textDarkPrimary,
      ),
      labelText: label,
      hintText: hint,
      prefixIcon: icon,
      iconColor: _primaryOrange,
      focusedBorderColor: _primaryOrange,
      fillColor: Colors.white,
      labelStyle: DonorTextStyles.muted.copyWith(
        color: AppColors.textDarkSecondary,
      ),
      hintStyle: DonorTextStyles.muted.copyWith(
        color: AppColors.textDarkMuted,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DonorSpacing.lg,
        vertical: 15,
      ),
      enabledBorderWidth: 1,
      focusedBorderWidth: 1.2,
      useFormField: true,
    );
  }

  Future<void> _submitDonation() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final selectedType =
        _donationTypes.firstWhere((type) => type['id'] == _selectedType);
    final provider = AppProviderScope.of(context);
    if (provider.currentUser.isEmpty) {
      await provider.fetchCurrentUser(notifyLoading: false);
    }
    if (!mounted) return;

    final donorName = provider.currentUser['username']?.toString().trim() ?? '';
    if (donorName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر تحديد بيانات المستخدم لحفظ التبرع.',
            style: TextStyle(fontFamily: 'Vazirmatn'),
          ),
        ),
      );
      return;
    }
    final saved = await provider.submitDonation({
      'donor_name': donorName,
      'item_type':
          '${selectedType['title']} - ${_quantityController.text.trim()}',
      'status': 'قيد التنفيذ',
    });
    if (!mounted) return;
    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? 'تعذر حفظ التبرع حاليًا.',
            style: const TextStyle(fontFamily: 'Vazirmatn'),
          ),
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/donation_success',
      arguments: {
        'type': 'تبرع عيني',
        'reference': 'IK-${DateTime.now().millisecondsSinceEpoch}',
        'summary':
            '${selectedType['title']} - ${_quantityController.text.trim()}',
        'description': _descriptionController.text.trim(),
        'contact': _contactController.text.trim(),
        'notes': _notesController.text.trim(),
      },
    );
  }
}

class _DonationModeSelector extends StatelessWidget {
  const _DonationModeSelector();

  @override
  Widget build(BuildContext context) {
    return const DonorCard(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: _DonationModeOption(
              label: 'تقديم تبرع',
              selected: true,
              enabled: true,
            ),
          ),
          SizedBox(width: DonorSpacing.xs),
          Expanded(
            child: _DonationModeOption(
              label: 'طلب استلام',
              selected: false,
              enabled: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _DonationModeOption extends StatelessWidget {
  const _DonationModeOption({
    required this.label,
    required this.selected,
    required this.enabled,
  });

  final String label;
  final bool selected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? Colors.white
        : enabled
            ? AppColors.textDarkPrimary
            : AppColors.textDarkMuted;

    return Container(
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
            selected ? _InkindDonationScreenState._primaryOrange : Colors.white,
        borderRadius: DonorRadii.medium,
        border: Border.all(
          color: selected
              ? _InkindDonationScreenState._primaryOrange
              : _InkindDonationScreenState._cardBorder,
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: DonorTextStyles.button.copyWith(
          fontSize: 13,
          color: foreground,
        ),
      ),
    );
  }
}

class _DonationTypeGrid extends StatelessWidget {
  const _DonationTypeGrid({
    required this.donationTypes,
    required this.selectedType,
    required this.onSelected,
  });

  final List<Map<String, dynamic>> donationTypes;
  final String selectedType;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = DonorSpacing.sm;
        final itemWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: donationTypes.map((type) {
            final typeId = type['id'] as String;
            return SizedBox(
              width: itemWidth,
              child: _DonationTypeTile(
                title: type['title'] as String,
                icon: type['icon'] as IconData,
                selected: selectedType == typeId,
                onTap: () => onSelected(typeId),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _DonationTypeTile extends StatelessWidget {
  const _DonationTypeTile({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const activeColor = _InkindDonationScreenState._primaryOrange;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: DonorRadii.medium,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 92,
          padding: const EdgeInsets.all(DonorSpacing.md),
          decoration: BoxDecoration(
            color: selected ? activeColor.withOpacity(0.08) : Colors.white,
            borderRadius: DonorRadii.medium,
            border: Border.all(
              color: selected
                  ? activeColor
                  : _InkindDonationScreenState._cardBorder,
              width: selected ? 1.3 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? activeColor : AppColors.textDarkSecondary,
                size: 26,
              ),
              const SizedBox(height: DonorSpacing.xs),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: DonorTextStyles.button.copyWith(
                  fontSize: 12.5,
                  color: selected ? activeColor : AppColors.textDarkPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
