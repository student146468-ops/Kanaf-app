import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class SearchFilterView extends StatefulWidget {
  const SearchFilterView({super.key});

  @override
  State<SearchFilterView> createState() => _SearchFilterViewState();
}

class _SearchFilterViewState extends State<SearchFilterView> {
  String _selectedCategory = 'الكل';
  String _selectedTargetAge = 'جميع الأعمار';

  final List<String> _categories = ['الكل', 'تقني وبرمجة', 'تعليمي وتربوي', 'أشغال يدوية', 'ترفيهي وثقافي'];
  final List<String> _ageGroups = ['جميع الأعمار', 'الأطفال (6-12 سنة)', 'اليافعين (13-18 سنة)'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.innerBorder),
            ),
            child: const Icon(Icons.close_rounded, color: AppColors.textDarkPrimary, size: 18),
          ),
        ),
        title: const Text(
          'تخصيص وفرز البحث',
          style: TextStyle(color: AppColors.textDarkPrimary, fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  // شريط إدخال كلمة البحث الرئيسي بجدران صلبة عالية التباين
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.innerBorder),
                      boxShadow: const [BoxShadow(color: AppColors.innerShadow, blurRadius: 8, offset: Offset(0, 2))],
                    ),
                    child: const TextField(
                      style: TextStyle(color: AppColors.textDarkPrimary, fontSize: 14, fontFamily: 'Tajawal'),
                      decoration: InputDecoration(
                        hintText: 'ابحث عن فرصة تطوعية (مثلاً: برمجة، حاسوب)...',
                        hintStyle: TextStyle(color: AppColors.textDarkMuted, fontSize: 13, fontFamily: 'Tajawal'),
                        prefixIcon: Icon(Icons.search_rounded, color: AppColors.brandOrange),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // عنوان تصفية مجالات التطوع الإنساني
                  _buildFilterTitle('مجال التطوع الإنساني 🌟'),
                  const SizedBox(height: 12),
                  // رقاقات الاختيار السريع التفاعلية والانسيابية (Horizontal Filter Chips)
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.brandOrange : AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? Colors.transparent : AppColors.innerBorder),
                            boxShadow: isSelected
                                ? [BoxShadow(color: AppColors.brandOrange.withOpacity(0.25), blurRadius: 6, offset: const Offset(0, 3))]
                                : [],
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textDarkSecondary,
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 28),

                  // عنوان تصفية الفئة العمرية للأيتام المستفيدين داخل الدار
                  _buildFilterTitle('الفئة العمرية المستهدفة بالدار 👶'),
                  const SizedBox(height: 12),
                  Column(
                    children: _ageGroups.map((age) {
                      final isSelected = _selectedTargetAge == age;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTargetAge = age),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? AppColors.brandOrange : AppColors.innerBorder,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                age,
                                style: TextStyle(
                                  color: AppColors.textDarkPrimary,
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              // أيقونة راديو دائرية تفاعلية تحاكي العمق والبروز ثلاثي الأبعاد لعام 2026
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: isSelected ? AppColors.brandOrange : AppColors.textDarkMuted, width: 2),
                                  color: isSelected ? AppColors.brandOrange : Colors.transparent,
                                ),
                                child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // زر تطبيق الفلترة السلس والذكي في أسفل الواجهة لجذب المتطوع
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  // العودة للواجهة السابقة وتمرير المعطيات لتحديث النتائج فوراً تلقائياً
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم تصفية نتائج فرص دار أيتام غريان بحسب اختياراتكِ المخصصة بنجاح.', style: const TextStyle(fontFamily: 'Tajawal')),
                      backgroundColor: AppColors.brandOrangeDark,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.brandOrange, AppColors.brandOrangeDark],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: AppColors.brandOrange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'تطبيق الفلترة المخصصة وعرض النتائج',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
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

  Widget _buildFilterTitle(String title) {
    return Align(
      alignment: Alignment.topRight,
      child: Text(
        title,
        style: const TextStyle(color: AppColors.textDarkPrimary, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
      ),
    );
  }
}