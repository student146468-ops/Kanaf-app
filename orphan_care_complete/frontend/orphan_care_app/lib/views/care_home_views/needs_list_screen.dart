import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

/// [NeedsListScreen] - ط§ظ„ظˆط§ط¬ظ‡ط© ط±ظ‚ظ… 29: ظ‚ط§ط¦ظ…ط© ط§ظ„ط§ط­طھظٹط§ط¬ط§طھ ظ…ط¹ ط§ظ„ط£ظˆظ„ظˆظٹط© ظ„ط¯ط§ط± ط§ظ„ط±ط¹ط§ظٹط© ظ„ط¹ط§ظ… 2026.
/// طھط¹ط±ط¶ ظƒط§ظپط© ط§ظ„ط·ظ„ط¨ط§طھ ط§ظ„ظ…ظ†ط´ظˆط±ط© ظ…ط¹ طھطµظپظٹط© ط°ظƒظٹط© ظˆط£ظ„ظˆط§ظ† ط¯ظ„ط§ظ„ظٹط© ظ„ظ„ط£ظˆظ„ظˆظٹط§طھ طھظ…ظ†ط¹ ط§ظ„طھط´طھطھ ط§ظ„ط¨طµط±ظٹ.
class NeedsListScreen extends StatefulWidget {
  const NeedsListScreen({super.key});

  @override
  State<NeedsListScreen> createState() => _NeedsListScreenState();
}

class _NeedsListScreenState extends State<NeedsListScreen> {
  String _activeFilter = 'الكل';

