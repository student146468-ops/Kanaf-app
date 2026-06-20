import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_container.dart';

/// [NotificationsScreen] - الواجهة رقم 33: مركز الإشعارات والتنبيهات اللوجستية لدار الرعاية لعام 2026.
/// تجمع الإشعارات الحية للتبرعات، طلبات التطوع، وتنبيهات النظام بلمسة زجاجية فخمة ومريحة للعين.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _activeCategoryFilter = 'الكل'; // الكل، التبرعات، التطوع، النظام

  // بيانات محاكاة فائقة الدقة والواقعية لمشروع كَنَفْ لإبهار لجنة التحكيم
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'n1',
      'title': 'تبرع عيني جديد قيد التوصيل',
      'body': 'قام المتبرع "أحمد الساعدي" بالتكفل بطلب حليب الأطفال، المندوب قادم لفرع غريان.',
      'time': 'منذ 5 دقائق',
      'category': 'التبرعات',
      'icon': Icons.card_giftcard_rounded,
      'badge_color': AppColors.brandOrange,
      'is_unread': true,
      'route': '/care_home_need_details',
      'arg': '1',
    },
    {
      'id': 'n2',
      'title': 'طلب انضمام متطوع ترفيهي',
      'body': 'قدمت الأخصائية "فاطمة الخويلدي" طلب دعم نفسي للأطفال. يرجى مراجعة المؤهلات.',
      'time': 'منذ ساعة',
      'category': 'التطوع',
      'icon': Icons.volunteer_activism_rounded,
      'badge_color': const Color(0xFF3B82F6), // Blue Accent فخم ومستقر
      'is_unread': true,
      'route': '/care_home_manage_volunteers',
      'arg': null,
    },
    {
      'id': 'n3',
      'title': 'تنبيه أمن النظام والنسخ الاحتياطي',
      'body': 'تم بنجاح النسخ الاحتياطي التلقائي لقاعدة بيانات الأطفال والأيتام لعام 2026 بأمان.',
      'time': 'منذ 5 ساعات',
      'category': 'النظام',
      'icon': Icons.shield_rounded,
      'badge_color': const Color(0xFF10B981), // الزمردي الثابت والمعتمد
      'is_unread': false,
      'route': null,
      'arg': null,
    },
    {
      'id': 'n4',
      'title': 'اكتملت كفالة المستلزمات الطبية',
      'body': 'تم استلام كافة أطقم الأدوية والمستلزمات الطبية وإغلاق الطلب بنجاح في المستودع.',
      'time': 'بالأمس',
      'category': 'التبرعات',
      'icon': Icons.task_alt_rounded,
      'badge_color': const Color(0xFF10B981),
      'is_unread': false,
      'route': '/care_home_needs_list',
      'arg': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final containerWidth = isWebOrDesktop ? 420.0 : double.infinity;

    // تصفية الإشعارات بناءً على الفئة النشطة
    final filteredNotifications = _notifications.where((notif) {
      if (_activeCategoryFilter == 'الكل') return true;
      return notif['category'] == _activeCategoryFilter;
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
                // الخلفية الكريستالية الحية المستقرة والموحدة لتطبيق كَنَفْ
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
                          Colors.black.withOpacity(0.93),
                        ],
                      ),
                    ),
                  ),
                ),

                // توزيع المحتوى بشكل تفاعلي ومريح بصرياً
                SafeArea(
                  child: Column(
                    children: [
                      _buildAppBar(),
                      _buildCategoryChips(),
                      const SizedBox(height: 10),
                      Expanded(
                        child: filteredNotifications.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                                itemCount: filteredNotifications.length,
                                itemBuilder: (context, index) {
                                  final notif = filteredNotifications[index];
                                  return _buildNotificationCard(notif);
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
            'مركز التنبيهات الحية',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.glassTextPrimary,
            ),
          ),
          // خيار تحديد الكل كمقروء بلمسة أنيقة
          GestureDetector(
            onTap: () {
              setState(() {
                for (var element in _notifications) {
                  element['is_unread'] = false;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تعيين جميع الإشعارات كمقروءة', style: TextStyle(fontFamily: 'Cairo')),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.done_all_rounded, color: AppColors.glassTextSecondary, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = ['الكل', 'التبرعات', 'التطوع', 'النظام'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        children: categories.map((cat) {
          final isSelected = _activeCategoryFilter == cat;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeCategoryFilter = cat),
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
                    cat,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
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

  Widget _buildNotificationCard(Map<String, dynamic> notif) {
    final bool isUnread = notif['is_unread'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() => notif['is_unread'] = false);
            if (notif['route'] != null) {
              Navigator.of(context).pushNamed(notif['route'], arguments: notif['arg']);
            }
          },
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              GlassContainer(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // أيقونة الإشعار بنظام النيون ثلاثي الأبعاد والملون
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: notif['badge_color'].withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: notif['badge_color'].withOpacity(0.25), width: 1.5),
                      ),
                      child: Icon(notif['icon'], color: notif['badge_color'], size: 22),
                    ),
                    const SizedBox(width: 14),

                    // محتوى الإشعار والتفاصيل المنظمة
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                notif['title'],
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  fontWeight: isUnread ? FontWeight.w800 : FontWeight.bold,
                                  color: isUnread ? Colors.white : AppColors.glassTextPrimary.withOpacity(0.8),
                                ),
                              ),
                              Text(
                                notif['time'],
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 10.5,
                                  color: AppColors.glassTextSecondary.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            notif['body'],
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12.5,
                              color: isUnread ? AppColors.glassTextPrimary : AppColors.glassTextSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // نقطة زرقاء متوهجة نيونية ممتازة تشير أن الإشعار غير مقروء تمنع تشتت العين
              if (isUnread)
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.brandOrange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppColors.brandOrange, blurRadius: 6, spreadRadius: 1),
                      ],
                    ),
                  ),
                ),
            ],
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
          Icon(Icons.notifications_off_rounded, size: 56, color: Colors.white.withOpacity(0.15)),
          const SizedBox(height: 14),
          Text(
            'لا توجد تنبيهات جديدة في هذا القسم حالياً',
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
