import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class SearchFilterResultsScreen extends StatefulWidget {
  const SearchFilterResultsScreen({super.key});

  @override
  State<SearchFilterResultsScreen> createState() => _SearchFilterResultsScreenState();
}

class _SearchFilterResultsScreenState extends State<SearchFilterResultsScreen> {
  final TextEditingController _searchController = TextEditingController(text: 'كسوة شتوية');
  
  final List<Map<String, dynamic>> _filteredResults = [
    {
      'title': 'تأمين الكسوة الشتوية لـ 25 طفلاً',
      'orphanage': 'دار الأيتام الرئيسية بغريان',
      'category': 'تبرع عيني',
      'progress': 0.34,
      'remaining': '2,300 د.ل',
      'icon': '🧥'
    },
    {
      'title': 'حملة الأغطية الدافئة والمستلزمات',
      'orphanage': 'مؤسسة كنف الطفولة الإنسانية',
      'category': 'تبرع مالي',
      'progress': 0.75,
      'remaining': '800 د.ل',
      'icon': '🛏️'
    }
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
          title: const Text('نتائج الفلترة المتقدمة', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // حقل إدخال النص مع زر التصفية
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.2),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(fontFamily: 'Cairo', color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'ابحث عن احتياج...',
                          hintStyle: TextStyle(fontFamily: 'Cairo', color: Colors.white.withOpacity(0.3)),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.brandOrange),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // زر تصفية دائري فخم ومشع
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: AppColors.brandOrange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.brandOrange, width: 1.2),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune_rounded, color: AppColors.brandOrange),
                      onPressed: () {
                        // مكان تفاعلي لفتح Bottom Sheet للفلترة لاحقاً
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // شرائح التصفية النشطة (Active Filter Tags)
              Row(
                children: [
                  _buildFilterTag('النوع: كساوى', true),
                  const SizedBox(width: 8),
                  _buildFilterTag('المدينة: غريان', true),
                ],
              ),
              const SizedBox(height: 25),

              Text(
                'نتائج البحث المطابقة (${_filteredResults.length})',
                style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),

              // قائمة كروت النتائج المتقدمة
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filteredResults.length,
                  itemBuilder: (context, index) {
                    final result = _filteredResults[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.06), width: 1.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(result['icon'], style: const TextStyle(fontSize: 24)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        result['title'],
                                        style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        result['orphanage'],
                                        style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withOpacity(0.5), fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.brandOrange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    result['category'],
                                    style: const TextStyle(fontFamily: 'Cairo', color: AppColors.brandOrange, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            // شريط التقدم الدقيق الفخم للحملة
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: result['progress'],
                                backgroundColor: Colors.white.withOpacity(0.08),
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brandOrange),
                                minHeight: 6,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'المتبقي: ${result['remaining']}',
                                  style: TextStyle(fontFamily: 'Cairo', color: Colors.white.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${(result['progress'] * 100).toInt()}%',
                                  style: const TextStyle(fontFamily: 'Cairo', color: AppColors.brandOrange, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTag(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.brandOrange.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isActive ? AppColors.brandOrange : Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontFamily: 'Cairo', color: isActive ? AppColors.brandOrange : Colors.white70, fontSize: 12)),
          const SizedBox(width: 6),
          Icon(Icons.close_rounded, size: 14, color: isActive ? AppColors.brandOrange : Colors.white60),
        ],
      ),
    );
  }
}