  // TODO: Replace mock needs with AppProvider/backend needs when available.
  final List<Map<String, dynamic>> _allNeeds = [
    {
      'id': '1',
      'title': 'أدوية ومستلزمات طبية للأطفال',
      'category': 'طبي',
      'quantity': '15 طقم متكامل',
      'priority': 'عاجل',
      'status': 'قيد التنفيذ',
      'icon': Icons.health_and_safety_rounded,
      'color': Colors.redAccent,
    },
    {
      'id': '2',
      'title': 'حليب أطفال ومكملات غذائية',
      'category': 'غذائي',
      'quantity': '40 صندوق',
      'priority': 'عاجل',
      'status': 'قيد التنفيذ',
      'icon': Icons.bakery_dining_rounded,
      'color': Colors.amber,
    },
    {
      'id': '3',
      'title': 'أحذية شتوية وملابس دافئة',
      'category': 'كسوة',
      'quantity': '25 زوج بمقاسات مختلفة',
      'priority': 'متوسط',
      'status': 'قيد التنفيذ',
      'icon': Icons.checkroom_rounded,
      'color': Colors.teal,
    },
    {
      'id': '4',
      'title': 'كتب وقرطاسية للعام الدراسي',
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
    final containerWidth = isWebOrDesktop ? 430.0 : double.infinity;

    // طھطµظپظٹط© ط§ظ„ط¹ظ†ط§طµط± ط¨ظ†ط§ط،ظ‹ ط¹ظ„ظ‰ ط§ظ„طھط¨ظˆظٹط¨ ط§ظ„ظ†ط´ط·
    final filteredNeeds = _allNeeds.where((need) {
      if (_activeFilter == 'الكل') return true;
      if (_activeFilter == 'قيد التنفيذ') {
        return need['status'] == 'قيد التنفيذ';
      }
      if (_activeFilter == 'مكتمل') return need['status'] == 'مكتمل';
      return true;
    }).toList();

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
                // ط®ظ„ظپظٹط© ط¨ظٹط¶ط§ط، ظ‡ط§ط¯ط¦ط©
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

                // ط§ظ„ظ…ط­طھظˆظ‰ ط§ظ„ظ‡ظٹظƒظ„ظٹ
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
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
                color: AppColors.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.innerBorder),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textDarkPrimary, size: 18),
            ),
          ),
          const Text(
            'احتياجات الدار',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDarkPrimary,
            ),
          ),
          // ط²ط± ط³ط±ظٹط¹ ظ„ظ„ط¥ط¶ط§ظپط© ظ„طھظˆظپظٹط± ط§ط®طھطµط§ط±ط§طھ ظ…ط±ظ†ط© ظˆطھط¬ط±ط¨ط© ظ…ط³طھط®ط¯ظ… ظ…ط±ظٹط­ط© ظ„ظ„ظ…ط´ط±ظپ
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/care_home_add_need'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.brandOrange.withOpacity(0.15),
                shape: BoxShape.circle,
                border:
                    Border.all(color: AppColors.brandOrange.withOpacity(0.4)),
              ),
              child: const Icon(Icons.add_rounded,
                  color: AppColors.brandOrange, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final tabs = ['الكل', 'قيد التنفيذ', 'مكتمل'];
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
                  color: isSelected
                      ? AppColors.brandOrange.withOpacity(0.2)
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.brandOrange
                        : AppColors.innerBorder,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected
                          ? AppColors.brandOrange
                          : AppColors.textDarkPrimary,
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
    Color priorityColor = const Color(
        0xFF10B981); // طھظ… ط§ط³طھط¨ط¯ط§ظ„ ط§ظ„ظ‚ظٹظ…ط© ط§ظ„طھظ„ظ‚ط§ط¦ظٹط© ط¨ظ„ظˆظ† ط£ط®ط¶ط± ط²ظ…ط±ط¯ظٹ ط«ط§ط¨طھ ظˆظ…ط·ط§ط¨ظ‚ ظ„ط±ظ…ظˆط² ط§ظ„ظ†ط¸ط§ظ…
    if (need['priority'] == 'متوسط') priorityColor = Colors.orange;
    if (need['priority'] == 'عاجل') priorityColor = Colors.redAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // âœ¨ ط±ط¨ط· ظ…ط¨ط§ط´ط± ظˆطھظ„ظ‚ط§ط¦ظٹ ط¨ظˆط§ط¬ظ‡ط© ط§ظ„طھظپط§طµظٹظ„ ظ…ط¹ طھظ…ط±ظٹط± ط§ظ„ظ€ ID ط§ظ„ظ…ط®طھط§ط±
          onTap: () => Navigator.of(context)
              .pushNamed('/care_home_need_details', arguments: need['id']),
          borderRadius: BorderRadius.circular(24),
          child: CareHomeCard(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // ط§ظ„ط£ظٹظ‚ظˆظ†ط© ط§ظ„ط¯ظ„ط§ظ„ظٹط© ط§ظ„ظ…طµظ…ظ…ط© ظ„ظپط±ط² ظ†ظˆط¹ ط§ظ„ط§ط­طھظٹط§ط¬
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: need['color'].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: need['color'].withOpacity(0.3), width: 1),
                  ),
                  child: Icon(need['icon'], color: need['color'], size: 22),
                ),
                const SizedBox(width: 14),

                // ط§ظ„ط¨ظٹط§ظ†ط§طھ ط§ظ„ظ†طµظٹط© ظˆط§ظ„طھظپط§طµظٹظ„ ط§ظ„ظ…ظ†ط³ظ‚ط© ظ…ط±ظٹط­ط§ظ‹ ظ„ظ„ظ†ط¸ط±
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: priorityColor.withOpacity(0.3),
                                  width: 1),
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
                            need['status'] == 'مكتمل' ? 'مكتمل' : 'قيد التنفيذ',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: need['status'] == 'مكتمل'
                                  ? const Color(0xFF10B981)
                                  : AppColors
                                      .textDarkMuted, // طھطµط­ظٹط­ Colors.emerald ظ‡ظ†ط§
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
                          color: AppColors.textDarkPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'الكمية المطلوبة: ${need['quantity']}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12.5,
                          color: AppColors.textDarkSecondary,
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: CareHomeCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined,
                  size: 52, color: AppColors.textDarkMuted.withOpacity(0.45)),
              const SizedBox(height: 12),
              const Text(
                'لا توجد احتياجات ضمن هذا التصنيف',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDarkPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'يمكنك تغيير التصفية أو إضافة احتياج جديد للدار.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                  color: AppColors.textDarkSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
