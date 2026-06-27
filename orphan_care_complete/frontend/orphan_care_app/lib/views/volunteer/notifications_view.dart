import 'package:flutter/material.dart';

import 'volunteer_ui.dart';

const Color _primaryOrange = Color(0xFFFF8C42);
const Color _textPrimary = Color(0xFF1E1E1E);
const Color _textSecondary = Color(0xFF6B7280);
const Color _softBorder = Color(0xFFEAEAEA);

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  String _selectedFilter = 'الكل';

  // TODO: Replace with AppProvider notifications when available.
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'تم قبول طلبك',
      'body': 'تم اعتماد مشاركتك في فرصة دعم أساسيات الحاسوب.',
      'time': 'منذ 5 دقائق',
      'type': 'accepted',
      'read': false,
    },
    {
      'title': 'تعذر قبول الطلب',
      'body': 'اكتمل عدد المقاعد لهذه الفرصة، ابحث عن فرصة قريبة أخرى.',
      'time': 'منذ 30 دقيقة',
      'type': 'rejected',
      'read': false,
    },
    {
      'title': 'تذكير بموعد قريب',
      'body': 'لديك جلسة تطوعية اليوم الساعة 16:00 في دار الأمان.',
      'time': 'منذ ساعة',
      'type': 'reminder',
      'read': false,
    },
    {
      'title': 'شهادة جديدة',
      'body': 'تم إصدار شهادة تقدير بعد إكمال نشاطك التطوعي الأخير.',
      'time': 'أمس',
      'type': 'certificate',
      'read': true,
    },
    {
      'title': 'فرصة جديدة مناسبة لك',
      'body': 'تم نشر فرصة تنظيم أنشطة للأطفال في غريان.',
      'time': 'قبل يومين',
      'type': 'opportunity',
      'read': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'غير مقروء') {
      return _notifications.where((item) => item['read'] == false).toList();
    }
    if (_selectedFilter == 'التسويق') {
      return _notifications
          .where((item) => item['type'] == 'opportunity')
          .toList();
    }
    return _notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: VolunteerMobileFrame(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                const _NotificationsTopBar(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _NotificationFilters(
                    selectedFilter: _selectedFilter,
                    onSelected: (filter) {
                      setState(() => _selectedFilter = filter);
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: _filteredNotifications.isEmpty
                      ? VolunteerEmptyState(
                          icon: Icons.notifications_none_rounded,
                          title: 'لا توجد إشعارات الآن',
                          message:
                              'سنخبرك هنا عند قبول الطلبات أو صدور الشهادات أو نشر فرص جديدة.',
                          actionLabel: 'استكشاف الفرص',
                          onAction: () => Navigator.of(context).pushNamed(
                            '/volunteer_search',
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 110),
                          itemCount: _filteredNotifications.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final item = _filteredNotifications[index];
                            return _NotificationCard(
                              item: item,
                              icon: _notificationIcon(index, item),
                              onTap: () => setState(() {
                                item['read'] = true;
                              }),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const _NotificationsBottomBar(),
        ),
      ),
    );
  }

  IconData _notificationIcon(int index, Map<String, dynamic> item) {
    switch (index) {
      case 0:
        return Icons.school_rounded;
      case 1:
        return Icons.brush_rounded;
      case 2:
        return Icons.celebration_rounded;
      case 3:
        return Icons.inventory_2_rounded;
      default:
        return item['type'] == 'opportunity'
            ? Icons.celebration_rounded
            : Icons.notifications_active_outlined;
    }
  }
}

class _NotificationsTopBar extends StatelessWidget {
  const _NotificationsTopBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 56,
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                'الإشعارات',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: _textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            PositionedDirectional(
              start: 16,
              top: 4,
              bottom: 4,
              child: SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.chevron_right_rounded,
                    color: _textPrimary,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationFilters extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  const _NotificationFilters({
    required this.selectedFilter,
    required this.onSelected,
  });

  static const List<String> _filters = ['الكل', 'غير مقروء', 'التسويق'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < _filters.length; i++) ...[
          _FilterChipButton(
            label: _filters[i],
            selected: selectedFilter == _filters[i],
            onTap: () => onSelected(_filters[i]),
          ),
          if (i != _filters.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? _primaryOrange : const Color(0xFFF4F4F5),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: selected ? Colors.white : _textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final IconData icon;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.item,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = item['read'] == true;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _softBorder.withOpacity(0.75)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.045),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2E8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: _primaryOrange, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item['title'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: _textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (!isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 7),
                            decoration: const BoxDecoration(
                              color: _primaryOrange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['body'] as String,
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        color: _textSecondary,
                        fontSize: 13,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['time'] as String,
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        color: _textSecondary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationsBottomBar extends StatelessWidget {
  const _NotificationsBottomBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'الرئيسية',
                  selected: false,
                  onTap: () =>
                      Navigator.of(context).pushNamed('/volunteer_home'),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.notifications_none_rounded,
                  activeIcon: Icons.notifications_active_rounded,
                  label: 'الإشعارات',
                  selected: true,
                  showDot: true,
                  onTap: () {},
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.event_note_outlined,
                  activeIcon: Icons.event_note_rounded,
                  label: 'مواعيدي',
                  selected: false,
                  onTap: () => Navigator.of(context).pushNamed('/my_schedule'),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'حسابي',
                  selected: false,
                  onTap: () =>
                      Navigator.of(context).pushNamed('/volunteer_profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final bool showDot;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? _primaryOrange : const Color(0xFF6B7280);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF2E8) : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 26,
              height: 24,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(selected ? activeIcon : icon, color: color, size: 23),
                  if (showDot)
                    Positioned(
                      top: -2,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: _primaryOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
