import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class VisitHoursScreen extends StatefulWidget {
  const VisitHoursScreen({super.key});

  @override
  State<VisitHoursScreen> createState() => _VisitHoursScreenState();
}

class _VisitHoursScreenState extends State<VisitHoursScreen> {
  final _formKey = GlobalKey<FormState>();
  final _visitorNameController = TextEditingController();
  final _purposeController = TextEditingController();

  String _selectedSlot = '10:00 ص - 12:00 م';
  String _visitorType = 'كفيل / متبرع';

  // TODO: Replace mock slots with backend visit-hour settings when available.
  final List<Map<String, dynamic>> _visitingSlots = [
    {
      'time': '09:00 ص - 11:00 ص',
      'status': 'مكتمل',
      'icon': Icons.block_outlined,
      'color': AppColors.errorRed,
    },
    {
      'time': '10:00 ص - 12:00 م',
      'status': 'متاح',
      'icon': Icons.check_circle_outline_rounded,
      'color': const Color(0xFF10B981),
    },
    {
      'time': '04:00 م - 06:00 م',
      'status': 'متاح',
      'icon': Icons.check_circle_outline_rounded,
      'color': const Color(0xFF10B981),
    },
    {
      'time': '06:00 م - 08:00 م',
      'status': 'قيد التنفيذ',
      'icon': Icons.schedule_outlined,
      'color': Colors.amber,
    },
  ];

  final List<String> _visitorTypes = [
    'كفيل / متبرع',
    'مؤسسة خيرية',
    'جهة رقابية',
    'عائلة زائرة',
  ];

  @override
  void dispose() {
    _visitorNameController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: Container(
            width: isWebOrDesktop ? 430 : double.infinity,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              boxShadow: isWebOrDesktop
                  ? [
                      BoxShadow(
                        color: AppColors.innerShadow,
                        blurRadius: 24,
                        spreadRadius: 0,
                      )
                    ]
                  : [],
            ),
            child: Stack(
              children: [
                const Positioned.fill(child: _CareHomeBackground()),
                SafeArea(
                  child: Column(
                    children: [
                      _HeaderBar(
                        title: 'مواعيد الزيارة',
                        onBack: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _InfoRuleCard(),
                                const SizedBox(height: 20),
                                const _SectionTitle('الفترات المتاحة اليوم'),
                                const SizedBox(height: 12),
                                _TimeSlotsList(
                                  slots: _visitingSlots,
                                  selectedSlot: _selectedSlot,
                                  onSelect: _selectSlot,
                                ),
                                const SizedBox(height: 20),
                                const _SectionTitle('بيانات الزائر'),
                                const SizedBox(height: 10),
                                _InputField(
                                  controller: _visitorNameController,
                                  hint: 'اسم الزائر أو المؤسسة',
                                  icon: Icons.person_outline_rounded,
                                ),
                                const SizedBox(height: 14),
                                _VisitorTypeDropdown(
                                  value: _visitorType,
                                  items: _visitorTypes,
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _visitorType = value);
                                    }
                                  },
                                ),
                                const SizedBox(height: 14),
                                _InputField(
                                  controller: _purposeController,
                                  hint: 'الغرض من الزيارة',
                                  icon: Icons.assignment_outlined,
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 28),
                                _SubmitButton(onTap: _submitVisit),
                              ],
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

  void _selectSlot(Map<String, dynamic> slot) {
    if (slot['status'] == 'متاح') {
      setState(() => _selectedSlot = slot['time']);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'هذه الفترة ${slot['status']} حاليًا. اختر فترة متاحة.',
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: AppColors.errorRed,
      ),
    );
  }

  void _submitVisit() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم اعتماد موعد الزيارة خلال فترة $_selectedSlot',
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
    Navigator.of(context).pop();
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

  const _HeaderBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _CircleButton(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
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
          const SizedBox(width: 42),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

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

class _InfoRuleCard extends StatelessWidget {
  const _InfoRuleCard();

  @override
  Widget build(BuildContext context) {
    return CareHomeCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.brandOrange.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline_rounded,
                color: AppColors.brandOrange, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'مدة الزيارة الواحدة ساعتان للحفاظ على راحة الأطفال وتنظيم جدول الدار.',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 13,
                color: AppColors.textDarkSecondary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: AppColors.textDarkPrimary,
      ),
    );
  }
}

class _TimeSlotsList extends StatelessWidget {
  final List<Map<String, dynamic>> slots;
  final String selectedSlot;
  final ValueChanged<Map<String, dynamic>> onSelect;

  const _TimeSlotsList({
    required this.slots,
    required this.selectedSlot,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: slots.map((slot) {
        final isAvailable = slot['status'] == 'متاح';
        final isSelected = selectedSlot == slot['time'] && isAvailable;
        final color = slot['color'] as Color;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => onSelect(slot),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF10B981).withOpacity(0.12)
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF10B981)
                      : AppColors.innerBorder,
                  width: isSelected ? 1.4 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(slot['icon'], color: color, size: 19),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      slot['time'],
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDarkPrimary,
                      ),
                    ),
                  ),
                  _StatusPill(label: slot['status'], color: color),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontFamily: 'Tajawal',
        fontSize: 14,
        color: AppColors.textDarkPrimary,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.brandOrange, size: 20),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 13,
          color: AppColors.textDarkMuted,
        ),
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: _border(AppColors.innerBorder),
        enabledBorder: _border(AppColors.innerBorder),
        focusedBorder: _border(AppColors.brandOrange),
        errorBorder: _border(AppColors.errorRed),
        focusedErrorBorder: _border(AppColors.errorRed),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color),
    );
  }
}

class _VisitorTypeDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _VisitorTypeDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CareHomeCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.brandOrange, size: 20),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(16),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                  color: AppColors.textDarkPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SubmitButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.brandOrange,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandOrange.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'اعتماد موعد الزيارة',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
