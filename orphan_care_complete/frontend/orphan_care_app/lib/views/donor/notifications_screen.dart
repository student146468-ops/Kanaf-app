import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = true;

  // TODO: Replace mock donor notifications with AppProvider/backend notifications.
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'تم تحديث حالة تبرعك',
      'body':
          'استلمت دار الرعاية السلة التموينية، وتم تسجيلها ضمن احتياجات المطبخ.',
      'time': 'منذ ساعتين',
      'isNew': true,
      'isRead': false,
      'type': 'donation',
      'icon': Icons.inventory_2_outlined,
    },
    {
      'title': 'اكتمل احتياج تعليمي',
      'body': 'بفضل مساهمات الداعمين تم تغطية مصاريف الدراسة بالكامل.',
      'time': 'منذ يوم',
      'isNew': false,
      'isRead': true,
      'type': 'completed',
      'icon': Icons.school_outlined,
    },
    {
      'title': 'احتياج صحي عاجل قريب منك',
      'body': 'تم نشر احتياج صحي عاجل من إحدى دور الرعاية في غريان.',
      'time': 'منذ 3 أيام',
      'isNew': false,
      'isRead': true,
      'type': 'urgent',
      'icon': Icons.health_and_safety_outlined,
    },
    {
      'title': 'احتياج جديد',
      'body': 'أضيف طلب دعم للقرطاسية والحقائب المدرسية لأطفال إحدى الدور.',
      'time': 'منذ 4 أيام',
      'isNew': false,
      'isRead': true,
      'type': 'new',
      'icon': Icons.fiber_new_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 450), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: donorMobileAppBar(
          title: 'الإشعارات',
          leading: donorBackButton(context),
          actions: [
            DonorCircleButton(
              icon: Icons.done_all_rounded,
              tooltip: 'تحديد الكل كمقروء',
              onTap: _markAllAsRead,
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: Stack(
          children: [
            const Positioned.fill(child: DonorBackground()),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: donorMobileMaxWidth),
                  child: _buildBody(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const _LoadingNotifications();

    if (_notifications.isEmpty) {
      return DonorEmptyState(
        icon: Icons.notifications_none_outlined,
        title: 'لا توجد إشعارات حاليًا',
        message: 'ستظهر هنا تحديثات مساهماتك والحالات التي تتابعها.',
        actionLabel: 'استكشف الاحتياجات الآن',
        onAction: () => Navigator.pushNamed(context, '/supporter_home'),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: _notifications.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == 0) return const _HeaderCard();
        final notification = _notifications[index - 1];
        return _NotificationCard(
          notification: notification,
          onTap: () => _openNotification(index - 1),
        );
      },
    );
  }

  void _openNotification(int index) {
    setState(() {
      _notifications[index]['isRead'] = true;
      _notifications[index]['isNew'] = false;
    });

    final notification = _notifications[index];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.innerBorder,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    notification['title'] as String,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDarkPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    notification['body'] as String,
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14.5,
                      height: 1.6,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    notification['time'] as String,
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 13,
                      color: AppColors.textDarkMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (final notification in _notifications) {
        notification['isRead'] = true;
        notification['isNew'] = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تحديد جميع الإشعارات كمقروءة',
            style: TextStyle(fontFamily: 'Tajawal')),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return const DonorCard(
      child: Row(
        children: [
          Icon(Icons.notifications_none_outlined, color: AppColors.brandOrange),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'تابع أثر مساهماتك وتحديثات الحالات الإنسانية من هنا.',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                height: 1.45,
                color: AppColors.textDarkSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification, required this.onTap});

  final Map<String, dynamic> notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isNew = notification['isNew'] as bool;
    final isRead = notification['isRead'] as bool;
    final accentColor = _accentColor(notification['type'] as String);

    return DonorCard(
      onTap: onTap,
      color: isRead ? Colors.white : accentColor.withOpacity(0.08),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              DonorIconBox(
                icon: notification['icon'] as IconData,
                color: isNew ? accentColor : AppColors.textDarkSecondary,
              ),
              if (isNew)
                Positioned(
                  top: -2,
                  left: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
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
                        notification['title'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textDarkPrimary,
                        ),
                      ),
                    ),
                    Text(
                      notification['time'] as String,
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12,
                        color: AppColors.textDarkMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notification['body'] as String,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 13.5,
                    height: 1.5,
                    color: AppColors.textDarkSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _accentColor(String type) {
    switch (type) {
      case 'urgent':
        return AppColors.errorRed;
      case 'new':
        return AppColors.brandOrangeDark;
      case 'completed':
        return AppColors.successGreen;
      case 'donation':
      default:
        return AppColors.skyBlueDark;
    }
  }
}

class _LoadingNotifications extends StatelessWidget {
  const _LoadingNotifications();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.brandOrange),
            SizedBox(height: 14),
            Text(
              'جاري تحميل الإشعارات...',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                color: AppColors.textDarkSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
