import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

/// [AddNeedScreen] - الواجهة رقم 28: نموذج إضافة احتياج جديد لدار الرعاية لعام 2026.
/// مصمم بالكامل لتوفير تجربة مستخدم سلسة ومبهرة خالية من التعقيد والتشتت.
class AddNeedScreen extends StatefulWidget {
  const AddNeedScreen({super.key});

  @override
  State<AddNeedScreen> createState() => _AddNeedScreenState();
}

class _AddNeedScreenState extends State<AddNeedScreen> {
  final _titleController = TextEditingController();
  final _quantityController = TextEditingController();
  final _detailsController = TextEditingController();
  
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _quantityFocusNode = FocusNode();
  final FocusNode _detailsFocusNode = FocusNode();

  String _selectedCategory = 'غذائي';
  String _priorityLevel = 'متوسط'; // منخفض، متوسط، حرج جداً
  bool _issubmitting = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'غذائي', 'icon': Icons.bakery_dining_rounded, 'color': Colors.amber},
    {'name': 'طبي', 'icon': Icons.health_and_safety_rounded, 'color': Colors.redAccent},
    {'name': 'كسوة', 'icon': Icons.checkroom_rounded, 'color': Colors.tealAccent},
    {'name': 'تعليمي', 'icon': Icons.school_rounded, 'color': Colors.blueAccent},
  ];

  @override
  void initState() {
    super.initState();
    _titleFocusNode.addListener(() => setState(() {}));
    _quantityFocusNode.addListener(() => setState(() {}));
    _detailsFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    _detailsController.dispose();
    _titleFocusNode.dispose();
    _quantityFocusNode.dispose();
    _detailsFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitNeed() async {
    if (_titleController.text.isEmpty || _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء ملء الحقول الأساسية لوصف الاحتياج', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.brandOrange,
        ),
      );
      return;
    }

    setState(() => _issubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1500)); // محاكاة الرفع البرمجي للسيرفر
    
    if (mounted) {
      setState(() => _issubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نشر الاحتياج بنجاح في نظام كَنَفْ وجاري تنبيه المتبرعين', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Color(0xFF10B981), // استخدام القيمة اللونية الصافية بدلاً من السمة المفقودة
        ),
      );
      Navigator.of(context).pop(); // العودة التلقائية للوحة التحكم
    }
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
                // الخلفية الجمالية الموحدة للتطبيق
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
                          Colors.black.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),
                ),

                // المحتوى الهيكلي للنموذج
                SafeArea(
                  child: Column(
                    children: [
                      _buildAppBar(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              _buildSectionLabel('تصنيف الاحتياج الحالي'),
                              const SizedBox(height: 12),
                              _buildCategorySelector(),
                              const SizedBox(height: 24),
                              _buildSectionLabel('بيانات طلب الكفالة'),
                              const SizedBox(height: 14),
                              _buildGlassField(
                                controller: _titleController,
                                focusNode: _titleFocusNode,
                                hint: 'عنوان الاحتياج (مثال: أحذية شتوية للأطفال)',
                                icon: Icons.title_rounded,
                              ),
                              const SizedBox(height: 16),
                              _buildGlassField(
                                controller: _quantityController,
                                focusNode: _quantityFocusNode,
                                hint: 'الكمية أو العدد المطلوب (مثال: 25 طقم)',
                                icon: Icons.production_quantity_limits_rounded,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 16),
                              _buildGlassField(
                                controller: _detailsController,
                                focusNode: _detailsFocusNode,
                                hint: 'تفاصيل إضافية أو مقاسات خاصة لمساعدة المتبرع...',
                                icon: Icons.description_rounded,
                                maxLines: 4,
                              ),
                              const SizedBox(height: 24),
                              _buildSectionLabel('مستوى أولوية الاحتياج في الدار'),
                              const SizedBox(height: 12),
                              _buildPrioritySelector(),
                              const SizedBox(height: 40),
                              _buildSubmitButton(),
                              const SizedBox(height: 24),
                            ],
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
          const Expanded(
            child: Center(
              child: Text(
                'إضافة احتياج جديد',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.glassTextPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 40), // موازن بصري لضبط السنترة
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.glassTextPrimary,
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat['name'];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat['name']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.brandOrange.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? AppColors.brandOrange : Colors.white.withOpacity(0.15),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Icon(cat['icon'], color: isSelected ? AppColors.brandOrange : Colors.white70, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    cat['name'],
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? AppColors.brandOrange : AppColors.glassTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlassField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final bool isFocused = focusNode.hasFocus;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFocused ? AppColors.brandOrange : Colors.white.withOpacity(0.15),
          width: isFocused ? 1.5 : 1.0,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        keyboardType: keyboardType,
        cursorColor: AppColors.brandOrange,
        style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, color: AppColors.glassTextPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: AppColors.glassTextSecondary),
          prefixIcon: Padding(
            padding: EdgeInsets.only(bottom: maxLines > 1 ? 60 : 0),
            key: const ValueKey('icon_prefix'),
            child: Icon(icon, color: isFocused ? AppColors.brandOrange : Colors.white60, size: 20),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    final priorities = ['منخفض', 'متوسط', 'حرج جداً'];
    return Row(
      children: priorities.map((p) {
        final isSelected = _priorityLevel == p;
        Color pColor = Colors.white38;
        if (isSelected) {
          if (p == 'منخفض') pColor = const Color(0xFF10B981);
          if (p == 'متوسط') pColor = Colors.orange;
          if (p == 'حرج جداً') pColor = Colors.red;
        }

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _priorityLevel = p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? pColor.withOpacity(0.15) : Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? pColor : Colors.white.withOpacity(0.08),
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Center(
                child: Text(
                  p,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? pColor : AppColors.glassTextSecondary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _issubmitting ? null : _submitNeed,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.glassBtnActive,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandOrangeDark.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: _issubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandOrange)),
                )
              : const Text(
                  'نشر الاحتياج الفوري',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandOrangeDark,
                  ),
                ),
        ),
      ),
    );
  }
}
