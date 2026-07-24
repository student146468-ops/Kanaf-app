import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import 'care_home_reference_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppProviderScope.of(context).fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final notifications = provider.notifications.where(_matchesFilter).toList();

    return CareHomeRefScaffold(
      title: 'الإشعارات',
      actions: [
        IconButton(
          tooltip: 'تحديد الكل كمقروء',
          onPressed: provider.markAllNotificationsRead,
          icon: const Icon(Icons.done_all_rounded, color: careHomeRefText),
        ),
      ],
      body: RefreshIndicator(
        color: careHomeRefOrange,
        onRefresh: provider.fetchNotifications,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            Row(
              children: [
                CareHomeRefChip(
                  label: 'الكل',
                  selected: _filter == 'all',
                  onTap: () => setState(() => _filter = 'all'),
                ),
                const SizedBox(width: 8),
                CareHomeRefChip(
                  label: 'تنبيهات',
                  selected: _filter == 'unread',
                  onTap: () => setState(() => _filter = 'unread'),
                ),
                const SizedBox(width: 8),
                CareHomeRefChip(
                  label: 'تحديثات',
                  selected: _filter == 'read',
                  onTap: () => setState(() => _filter = 'read'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (provider.isLoading)
              const Padding(
                padding: EdgeInsets.all(28),
                child: Center(
                  child: CircularProgressIndicator(color: careHomeRefOrange),
                ),
              )
            else if (notifications.isEmpty)
              const CareHomeRefEmpty(title: 'لا توجد إشعارات حاليا')
            else
              ...notifications.map((item) {
                final read = item['is_read'] == true;
                return CareHomeRefRowTile(
                  icon: read
                      ? Icons.notifications_none_rounded
                      : Icons.notifications_active_outlined,
                  title: careHomeValue(item['title'], 'إشعار جديد'),
                  subtitle: careHomeValue(item['message'], ''),
                  trailing: read
                      ? const SizedBox.shrink()
                      : const Icon(Icons.circle,
                          color: careHomeRefOrange, size: 9),
                  onTap: () {
                    final id = int.tryParse(item['id']?.toString() ?? '');
                    if (id != null) provider.markNotificationRead(id);
                  },
                );
              }),
          ],
        ),
      ),
    );
  }

  bool _matchesFilter(Map<String, dynamic> item) {
    final read = item['is_read'] == true;
    if (_filter == 'read') return read;
    if (_filter == 'unread') return !read;
    return true;
  }
}
