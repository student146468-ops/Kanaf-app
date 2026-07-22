import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class AddNeedScreen extends StatefulWidget {
  const AddNeedScreen({super.key});

  @override
  State<AddNeedScreen> createState() => _AddNeedScreenState();
}

class _AddNeedScreenState extends State<AddNeedScreen>
    with SingleTickerProviderStateMixin {
  static const Color _primaryOrange = AppColors.brandOrange;
  static const Color _background = Colors.white;
  static const Color _softGray = Color(0xFFF7F7F7);
  static const Color _borderGray = Color(0xFFEDEDED);
  static const double _mobileMaxWidth = 480;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _quantityController = TextEditingController();
  final _detailsController = TextEditingController();
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  String _selectedCategory = 'غذائي';
  String _priorityLevel = 'medium';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _titleController.dispose();
    _quantityController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submitNeed() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = AppProviderScope.of(context);
    final success = await provider.createNeed({
      'title': _titleController.text.trim(),
      'required_quantity': _quantityController.text.trim(),
      'description': _detailsController.text.trim(),
      'category': _selectedCategory,
      'priority': _priorityLevel,
      'status': 'active',
    });
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم نشر الاحتياج بنجاح.',
            style:
                TextStyle(fontFamily: careHomeFontFamily, color: Colors.white),
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? 'تعذر حفظ الاحتياج',
            style: const TextStyle(
                fontFamily: careHomeFontFamily, color: Colors.white),
          ),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _mobileMaxWidth),
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CareHomeAppBar(
                      title: 'إضافة احتياج جديد',
                      onBack: () => Navigator.of(context).pop(),
                      showShadow: false,
                    ),
                    Expanded(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _SectionTitle(title: 'تصنيف الاحتياج'),
                              const SizedBox(height: 12),
                              _CategorySelector(
                                selectedCategory: _selectedCategory,
                                onChanged: (category) {
                                  setState(() => _selectedCategory = category);
                                },
                              ),
                              const SizedBox(height: 20),
                              _FormCard(
                                children: [
                                  _NeedTextField(
                                    controller: _titleController,
                                    label: 'عنوان الاحتياج',
                                    hint: 'مثال: حليب أطفال',
                                    icon: Icons.edit_note_rounded,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: 16),
                                  _NeedTextField(
                                    controller: _quantityController,
                                    label: 'الكمية المطلوبة',
                                    hint: 'مثال: 25 صندوق',
                                    icon: Icons.numbers_rounded,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: 16),
                                  _NeedTextField(
                                    controller: _detailsController,
                                    label: 'تفاصيل الاحتياج',
                                    hint:
                                        'اكتب تفاصيل إضافية عن الاحتياج (اختياري).',
                                    icon: Icons.notes_rounded,
                                    requiredField: false,
                                    minLines: 4,
                                    maxLines: 5,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const _SectionTitle(title: 'مستوى الأولوية'),
                              const SizedBox(height: 12),
                              _PrioritySelector(
                                selectedPriority: _priorityLevel,
                                onChanged: (priority) {
                                  setState(() => _priorityLevel = priority);
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _BottomSubmitBar(
                      loading: provider.isSaving,
                      onSubmit: _submitNeed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddNeedLegacyAppBar extends StatelessWidget {
  const AddNeedLegacyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(18),
                splashColor: _AddNeedScreenState._primaryOrange.withAlpha(24),
                child: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textDarkPrimary,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 58),
            child: Text(
              'إضافة احتياج جديد',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _AddNeedText.title,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: _AddNeedText.sectionTitle);
  }
}

class _CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onChanged;

  const _CategorySelector({
    required this.selectedCategory,
    required this.onChanged,
  });

  static const _categories = [
    _CategoryItem('غذائي', Icons.restaurant_rounded),
    _CategoryItem('طبي', Icons.medical_services_rounded),
    _CategoryItem('تعليمي', Icons.school_rounded),
    _CategoryItem('ملابس', Icons.checkroom_rounded),
    _CategoryItem('ترفيهي', Icons.sports_esports_rounded),
    _CategoryItem('تنظيف', Icons.cleaning_services_rounded),
    _CategoryItem('أخرى', Icons.category_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _categories.map((category) {
        return _CategoryChipCard(
          label: category.label,
          icon: category.icon,
          selected: selectedCategory == category.label,
          onTap: () => onChanged(category.label),
        );
      }).toList(),
    );
  }
}

class _CategoryChipCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChipCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground =
        selected ? Colors.white : _AddNeedScreenState._primaryOrange;
    final textColor = selected ? Colors.white : AppColors.textDarkPrimary;

    return AnimatedScale(
      scale: selected ? 1.02 : 1,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: _AddNeedScreenState._primaryOrange.withAlpha(24),
          child: AnimatedContainer(
            width: 88,
            height: 84,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color:
                  selected ? _AddNeedScreenState._primaryOrange : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected
                    ? _AddNeedScreenState._primaryOrange
                    : _AddNeedScreenState._borderGray,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(selected ? 18 : 10),
                  blurRadius: selected ? 18 : 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withAlpha(34)
                        : _AddNeedScreenState._primaryOrange.withAlpha(22),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: foreground, size: 19),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _AddNeedText.chip.copyWith(color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final List<Widget> children;

  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _AddNeedScreenState._borderGray),
        boxShadow: _softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _NeedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool requiredField;
  final int maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const _NeedTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.requiredField = true,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: _AddNeedText.fieldLabel),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          minLines: minLines,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          cursorColor: _AddNeedScreenState._primaryOrange,
          style: _AddNeedText.input,
          validator: (value) {
            if (!requiredField) return null;
            return value == null || value.trim().isEmpty
                ? 'هذا الحقل مطلوب'
                : null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: _AddNeedText.hint,
            errorStyle: _AddNeedText.error,
            prefixIcon: Icon(
              icon,
              color: _AddNeedScreenState._primaryOrange,
              size: 20,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
            filled: true,
            fillColor: Colors.white,
            constraints: BoxConstraints(minHeight: maxLines == 1 ? 56 : 116),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines == 1 ? 14 : 16,
            ),
            border: _inputBorder(_AddNeedScreenState._borderGray),
            enabledBorder: _inputBorder(_AddNeedScreenState._borderGray),
            focusedBorder: _inputBorder(
              _AddNeedScreenState._primaryOrange,
              width: 1.35,
            ),
            errorBorder: _inputBorder(AppColors.errorRed),
            focusedErrorBorder: _inputBorder(AppColors.errorRed, width: 1.35),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _PrioritySelector extends StatelessWidget {
  final String selectedPriority;
  final ValueChanged<String> onChanged;

  const _PrioritySelector({
    required this.selectedPriority,
    required this.onChanged,
  });

  static const _priorities = [
    _PriorityItem('urgent', 'عاجل'),
    _PriorityItem('medium', 'متوسط'),
    _PriorityItem('low', 'منخفض'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: _AddNeedScreenState._softGray,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _AddNeedScreenState._borderGray),
      ),
      child: Row(
        children: _priorities.map((priority) {
          final selected = selectedPriority == priority.value;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: _PrioritySegment(
                label: priority.label,
                selected: selected,
                onTap: () => onChanged(priority.value),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PrioritySegment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PrioritySegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: _AddNeedScreenState._primaryOrange.withAlpha(24),
        child: AnimatedContainer(
          height: 44,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? _AddNeedScreenState._primaryOrange : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? _AddNeedScreenState._primaryOrange
                  : _AddNeedScreenState._borderGray,
            ),
          ),
          child: Text(
            label,
            style: _AddNeedText.segment.copyWith(
              color: selected ? Colors.white : AppColors.textDarkSecondary,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomSubmitBar extends StatelessWidget {
  final bool loading;
  final VoidCallback onSubmit;

  const _BottomSubmitBar({
    required this.loading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 18,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: loading ? null : onSubmit,
          icon: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.2,
                  ),
                )
              : const Icon(Icons.send_rounded, size: 19),
          label: Text(loading ? 'جار النشر...' : 'نشر الاحتياج'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _AddNeedScreenState._primaryOrange,
            foregroundColor: Colors.white,
            disabledBackgroundColor:
                _AddNeedScreenState._primaryOrange.withAlpha(150),
            elevation: 0,
            shadowColor: Colors.transparent,
            textStyle: _AddNeedText.button,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryItem {
  final String label;
  final IconData icon;

  const _CategoryItem(this.label, this.icon);
}

class _PriorityItem {
  final String value;
  final String label;

  const _PriorityItem(this.value, this.label);
}

const List<BoxShadow> _softShadow = [
  BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 18,
    offset: Offset(0, 8),
  ),
];

class _AddNeedText {
  static const TextStyle title = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle fieldLabel = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkPrimary,
    fontSize: 13.5,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle input = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle hint = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkMuted,
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle chip = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 12.5,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle segment = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 13,
  );

  static const TextStyle button = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle error = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.errorRed,
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
  );

  const _AddNeedText._();
}
