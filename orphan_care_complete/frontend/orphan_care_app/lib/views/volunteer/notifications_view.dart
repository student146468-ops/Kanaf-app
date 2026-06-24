import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'volunteer_ui.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
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

  void _markAllRead() {
    setState(() {
      for (final item in _notifications) {
        item['read'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount =
        _notifications.where((item) => item['read'] == false).length;

    return VolunteerAppScaffold(
      title: 'الإشعارات',
      body: SafeArea(
        top: false,
        child: _notifications.isEmpty
            ? VolunteerEmptyState(
                icon: Icons.notifications_none_rounded,
                title: 'لا توجد إشعارات الآن',
                message:
                    'سنخبرك هنا عند قبول الطلبات أو صدور الشهادات أو نشر فرص جديدة.',
                actionLabel: 'استكشاف الفرص',
                onAction: () =>
                    Navigator.of(context).pushNamed('/volunteer_search'),
              )
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  volunteerHorizontalPadding,
                  10,
                  volunteerHorizontalPadding,
                  24,
                ),
                itemCount: _notifications.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _HeaderNote(
                      unreadCount: unreadCount,
                      onMarkAllRead: unreadCount == 0 ? null : _markAllRead,
                    );
                  }
                  return _NotificationCard(
                    item: _notifications[index - 1],
                    onTap: () => setState(() {
                      _notifications[index - 1]['read'] = true;
                    }),
                  );
                },
              ),
      ),
    );
  }
}

class _HeaderNote extends StatelessWidget {
  final int unreadCount;
  final VoidCallback? onMarkAllRead;

  const _HeaderNote({required this.unreadCount, required this.onMarkAllRead});

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      color: AppColors.brandOrangeLight,
      borderColor: Colors.white,
      child: Row(
        children: [
          const VolunteerIconBox(
            icon: Icons.notifications_active_outlined,
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              unreadCount == 0
                  ? 'كل الإشعارات مقروءة'
                  : 'لديك $unreadCount إشعارات تحتاج إلى متابعة',
              style: const TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.textDarkPrimary,
                fontSize: 13.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: onMarkAllRead,
            icon: const Icon(Icons.done_all_rounded, size: 18),
            label: const Text('تحديد الكل'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.brandOrange,
              disabledForegroundColor: AppColors.textDarkMuted,
              textStyle: const TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const _NotificationCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final meta = _notificationMeta(item['type'] as String);
    final isRead = item['read'] == true;

    return VolunteerCard(
      onTap: onTap,
      color: isRead ? Colors.white : meta.color.withOpacity(0.065),
      borderColor: isRead ? AppColors.innerBorder : meta.color.withOpacity(0.3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VolunteerIconBox(
            icon: meta.icon,
            color: meta.color,
            backgroundColor: meta.color.withOpacity(0.12),
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
                        item['title'] as String,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textDarkPrimary,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    VolunteerStatusBadge(
                      label: meta.label,
                      color: meta.color,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(item['body'] as String, style: volunteerBodyStyle),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      item['time'] as String,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        color: meta.color,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: meta.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _NotificationMeta _notificationMeta(String type) {
    switch (type) {
      case 'accepted':
        return const _NotificationMeta(
          icon: Icons.check_circle_rounded,
          color: AppColors.successGreen,
          label: 'قبول',
        );
      case 'rejected':
        return const _NotificationMeta(
          icon: Icons.cancel_rounded,
          color: AppColors.errorRed,
          label: 'رفض',
        );
      case 'reminder':
        return const _NotificationMeta(
          icon: Icons.alarm_rounded,
          color: Color(0xFF4A90E2),
          label: 'تذكير',
        );
      case 'certificate':
        return const _NotificationMeta(
          icon: Icons.workspace_premium_rounded,
          color: Color(0xFFFFB300),
          label: 'شهادة',
        );
      default:
        return const _NotificationMeta(
          icon: Icons.auto_awesome_rounded,
          color: AppColors.brandOrange,
          label: 'فرصة',
        );
    }
  }
}

class _NotificationMeta {
  final IconData icon;
  final Color color;
  final String label;

  const _NotificationMeta({
    required this.icon,
    required this.color,
    required this.label,
  });
}
