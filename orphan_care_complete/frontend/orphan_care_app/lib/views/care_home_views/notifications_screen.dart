import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _activeCategoryFilter = 'الكل';

  // TODO: Replace mock notifications with AppProvider/backend notifications when available.
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'تبرع عيني جديد قيد التوصيل',
      'body':
          'تكفل متبرع باحتياج حليب الأطفال، والمندوب في طريقه إلى فرع غريان.',
      'time': 'منذ 5 دقائق',
      'category': 'التبرعات',
      'icon': Icons.inventory_2_outlined,
      'color': AppColors.brandOrange,
      'is_unread': true,
      'route': '/care_home_need_details',
      'arg': '1',
    },
    {
      'title': 'طلب تطوع جديد',
      'body':
          'تم تقديم طلب لدعم أنشطة الأطفال. يرجى مراجعة المهارة والمواعيد المتاحة.',
      'time': 'منذ ساعة',
      'category': 'التطوع',
      'icon': Icons.person_add_alt_1_outlined,
      'color': const Color(0xFF3B82F6),
      'is_unread': true,
      'route': '/care_home_manage_volunteers',
      'arg': null,
    },
    {
      'title': 'تذكير إداري',
      'body':
          'راجع جدول الزيارات لهذا الأسبوع وحدّث الفترات المتاحة عند الحاجة.',
      'time': 'منذ 5 ساعات',
      'category': 'النظام',
      'icon': Icons.event_note_outlined,
      'color': const Color(0xFF10B981),
      'is_unread': false,
      'route': null,
      'arg': null,
    },
    {
      'title': 'اكتملت كفالة المستلزمات الطبية',
      'body':
          'تم استلام المستلزمات الطبية وإغلاق الطلب بنجاح في سجل الاحتياجات.',
      'time': 'بالأمس',
      'category': 'التبرعات',
      'icon': Icons.task_alt_outlined,
      'color': const Color(0xFF10B981),
      'is_unread': false,
      'route': '/care_home_needs_list',
      'arg': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final filteredNotifications = _notifications.where((notification) {
      if (_activeCategoryFilter == 'الكل') return true;
      return notification['category'] == _activeCategoryFilter;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: Container(
            width: isWebOrDesktop ? 430 : double.infinity,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              boxShadow: isWebOrDesktop
                  ? [
                      BoxShadow(
                        color: AppColors.innerShadow,
                        blurRadius: 24,
                        spreadRadius: 0,
                      )
                    ]
                  : [],
            ),
            child: Stack(
              children: [
                const Positioned.fill(child: _CareHomeBackground()),
                SafeArea(
                  child: Column(
                    children: [
                      _AppHeader(
                        title: 'الإشعارات',
                        trailingIcon: Icons.done_all_rounded,
                        trailingTooltip: 'تحديد الكل كمقروء',
                        onBack: () => Navigator.of(context).pop(),
                        onTrailing: _markAllRead,
                      ),
                      _CategoryChips(
                        selected: _activeCategoryFilter,
                        onChanged: (value) =>
                            setState(() => _activeCategoryFilter = value),
                      ),
                      Expanded(
                        child: filteredNotifications.isEmpty
                            ? const _EmptyState()
                            : ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 24),
                                itemCount: filteredNotifications.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final notification =
                                      filteredNotifications[index];
                                  return _NotificationCard(
                                    notification: notification,
                                    onTap: () =>
                                        _openNotification(notification),
                                  );
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

  void _markAllRead() {
    setState(() {
      for (final notification in _notifications) {
        notification['is_unread'] = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم تحديد جميع الإشعارات كمقروءة',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _openNotification(Map<String, dynamic> notification) {
    setState(() => notification['is_unread'] = false);
    if (notification['route'] != null) {
      Navigator.of(context)
          .pushNamed(notification['route'], arguments: notification['arg']);
    }
  }
}

class _CareHomeBackground extends StatelessWidget {
  const _CareHomeBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.white, AppColors.scaffoldBackground],
        ),
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  final String title;
  final IconData trailingIcon;
  final String trailingTooltip;
  final VoidCallback onBack;
  final VoidCallback onTrailing;

  const _AppHeader({
    required this.title,
    required this.trailingIcon,
    required this.trailingTooltip,
    required this.onBack,
    required this.onTrailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _CircleButton(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textDarkPrimary,
              ),
            ),
          ),
          Tooltip(
            message: trailingTooltip,
            child: _CircleButton(icon: trailingIcon, onTap: onTrailing),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.innerBorder),
        ),
        child: Icon(icon, color: AppColors.textDarkPrimary, size: 19),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _CategoryChips({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const categories = ['الكل', 'التبرعات', 'التطوع', 'النظام'];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selected;
          return InkWell(
            onTap: () => onChanged(category),
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.brandOrange.withOpacity(0.18)
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.brandOrange
                      : AppColors.innerBorder,
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isSelected
                      ? AppColors.brandOrange
                      : AppColors.textDarkSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = notification['color'] as Color;
    final isUnread = notification['is_unread'] as bool;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: CareHomeCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: color.withOpacity(0.28)),
              ),
              child: Icon(notification['icon'], color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight:
                                isUnread ? FontWeight.w900 : FontWeight.w700,
                            color: AppColors.textDarkPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        notification['time'],
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 11,
                          color: AppColors.textDarkMuted.withOpacity(0.75),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification['body'],
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 13,
                      height: 1.45,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isUnread) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.brandOrange,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: CareHomeCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notifications_none_outlined,
                color: AppColors.textDarkMuted.withOpacity(0.45),
                size: 52,
              ),
              const SizedBox(height: 12),
              const Text(
                'لا توجد إشعارات هنا',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDarkPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'ستظهر التبرعات وطلبات التطوع والتذكيرات عند وصولها.',
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
