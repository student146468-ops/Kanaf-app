import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_container.dart';

/// [NeedsListScreen] - الواجهة رقم 29: قائمة الاحتياجات مع الأولوية لدار الرعاية لعام 2026.
/// تعرض كافة الطلبات المنشورة مع تصفية ذكية وألوان دلالية للأولويات تمنع التشتت البصري.
class NeedsListScreen extends StatefulWidget {
  const NeedsListScreen({super.key});

  @override
  State<NeedsListScreen> createState() => _NeedsListScreenState();
}

class _NeedsListScreenState extends State<NeedsListScreen> {
  String _activeFilter = 'الكل'; // الكل، معلق، مكتمل

  // بيانات محاكاة تفصيلية ومقنعة للجنة المناقشة تعكس متطلبات دار رعاية حقيقية
  final List<Map<String, dynamic>> _allNeeds = [
    {
      'id': '1',
      'title': 'أدوية ومستلزمات طبية للأطفال',
      'category': 'طبي',
      'quantity': '15 طقم متكامل',
      'priority': 'حرج جداً',
      'status': 'معلق',
      'icon': Icons.health_and_safety_rounded,
      'color': Colors.redAccent,
    },
    {
      'id': '2',
      'title': 'حليب أطفال ومكملات غذائية (عمر 1-3)',
      'category': 'غذائي',
      'quantity': '40 صندوق',
      'priority': 'حرج جداً',
      'status': 'معلق',
      'icon': Icons.bakery_dining_rounded,
      'color': Colors.amber,
    },
    {
      'id': '3',
      'title': 'أحذية شتوية وملابس دافئة لسن الروضة',
      'category': 'كسوة',
      'quantity': '25 زوج مقاسات مختلفة',
      'priority': 'متوسط',
      'status': 'معلق',
      'icon': Icons.checkroom_rounded,
      'color': Colors.teal,
    },
    {
      'id': '4',
      'title': 'كتب وقرطاسية للعام الدراسي الجديد',
      'category': 'تعليمي',
      'quantity': '30 حقيبة مدرسية',
      'priority': 'منخفض',
      'status': 'مكتمل',
      'icon': Icons.school_rounded,
      'color': Colors.blueAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final containerWidth = isWebOrDesktop ? 420.0 : double.infinity;

    // تصفية العناصر بناءً على التبويب النشط
    final filteredNeeds = _allNeeds.where((need) {
      if (_activeFilter == 'الكل') return true;
      if (_activeFilter == 'معلق') return need['status'] == 'معلق';
      if (_activeFilter == 'مكتمل') return need['status'] == 'مكتمل';
      return true;
    }).toList();

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
                // الخلفية الكريستالية الحية
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
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ),

                // المحتوى الهيكلي
                SafeArea(
                  child: Column(
                    children: [
                      _buildAppBar(),
                      _buildFilterTabs(),
                      const SizedBox(height: 10),
                      Expanded(
                        child: filteredNeeds.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                itemCount: filteredNeeds.length,
                                itemBuilder: (context, index) {
                                  final need = filteredNeeds[index];
                                  return _buildNeedCard(need);
                                },
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
            'قائمة الاحتياجات الحالية',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.glassTextPrimary,
            ),
          ),
          // زر سريع للإضافة لتوفير اختصارات مرنة وتجربة مستخدم مريحة للمشرف
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/care_home_add_need'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.brandOrange.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.brandOrange.withOpacity(0.4)),
              ),
              child: const Icon(Icons.add_rounded, color: AppColors.brandOrange, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final tabs = ['الكل', 'معلق', 'مكتمل'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = _activeFilter == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeFilter = tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.brandOrange.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.brandOrange : Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? AppColors.brandOrange : AppColors.glassTextPrimary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNeedCard(Map<String, dynamic> need) {
    Color priorityColor = const Color(0xFF10B981); // تم استبدال القيمة التلقائية بلون أخضر زمردي ثابت ومطابق لرموز النظام
    if (need['priority'] == 'متوسط') priorityColor = Colors.orange;
    if (need['priority'] == 'حرج جداً') priorityColor = Colors.redAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // ✨ ربط مباشر وتلقائي بواجهة التفاصيل مع تمرير الـ ID المختار
          onTap: () => Navigator.of(context).pushNamed('/care_home_need_details', arguments: need['id']),
          borderRadius: BorderRadius.circular(24),
          child: GlassContainer(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // الأيقونة الدلالية المصممة لفرز نوع الاحتياج
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: need['color'].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: need['color'].withOpacity(0.3), width: 1),
                  ),
                  child: Icon(need['icon'], color: need['color'], size: 22),
                ),
                const SizedBox(width: 14),

                // البيانات النصية والتفاصيل المنسقة مريحاً للنظر
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: priorityColor.withOpacity(0.3), width: 1),
                            ),
                            child: Text(
                              need['priority'],
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: priorityColor,
                              ),
                            ),
                          ),
                          Text(
                            need['status'] == 'مكتمل' ? 'مكتمل ✅' : 'قيد الانتظار ⏳',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: need['status'] == 'مكتمل' ? const Color(0xFF10B981) : Colors.white60, // تصحيح Colors.emerald هنا
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        need['title'],
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.glassTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'الكمية المطلوبة: ${need['quantity']}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12.5,
                          color: AppColors.glassTextSecondary,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_rounded, size: 64, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            'لا توجد احتياجات تندرج تحت هذا التبويب حالياً',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: AppColors.glassTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
