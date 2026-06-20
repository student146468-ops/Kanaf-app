import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_container.dart';

/// [ManageVolunteersScreen] - الواجهة رقم 32: إدارة المتطوعين المقبولين لدار الرعاية لعام 2026.
/// تتيح للمشرفين تنظيم المهام، ومتابعة الحالات والتواصل الفوري مع الطاقم التطوعي النشط.
class ManageVolunteersScreen extends StatefulWidget {
  const ManageVolunteersScreen({super.key});

  @override
  State<ManageVolunteersScreen> createState() => _ManageVolunteersScreenState();
}

class _ManageVolunteersScreenState extends State<ManageVolunteersScreen> {
  String _selectedRoleFilter = 'الكل'; // الكل، تعليمي، ترفيهي، تنظيم

  // بيانات محاكاة دقيقة لمتطوعين حقيقيين بأسماء ومهمات ملائمة تماماً لطبيعة دور رعاية الأيتام
  final List<Map<String, dynamic>> _volunteers = [
    {
      'id': 'v1',
      'name': 'أحمد علي الساعدي',
      'role': 'تعليمي',
      'sub_role': 'مدرس لغة إنجليزية ودعم دراسي',
      'status': 'نشط اليوم',
      'status_color': const Color(0xFF10B981), // تم تصحيح اللون هنا
      'hours_contributed': '24 ساعة',
    },
    {
      'id': 'v2',
      'name': 'فاطمة عمر الخويلدي',
      'role': 'ترفيهي',
      'sub_role': 'أخصائية دعم نفسي وأنشطة أطفال',
      'status': 'مستعد',
      'status_color': Colors.blueAccent,
      'hours_contributed': '18 ساعة',
    },
    {
      'id': 'v3',
      'name': 'محمد فرج التير',
      'role': 'تنظيم',
      'sub_role': 'تنظيم وإشراف على الرحلات الخارجية',
      'status': 'نشط اليوم',
      'status_color': const Color(0xFF10B981), // تم تصحيح اللون هنا
      'hours_contributed': '32 ساعة',
    },
    {
      'id': 'v4',
      'name': 'سارة عبد الله مسعود',
      'role': 'تعليمي',
      'sub_role': 'تحفيظ قرآن كريم ومواد لغوية',
      'status': 'غير نشط',
      'status_color': Colors.white38,
      'hours_contributed': '12 ساعة',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final containerWidth = isWebOrDesktop ? 420.0 : double.infinity;

    // تصفية المتطوعين بناءً على الفلتر المختار لمنع التشتت
    final filteredVolunteers = _volunteers.where((v) {
      if (_selectedRoleFilter == 'الكل') return true;
      return v['role'] == _selectedRoleFilter;
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
                // الخلفية الزجاجية الموحدة والمستقرة لتطبيق كَنَفْ
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
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ),

                // هيكلية واجهة الإدارة والمحتوى
                SafeArea(
                  child: Column(
                    children: [
                      _buildAppBar(),
                      _buildFilterScroll(),
                      const SizedBox(height: 10),
                      Expanded(
                        child: filteredVolunteers.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                                itemCount: filteredVolunteers.length,
                                itemBuilder: (context, index) {
                                  final volunteer = filteredVolunteers[index];
                                  return _buildVolunteerCard(volunteer);
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
            'إدارة المتطوعين المقبولين',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.glassTextPrimary,
            ),
          ),
          // زر للانتقال الفوري لواجهة التقييم (واجهة 39) لربط العمليات ببعضها
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/care_home_rate_volunteers'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber.withOpacity(0.4)),
              ),
              child: const Icon(Icons.star_outline_rounded, color: Colors.amber, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterScroll() {
    final filters = ['الكل', 'تعليمي', 'ترفيهي', 'تنظيم'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedRoleFilter == f;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedRoleFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 38,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.brandOrange.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.brandOrange : Colors.white.withOpacity(0.08),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    f,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12.5,
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

  Widget _buildVolunteerCard(Map<String, dynamic> volunteer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة رمزية للمتطوع بلمسة زجاجية دائرية فخمة
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.brandOrange.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.5),
                  ),
                  child: const Icon(Icons.person_outline_rounded, color: AppColors.brandOrange, size: 24),
                ),
                const SizedBox(width: 14),

                // تفاصيل الهوية والمهمة التخصصية للمتطوع
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            volunteer['name'],
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.glassTextPrimary,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(color: volunteer['status_color'], shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                volunteer['status'],
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: volunteer['status_color'],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        volunteer['sub_role'],
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppColors.glassTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time_filled_rounded, color: Colors.white.withOpacity(0.3), size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'إجمالي العطاء الكلي: ${volunteer['hours_contributed']}',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white12, height: 20),
            // أزرار التحكم السريع والتواصل الفوري والتنسيق اللوجستي
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCardActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'تنبيه فوري',
                  color: Colors.white70,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم إرسال إشعار للمتطوع ${volunteer['name']} لتذكيره بالموعد', style: const TextStyle(fontFamily: 'Cairo')),
                        backgroundColor: AppColors.brandOrange, // تم معالجة الـ const هنا
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildCardActionButton(
                  icon: Icons.phone_in_talk_rounded,
                  label: 'اتصال مباشر',
                  color: const Color(0xFF10B981), // تم تصحيح اللون هنا أيضاً
                  onTap: () {
                    // يحاكي إجراء الاتصال الهاتفي الفعلي
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 15),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline_rounded, size: 54, color: Colors.white.withOpacity(0.15)),
          const SizedBox(height: 14),
          Text(
            'لا يوجد متطوعين مقبولين في هذا التخصص حالياً',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13.5,
              color: AppColors.glassTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
