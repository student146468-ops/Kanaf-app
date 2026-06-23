import 'package:flutter/material.dart';

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

  final List<Map<String, dynamic>> _donationTypes = const [
    {
      'id': 'food',
      'title': 'مواد غذائية',
      'desc': 'سلات غذائية، حليب أطفال، معلبات، ومستلزمات مطبخ.',
      'icon': Icons.ramen_dining_rounded,
    },
    {
      'id': 'clothes',
      'title': 'ملابس وكسوة',
      'desc': 'ملابس جديدة، أحذية، بطانيات، وأغطية موسمية.',
      'icon': Icons.checkroom_rounded,
    },
    {
      'id': 'school',
      'title': 'مستلزمات تعليمية',
      'desc': 'حقائب، دفاتر، أقلام، وأدوات تساعد الأطفال على التعلم.',
      'icon': Icons.school_rounded,
    },
    {
      'id': 'health',
      'title': 'رعاية صحية',
      'desc': 'أدوية، حفاضات، مستلزمات إسعاف، وأدوات عناية أساسية.',
      'icon': Icons.health_and_safety_rounded,
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: donorMobileAppBar(
          title: 'تبرع عيني',
          leading: IconButton(
            tooltip: 'رجوع',
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textDarkPrimary, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      children: [
                        _buildIntro(),
                        const SizedBox(height: 18),
                        const Text(
                          'اختر نوع التبرع',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDarkPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ..._donationTypes.map(_buildDonationType),
                        if (_selectedType.isNotEmpty) ...[
                          const SizedBox(height: 18),
                          _buildDetailsForm(),
                        ],
                      ],
                    ),
                  ),
                  _buildNextButton(),
                ],
              ),
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
          const Text(
            'تفاصيل التبرع',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textDarkPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _quantityController,
            label: 'الكمية',
            hint: 'مثال: 3 سلات أو 10 قطع',
            icon: Icons.numbers_rounded,
            requiredMessage: 'أدخل كمية التبرع',
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _descriptionController,
            label: 'الوصف',
            hint: 'اكتب وصفًا مختصرًا لما ستقدمه',
            icon: Icons.description_rounded,
            requiredMessage: 'أدخل وصف التبرع',
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _contactController,
            label: 'وسيلة التواصل',
            hint: 'رقم هاتف أو بريد للتنسيق',
            icon: Icons.call_rounded,
            requiredMessage: 'أدخل وسيلة تواصل',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _notesController,
            label: 'ملاحظات إضافية',
            hint: 'وقت مناسب للاستلام أو أي تفاصيل مهمة',
            icon: Icons.edit_note_rounded,
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
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction:
          maxLines == 1 ? TextInputAction.next : TextInputAction.newline,
      validator: requiredMessage == null
          ? null
          : (value) {
              if (value == null || value.trim().isEmpty) {
                return requiredMessage;
              }
              return null;
            },
      style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.brandOrange),
        labelStyle: const TextStyle(fontFamily: 'Tajawal'),
        hintStyle: const TextStyle(
          fontFamily: 'Tajawal',
          color: AppColors.textDarkMuted,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.innerBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: AppColors.successGreen, width: 1.3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.innerBorder),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.inventory_2_rounded, color: AppColors.successGreen),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'اختر الفئة الأقرب لما تريد تقديمه، وسيتم تنسيق الاستلام مع دار الرعاية بطريقة واضحة.',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                height: 1.5,
                color: AppColors.textDarkSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationType(Map<String, dynamic> type) {
    final selected = _selectedType == type['id'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => setState(() => _selectedType = type['id'] as String),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color:
                    selected ? AppColors.successGreen : AppColors.innerBorder,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.successGreenLight
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    type['icon'] as IconData,
                    color: selected
                        ? AppColors.successGreen
                        : AppColors.textDarkSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type['title'] as String,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDarkPrimary,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        type['desc'] as String,
                        style: const TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 13,
                          height: 1.45,
                          color: AppColors.textDarkSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                  color: selected
                      ? AppColors.successGreen
                      : AppColors.textDarkMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    final hasSelection = _selectedType.isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.innerBorder)),
      ),
      child: FilledButton.icon(
        onPressed: hasSelection ? _submitDonation : null,
        icon: const Icon(Icons.arrow_back_rounded, size: 18),
        label: const Text('متابعة التبرع'),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          backgroundColor: AppColors.successGreen,
          disabledBackgroundColor: AppColors.innerBorder,
          foregroundColor: Colors.white,
          disabledForegroundColor: AppColors.textDarkMuted,
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  void _submitDonation() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final selectedType = _donationTypes.firstWhere(
      (type) => type['id'] == _selectedType,
    );

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
