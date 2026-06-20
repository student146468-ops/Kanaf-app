import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class ExploreOrphanagesScreen extends StatefulWidget {
  const ExploreOrphanagesScreen({super.key});

  @override
  State<ExploreOrphanagesScreen> createState() => _ExploreOrphanagesScreenState();
}

class _ExploreOrphanagesScreenState extends State<ExploreOrphanagesScreen> {
  String _selectedCity = 'غريان';
  final List<String> _cities = ['غريان', 'طرابلس', 'بنغازي', 'مصراتة', 'الزاوية'];

  final List<Map<String, dynamic>> _orphanages = [
    {
      'name': 'دار الأمان لرعاية الأيتام بغريان',
      'location': 'غريان - وسط المدينة',
      'childrenCount': 35,
      'image': '🏢',
      'rating': 4.9,
      'needsCount': 3,
    },
    {
      'name': 'مؤسسة كنف الطفولة الإنسانية',
      'location': 'غريان - الهيرة',
      'childrenCount': 22,
      'image': '🏡',
      'rating': 4.8,
      'needsCount': 5,
    },
    {
      'name': 'جمعية غريان الخيرية للأطفال',
      'location': 'غريان - القواسم',
      'childrenCount': 18,
      'image': '🏰',
      'rating': 4.7,
      'needsCount': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'استكشاف دور الرعاية',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 شريط البحث الزجاجي التفاعلي المربوط بالصفحة التالية
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/search_filter_results'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, color: AppColors.brandOrange.withOpacity(0.8), size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'ابحث عن دار رعاية أو احتياج معين...',
                        style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withOpacity(0.4), fontSize: 14),
                      ),
                      const Spacer(),
                      Icon(Icons.tune_rounded, color: AppColors.brandOrange.withOpacity(0.8), size: 22),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // 🗺️ عنوان الفرز الجغرافي بالأيقونات ثلاثية الأبعاد الرمزية
              const Text(
                '📍 استكشاف حسب المدينة',
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 14),

              // قائمة المدن الأفقية المنسابة
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _cities.length,
                  itemBuilder: (context, index) {
                    final isSelected = _cities[index] == _selectedCity;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCity = _cities[index]),
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.brandOrange.withOpacity(0.15) : Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected ? AppColors.brandOrange : Colors.white.withOpacity(0.08),
                            width: 1.2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _cities[index],
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColors.brandOrange : Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),

              // 🏢 عنوان القائمة الرئيسية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'المؤسسات المسجلة في $_selectedCity',
                    style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    '(${_orphanages.length}) دار رعاية',
                    style: const TextStyle(fontFamily: 'Cairo', color: AppColors.brandOrange, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // قائمة دور الرعاية ذات التصميم الزجاجي الفخم
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _orphanages.length,
                itemBuilder: (context, index) {
                  final item = _orphanages[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // مجسم الأيقونة ثلاثية الأبعاد الافتراضية للدار
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: AppColors.brandOrangeDark.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: AppColors.brandOrange.withOpacity(0.2), width: 1),
                                ),
                                child: Center(
                                  child: Text(item['image'], style: const TextStyle(fontSize: 32)),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // تفاصيل الدار الموزعة بشكل مريح ومنظم
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['location'],
                                      style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withOpacity(0.5), fontSize: 12),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0F9D58).withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '👶 ${item['childrenCount']} طفلًا',
                                            style: const TextStyle(fontFamily: 'Cairo', color: Color(0xFF0F9D58), fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.brandOrange.withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '⚠️ ${item['needsCount']} احتياجات نشطة',
                                            style: const TextStyle(fontFamily: 'Cairo', color: AppColors.brandOrange, fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}