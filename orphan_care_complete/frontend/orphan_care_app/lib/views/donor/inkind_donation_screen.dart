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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: donorMobileAppBar(
          title: 'تبرع عيني',
          leading: donorBackButton(context),
        ),
        body: Stack(
          children: [
            const Positioned.fill(child: DonorBackground()),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: donorMobileMaxWidth),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                          children: [
                            const _IntroCard(),
                            const SizedBox(height: 18),
                            const _SectionTitle('اختر نوع التبرع'),
                            const SizedBox(height: 10),
                            ..._donationTypes.map(_buildDonationType),
                            if (_selectedType.isNotEmpty) ...[
                              const SizedBox(height: 18),
                              _buildDetailsForm(),
                            ],
                          ],
                        ),
                      ),
                      donorMobileBottomBar(
                        height: 84,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                top: BorderSide(color: AppColors.innerBorder)),
                          ),
                          child: DonorPrimaryButton(
                            label: 'متابعة التبرع',
                            icon: Icons.arrow_back_rounded,
                            color: AppColors.successGreen,
                            onTap: _selectedType.isNotEmpty
                                ? _submitDonation
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
          const _SectionTitle('تفاصيل التبرع'),
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
            icon: Icons.description_outlined,
            requiredMessage: 'أدخل وصف التبرع',
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _contactController,
            label: 'وسيلة التواصل',
            hint: 'رقم هاتف أو بريد للتنسيق',
            icon: Icons.call_outlined,
            requiredMessage: 'أدخل وسيلة تواصل',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 10),
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
    return TextFormField(
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
      style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.successGreen),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        labelStyle: const TextStyle(fontFamily: 'Tajawal'),
        hintStyle: const TextStyle(
          fontFamily: 'Tajawal',
          color: AppColors.textDarkMuted,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: _border(AppColors.innerBorder),
        focusedBorder: _border(AppColors.successGreen),
        errorBorder: _border(AppColors.errorRed),
        focusedErrorBorder: _border(AppColors.errorRed),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: 1.2),
    );
  }

  Widget _buildDonationType(Map<String, dynamic> type) {
    final selected = _selectedType == type['id'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DonorCard(
        color: selected
            ? AppColors.successGreenLight.withOpacity(0.30)
            : Colors.white,
        onTap: () => setState(() => _selectedType = type['id'] as String),
        child: Row(
          children: [
            DonorIconBox(
              icon: type['icon'] as IconData,
              color: selected
                  ? AppColors.successGreen
                  : AppColors.textDarkSecondary,
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
                      fontWeight: FontWeight.w900,
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
              color:
                  selected ? AppColors.successGreen : AppColors.textDarkMuted,
            ),
          ],
        ),
      ),
    );
  }

  void _submitDonation() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final selectedType =
        _donationTypes.firstWhere((type) => type['id'] == _selectedType);

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

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return const DonorCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.inventory_2_outlined, color: AppColors.successGreen),
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
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 15,
        fontWeight: FontWeight.w900,
        color: AppColors.textDarkPrimary,
      ),
    );
  }
}
