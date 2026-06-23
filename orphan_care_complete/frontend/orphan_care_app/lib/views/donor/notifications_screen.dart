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

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'تم تحديث حالة تبرعك',
      'body':
          'استلمت دار رعاية الأيتام السلة التموينية، وتم تسجيلها ضمن احتياجات المطبخ.',
      'time': 'منذ ساعتين',
      'isNew': true,
      'isRead': false,
      'type': 'donation',
      'icon': Icons.inventory_2_rounded,
    },
    {
      'title': 'اكتمل احتياج تعليمي',
      'body': 'بفضل مساهمات الداعمين تم تغطية مصاريف الدراسة بالكامل.',
      'time': 'منذ يوم',
      'isNew': false,
      'isRead': true,
      'type': 'completed',
      'icon': Icons.school_rounded,
    },
    {
      'title': 'حالة جديدة قريبة منك',
      'body': 'تم نشر احتياج صحي عاجل من إحدى دور الرعاية في غريان.',
      'time': 'منذ 3 أيام',
      'isNew': false,
      'isRead': true,
      'type': 'health',
      'icon': Icons.health_and_safety_rounded,
    },
    {
      'title': 'احتياج تعليمي جديد',
      'body': 'أضيف طلب دعم للقرطاسية والحقائب المدرسية لأطفال إحدى الدور.',
      'time': 'منذ 4 أيام',
      'isNew': false,
      'isRead': true,
      'type': 'education',
      'icon': Icons.menu_book_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 450), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
          actions: [
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'تحديد الكل كمقروء',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.brandOrangeDark,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: _buildBody(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const _LoadingNotifications();
    }

    if (_notifications.isEmpty) {
      return const _EmptyNotifications();
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
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.innerBorder),
      ),
      child: const Row(
        children: [
          Icon(Icons.notifications_active_rounded,
              color: AppColors.brandOrange),
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

    return Material(
      color: isRead ? Colors.white : accentColor.withOpacity(0.10),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isNew
                  ? AppColors.brandOrange.withOpacity(0.35)
                  : AppColors.innerBorder,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: isNew
                          ? accentColor.withOpacity(0.14)
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      notification['icon'] as IconData,
                      color: isNew ? accentColor : AppColors.textDarkSecondary,
                    ),
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
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDarkPrimary,
                            ),
                          ),
                        ),
                        Text(
                          notification['time'] as String,
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 12,
                            color: Color(0xFF66788A),
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
                        color: Color(0xFF526577),
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

  Color _accentColor(String type) {
    switch (type) {
      case 'education':
        return AppColors.skyBlueDark;
      case 'health':
        return AppColors.successGreen;
      case 'completed':
        return const Color(0xFF6F63C7);
      case 'donation':
      default:
        return AppColors.brandOrangeDark;
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

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 34),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.innerBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.notifications_none_rounded,
                  size: 48, color: AppColors.textDarkMuted),
              const SizedBox(height: 10),
              const Text(
                'لا توجد إشعارات حاليًا',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDarkPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'ستظهر هنا تحديثات مساهماتك والحالات التي تتابعها.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14,
                  height: 1.45,
                  color: AppColors.textDarkSecondary,
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/supporter_home'),
                icon: const Icon(Icons.favorite_rounded, size: 17),
                label: const Text('استكشف الاحتياجات الآن'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.brandOrangeDark,
                  textStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
