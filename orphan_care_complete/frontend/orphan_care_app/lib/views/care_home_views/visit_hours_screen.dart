import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_container.dart';

/// [VisitHoursScreen] - الواجهة رقم 36: تنظيم وحجز ساعات الزيارة لدار الرعاية لعام 2026.
/// تتيح للمشرفين والمتبرعين تنسيق مواعيد الزيارات الميدانية واختيار الفترات الزمنية المتاحة لمنع الازدحام والتشتت.
class VisitHoursScreen extends StatefulWidget {
  const VisitHoursScreen({super.key});

  @override
  State<VisitHoursScreen> createState() => _VisitHoursScreenState();
}

class _VisitHoursScreenState extends State<VisitHoursScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _visitorNameController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  
  String _selectedSlot = '10:00 ص - 12:00 م'; // الفترة المختارة افتراضياً
  String _visitorType = 'كفيل / متبرع'; // نوع الزائر الافتراضي

  // فترات الزيارة المتاحة والمحاكة بدقة لعرضها أمام لجنة التحكيم والمناقشين
  final List<Map<String, dynamic>> _visitingSlots = [
    {'time': '09:00 ص - 11:00 ص', 'status': 'ممتلئة', 'icon': Icons.block_rounded, 'color': Colors.redAccent},
    {'time': '10:00 ص - 12:00 م', 'status': 'متاحة', 'icon': Icons.check_circle_outline_rounded, 'color': const Color(0xFF10B981)},
    {'time': '04:00 م - 06:00 م', 'status': 'متاحة', 'icon': Icons.check_circle_outline_rounded, 'color': const Color(0xFF10B981)},
    {'time': '06:00 م - 08:00 م', 'status': 'محجوزة مؤقتاً', 'icon': Icons.hourglass_empty_rounded, 'color': Colors.amber},
  ];

  final List<String> _visitorTypes = ['كفيل / متبرع', 'مؤسسة خيرية', 'جهة رقابية ودورية', 'عائلة زائرة'];

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
    final containerWidth = isWebOrDesktop ? 420.0 : double.infinity;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF131313),
        body: Center(
          child: Container(
            width: containerWidth,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: isWebOrDesktop
                  ? [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 45, spreadRadius: 8)]
                  : [],
            ),
            child: Stack(
              children: [
                // الخلفية الكريستالية النيونية الحية المستقرة لتطبيق كَنَفْ
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFF261611),
                          Color(0xFF141416),
                          Color(0xFF0D1117),
                        ],
                        stops: [0.0, 0.52, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.93),
                        ],
                      ),
                    ),
                  ),
                ),

                // محتوى تنظيم الزيارات الموزع باحترافية تامة لإراحة العين ومنع التشتت
                SafeArea(
                  child: Column(
                    children: [
                      _buildAppBar(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRuleCard(),
                                const SizedBox(height: 24),
                                _buildSectionTitle('الفترات الزمنية المتاحة اليوم لفرع غريان'),
                                const SizedBox(height: 12),
                                _buildTimeSlotsGrid(),
                                const SizedBox(height: 24),
                                _buildSectionTitle('اسم الزائر / الجهة القاصدة'),
                                const SizedBox(height: 8),
                                _buildGlassInputField(
                                  controller: _visitorNameController,
                                  hint: 'اكتبي الاسم الكامل للزائر أو المؤسسة...',
                                  icon: Icons.person_outline_rounded,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildSectionTitle('تصنيف فئة الزائر'),
                                          const SizedBox(height: 8),
                                          _buildGlassDropdown(_visitorType, _visitorTypes, (value) {
                                            if (value != null) setState(() => _visitorType = value);
                                          }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                _buildSectionTitle('الغرض اللوجستي أو التربوي من الزيارة'),
                                const SizedBox(height: 8),
                                _buildGlassInputField(
                                  controller: _purposeController,
                                  hint: 'مثال: تقديم هدايا عينية، تفقد حالة صحية، تنسيق مبادرة...',
                                  icon: Icons.assignment_outlined,
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 35),
                                _buildSubmitButton(),
                                const SizedBox(height: 25),
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            ),
          ),
          const Text(
            'جدولة تنظيم الزيارات',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.glassTextPrimary,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildInfoRuleCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.brandOrange.withOpacity(0.15), shape: BoxShape.circle),
            child: const Icon(Icons.gavel_rounded, color: AppColors.brandOrange, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'الحد الأقصى للزيارة الواحدة هو ساعتان لضمان راحة الأيتام وعدم خرق جدولهم التعليمي والتربوي المعتمد.',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11.5,
                color: AppColors.glassTextSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotsGrid() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _visitingSlots.length,
      itemBuilder: (context, index) {
        final slot = _visitingSlots[index];
        final bool isAvailable = slot['status'] == 'متاحة';
        final bool isSelected = _selectedSlot == slot['time'] && isAvailable;

        return GestureDetector(
          onTap: () {
            if (isAvailable) {
              setState(() => _selectedSlot = slot['time']);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('هذه الفترة ${slot['status']} حالياً، يرجى اختيار فترة متاحة.', style: const TextStyle(fontFamily: 'Cairo')),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isSelected 
                  ? const Color(0xFF10B981).withOpacity(0.12) 
                  : isAvailable ? Colors.white.withOpacity(0.04) : Colors.white.withOpacity(0.01),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                    ? const Color(0xFF10B981) 
                    : isAvailable ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.03),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(slot['icon'], color: isSelected ? const Color(0xFF10B981) : slot['color'].withOpacity(0.7), size: 18),
                      const SizedBox(width: 12),
                      Text(
                        slot['time'],
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isAvailable ? Colors.white : Colors.white38,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: slot['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      slot['status'],
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: slot['color'],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: AppColors.brandOrange.withOpacity(0.7), size: 18),
          hintText: hint,
          hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: Colors.white30),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'هذا الحقل ضروري لتنظيم السجلات الأمنية والتربوية';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGlassDropdown(String currentValue, List<String> items, ValueChanged<String?> onChanged) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, color: Colors.black87),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.brandOrange, size: 20),
          dropdownColor: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          // محاكاة تأكيد الحجز وإظهار صندوق التأكيد النيوني المبهج والمستقر
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم جدولة وحجز موعد الزيارة بنجاح خلال فترة $_selectedSlot 🗓️', style: const TextStyle(fontFamily: 'Cairo')),
              backgroundColor: const Color(0xFF10B981), // الزمردي الخالي من الأخطاء برمجياً
            ),
          );
          Navigator.of(context).pop(); // العودة التلقائية للوحة التحكم الرئيسية المربوطة بها
        }
      },
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.glassBtnActive,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: AppColors.brandOrange.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 4)),
          ],
        ),
        child: const Center(
          child: Text(
            'تأكيد واعتماد موعد الزيارة',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.brandOrangeDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13.5,
        fontWeight: FontWeight.w800,
        color: AppColors.glassTextPrimary,
      ),
    );
  }
}
