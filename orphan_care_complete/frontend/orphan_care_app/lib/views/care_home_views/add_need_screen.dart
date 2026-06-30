import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

/// [AddNeedScreen] - ط§ظ„ظˆط§ط¬ظ‡ط© ط±ظ‚ظ… 28: ظ†ظ…ظˆط°ط¬ ط¥ط¶ط§ظپط© ط§ط­طھظٹط§ط¬ ط¬ط¯ظٹط¯ ظ„ط¯ط§ط± ط§ظ„ط±ط¹ط§ظٹط© ظ„ط¹ط§ظ… 2026.
/// ظ…طµظ…ظ… ط¨ط§ظ„ظƒط§ظ…ظ„ ظ„طھظˆظپظٹط± طھط¬ط±ط¨ط© ظ…ط³طھط®ط¯ظ… ط³ظ„ط³ط© ظˆظ…ط¨ظ‡ط±ط© ط®ط§ظ„ظٹط© ظ…ظ† ط§ظ„طھط¹ظ‚ظٹط¯ ظˆط§ظ„طھط´طھطھ.
class AddNeedScreen extends StatefulWidget {
  const AddNeedScreen({super.key});

  @override
  State<AddNeedScreen> createState() => _AddNeedScreenState();
}

class _AddNeedScreenState extends State<AddNeedScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _quantityController = TextEditingController();
  final _detailsController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _quantityFocusNode = FocusNode();
  final FocusNode _detailsFocusNode = FocusNode();

  String _selectedCategory = 'غذائي';
  String _priorityLevel = 'متوسط';
  bool _issubmitting = false;

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'غذائي',
      'icon': Icons.bakery_dining_rounded,
      'color': Colors.amber
    },
    {
      'name': 'طبي',
      'icon': Icons.health_and_safety_rounded,
      'color': Colors.redAccent
    },
    {
      'name': 'كسوة',
      'icon': Icons.checkroom_rounded,
      'color': const Color(0xFF14B8A6)
    },
    {
      'name': 'تعليمي',
      'icon': Icons.school_rounded,
      'color': Colors.blueAccent
    },
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
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إكمال الحقول الأساسية لوصف الاحتياج',
              style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: AppColors.brandOrange,
        ),
      );
      return;
    }

    setState(() => _issubmitting = true);
    await Future.delayed(const Duration(
        milliseconds:
            1500)); // ظ…ط­ط§ظƒط§ط© ط§ظ„ط±ظپط¹ ط§ظ„ط¨ط±ظ…ط¬ظٹ ظ„ظ„ط³ظٹط±ظپط±

    if (mounted) {
      setState(() => _issubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'تم نشر الاحتياج بنجاح، وسيظهر للمتبرعين والمتطوعين المناسبين.',
              style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Color(
              0xFF10B981), // ط§ط³طھط®ط¯ط§ظ… ط§ظ„ظ‚ظٹظ…ط© ط§ظ„ظ„ظˆظ†ظٹط© ط§ظ„طµط§ظپظٹط© ط¨ط¯ظ„ط§ظ‹ ظ…ظ† ط§ظ„ط³ظ…ط© ط§ظ„ظ…ظپظ‚ظˆط¯ط©
        ),
      );
      Navigator.of(context)
          .pop(); // ط§ظ„ط¹ظˆط¯ط© ط§ظ„طھظ„ظ‚ط§ط¦ظٹط© ظ„ظ„ظˆط­ط© ط§ظ„طھط­ظƒظ…
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final containerWidth = isWebOrDesktop ? 430.0 : double.infinity;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: Container(
            width: containerWidth,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              boxShadow: isWebOrDesktop
                  ? [
                      BoxShadow(
                          color: AppColors.innerShadow,
                          blurRadius: 24,
                          spreadRadius: 0)
                    ]
                  : [],
            ),
            child: Stack(
              children: [
                // ط§ظ„ط®ظ„ظپظٹط© ط§ظ„ط¬ظ…ط§ظ„ظٹط© ط§ظ„ظ…ظˆط­ط¯ط© ظ„ظ„طھط·ط¨ظٹظ‚
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.white,
                          AppColors.scaffoldBackground,
                          AppColors.scaffoldBackground,
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
                          Colors.white,
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                ),

                // ط§ظ„ظ…ط­طھظˆظ‰ ط§ظ„ظ‡ظٹظƒظ„ظٹ ظ„ظ„ظ†ظ…ظˆط°ط¬
                SafeArea(
                  child: Column(
                    children: [
                      _buildAppBar(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 10.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                _buildSectionLabel('تصنيف الاحتياج'),
                                const SizedBox(height: 12),
                                _buildCategorySelector(),
                                const SizedBox(height: 24),
                                _buildSectionLabel('بيانات الاحتياج'),
                                const SizedBox(height: 14),
                                _buildInputField(
                                  controller: _titleController,
                                  focusNode: _titleFocusNode,
                                  hint:
                                      'عنوان الاحتياج، مثل: أحذية شتوية للأطفال',
                                  icon: Icons.title_rounded,
                                ),
                                const SizedBox(height: 16),
                                _buildInputField(
                                  controller: _quantityController,
                                  focusNode: _quantityFocusNode,
                                  hint: 'الكمية أو العدد المطلوب، مثل: 25 طقم',
                                  icon: Icons.numbers_rounded,
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 16),
                                _buildInputField(
                                  controller: _detailsController,
                                  focusNode: _detailsFocusNode,
                                  hint:
                                      'تفاصيل تساعد المتبرع: المقاسات، النوع، أو الأولوية...',
                                  icon: Icons.description_rounded,
                                  maxLines: 4,
                                ),
                                const SizedBox(height: 24),
                                _buildSectionLabel('مستوى أولوية الاحتياج'),
                                const SizedBox(height: 12),
                                _buildPrioritySelector(),
                                const SizedBox(height: 40),
                                _buildSubmitButton(),
                                const SizedBox(height: 24),
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
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.innerBorder),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textDarkPrimary, size: 18),
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
                  color: AppColors.textDarkPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(
              width: 40), // ظ…ظˆط§ط²ظ† ط¨طµط±ظٹ ظ„ط¶ط¨ط· ط§ظ„ط³ظ†طھط±ط©
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
        color: AppColors.textDarkPrimary,
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
                color: isSelected
                    ? AppColors.brandOrange.withOpacity(0.2)
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.brandOrange
                      : AppColors.innerBorder,
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Icon(cat['icon'],
                      color: isSelected
                          ? AppColors.brandOrange
                          : AppColors.textDarkSecondary,
                      size: 18),
                  const SizedBox(width: 8),
                  Text(
                    cat['name'],
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? AppColors.brandOrange
                          : AppColors.textDarkPrimary,
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

  Widget _buildInputField({
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
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFocused ? AppColors.brandOrange : AppColors.innerBorder,
          width: isFocused ? 1.5 : 1.0,
        ),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        keyboardType: keyboardType,
        cursorColor: AppColors.brandOrange,
        validator: (value) {
          if (controller == _detailsController) return null;
          if (value == null || value.trim().isEmpty) {
            return 'هذا الحقل مطلوب';
          }
          return null;
        },
        style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: AppColors.textDarkPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              color: AppColors.textDarkSecondary),
          prefixIcon: Padding(
            padding: EdgeInsets.only(bottom: maxLines > 1 ? 60 : 0),
            key: const ValueKey('icon_prefix'),
            child: Icon(icon,
                color:
                    isFocused ? AppColors.brandOrange : AppColors.textDarkMuted,
                size: 20),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    final priorities = ['منخفض', 'متوسط', 'عاجل'];
    return Row(
      children: priorities.map((p) {
        final isSelected = _priorityLevel == p;
        Color pColor = AppColors.textDarkMuted;
        if (isSelected) {
          if (p == 'منخفض') pColor = const Color(0xFF10B981);
          if (p == 'متوسط') pColor = Colors.orange;
          if (p == 'عاجل') pColor = Colors.red;
        }

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _priorityLevel = p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? pColor.withOpacity(0.15)
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? pColor : AppColors.cardBackground,
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
                    color: isSelected ? pColor : AppColors.textDarkSecondary,
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
          color: AppColors.brandOrange,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandOrange.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: _issubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                )
              : const Text(
                  'نشر الاحتياج',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
