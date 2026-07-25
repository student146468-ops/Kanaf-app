import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _hasLoadedNotifications = false;
  String _selectedFilter = 'الكل';

  static const Color _primaryOrange = Color(0xFFFF8C42);
  static const Color _screenBackground = Color(0xFFF5F5F5);
  static const Color _softOrange = Color(0xFFFF8C42);

  final List<String> _filters = const ['الكل', 'تحديثات', 'تنبيهات'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoadedNotifications) return;
    _hasLoadedNotifications = true;
    AppProviderScope.of(context).fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _screenBackground,
        appBar: const DonorAppBar(
          title: 'الإشعارات',
        ),
        body: SafeArea(
          top: false,
          child: DonorMobileFrame(child: _buildBody()),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final provider = AppProviderScope.of(context);
    final source = provider.notifications.map(_notificationToMap).toList();
    if (provider.isLoading && source.isEmpty) {
      return const _LoadingNotifications();
    }

    if (source.isEmpty) {
      return const DonorEmptyState(
        icon: Icons.notifications_none_outlined,
        title: 'لا توجد إشعارات',
        message:
            'ستظهر هنا آخر التحديثات المتعلقة بتبرعاتك واحتياجات دور الرعاية.',
      );
    }

    final notifications = _filteredNotifications(source);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 24),
      children: [
        _NotificationFilterBar(
          filters: _filters,
          selectedFilter: _selectedFilter,
          onSelected: (value) => setState(() => _selectedFilter = value),
        ),
        const SizedBox(height: DonorSpacing.sm),
        _MarkAllAsReadAction(onTap: _markAllAsRead),
        const SizedBox(height: DonorSpacing.md),
        if (notifications.isEmpty)
          const DonorEmptyState(
            icon: Icons.notifications_none_outlined,
            title: 'لا توجد إشعارات',
            message:
                'ستظهر هنا آخر التحديثات المتعلقة بتبرعاتك واحتياجات دور الرعاية.',
          )
        else
          ...notifications.map((notification) {
            final index = source.indexOf(notification);
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _NotificationCard(
                notification: notification,
                onTap: () => _openNotification(index),
              ),
            );
          }),
      ],
    );
  }

  List<Map<String, dynamic>> _filteredNotifications(
      List<Map<String, dynamic>> notifications) {
    if (_selectedFilter == 'الكل') return notifications;
    return notifications.where((notification) {
      final type = notification['type'] as String;
      if (_selectedFilter == 'تحديثات') {
        return type == 'donation' || type == 'completed';
      }
      return type == 'urgent' || type == 'new';
    }).toList();
  }

  void _openNotification(int index) {
    if (index < 0) return;

    final provider = AppProviderScope.of(context);
    final notification = _notificationToMap(provider.notifications[index]);
    final id = notification['id'] as int?;
    if (id != null) provider.markNotificationRead(id);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: _NotificationDetailsBottomSheet(notification: notification),
        );
      },
    );
  }

  void _markAllAsRead() {
    AppProviderScope.of(context).markAllNotificationsRead();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم تحديد جميع الإشعارات كمقروءة',
          style: TextStyle(fontFamily: 'Vazirmatn'),
        ),
        backgroundColor: _primaryOrange,
      ),
    );
  }

  Map<String, dynamic> _notificationToMap(Map<String, dynamic> item) {
    final type = item['notification_type']?.toString() ?? 'message';
    final isRead = item['is_read'] == true;
    return {
      'id':
          item['id'] is int ? item['id'] as int : int.tryParse('${item['id']}'),
      'title': item['title']?.toString() ?? '',
      'body': item['message']?.toString() ?? '',
      'time': _dateLabel(item['created_at']),
      'isNew': !isRead,
      'isRead': isRead,
      'type': type,
      'icon': _iconForType(type),
    };
  }

  String _dateLabel(dynamic value) {
    final date = DateTime.tryParse(value?.toString() ?? '');
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'donation':
        return Icons.inventory_2_outlined;
      case 'status_update':
        return Icons.favorite_border_rounded;
      case 'volunteer':
        return Icons.volunteer_activism_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }
}

class _NotificationFilterBar extends StatelessWidget {
  const _NotificationFilterBar({
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: filters.map((filter) {
            final selected = filter == selectedFilter;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InkWell(
                  onTap: () => onSelected(filter),
                  borderRadius: BorderRadius.circular(999),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? _NotificationsScreenState._primaryOrange
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      filter,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ).copyWith(
                        color:
                            selected ? Colors.white : AppColors.textDarkPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MarkAllAsReadAction extends StatelessWidget {
  const _MarkAllAsReadAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.done_all_rounded, size: 17),
        label: const Text('تحديد الكل كمقروء'),
        style: TextButton.styleFrom(
          foregroundColor: _NotificationsScreenState._primaryOrange,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
          ),
        ),
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
    final type = notification['type'] as String;

    return _SoftNotificationCard(
      onTap: onTap,
      child: SizedBox(
        height: 108,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _NotificationIconCircle(icon: _notificationIcon(type)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['title'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 14.8,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDarkPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification['body'] as String,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 12.6,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    notification['time'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textDarkMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 10,
              child: Align(
                alignment: Alignment.center,
                child: isNew
                    ? const _UnreadIndicator()
                    : const SizedBox(width: 8, height: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _notificationIcon(String type) {
    switch (type) {
      case 'donation':
        return Icons.inventory_2_outlined;
      case 'completed':
        return Icons.favorite_border_rounded;
      case 'urgent':
        return Icons.info_outline_rounded;
      case 'new':
        return Icons.notifications_none_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }
}

class _SoftNotificationCard extends StatelessWidget {
  const _SoftNotificationCard({
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.045),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _NotificationIconCircle extends StatelessWidget {
  const _NotificationIconCircle({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _NotificationsScreenState._softOrange.withOpacity(0.11),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: _NotificationsScreenState._primaryOrange,
        size: 22,
      ),
    );
  }
}

class _UnreadIndicator extends StatelessWidget {
  const _UnreadIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: _NotificationsScreenState._primaryOrange,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _NotificationDetailsBottomSheet extends StatelessWidget {
  const _NotificationDetailsBottomSheet({required this.notification});

  final Map<String, dynamic> notification;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 20, 24),
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
            const SizedBox(height: DonorSpacing.xl),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NotificationIconCircle(
                  icon: notification['icon'] as IconData,
                ),
                const SizedBox(width: DonorSpacing.md),
                Expanded(
                  child: Text(
                    notification['title'] as String,
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 18,
                      height: 1.35,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDarkPrimary,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'إغلاق',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textDarkMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DonorSpacing.md),
            Text(
              notification['body'] as String,
              style: const TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                height: 1.65,
                color: AppColors.textDarkSecondary,
              ),
            ),
            const SizedBox(height: DonorSpacing.md),
            Text(
              notification['time'] as String,
              style: const TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textDarkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingNotifications extends StatelessWidget {
  const _LoadingNotifications();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          strokeWidth: 2.6,
          color: _NotificationsScreenState._primaryOrange,
        ),
      ),
    );
  }
}
