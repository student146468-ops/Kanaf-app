import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppProviderScope.of(context).fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final provider = AppProviderScope.of(context);
    final notifications = provider.notifications.where((item) {
      if (!_showUnreadOnly) return true;
      return item['is_read'] != true;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: Container(
            width: isWebOrDesktop ? 430 : double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  CareHomeTopBar(
                    title: 'الإشعارات',
                    onBack: () => Navigator.of(context).pop(),
                    includeSafeArea: false,
                    actions: [
                      IconButton(
                        onPressed: provider.notifications.isEmpty
                            ? null
                            : () => provider.markAllNotificationsRead(),
                        icon: const Icon(Icons.done_all_rounded,
                            color: AppColors.brandOrange),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: CareHomeSpacing.lg,
                        vertical: CareHomeSpacing.sm),
                    child: Row(
                      children: [
                        CareHomeChip(
                          label: 'الكل',
                          selected: !_showUnreadOnly,
                          variant: CareHomeChipVariant.filter,
                          onTap: () => setState(() => _showUnreadOnly = false),
                        ),
                        const SizedBox(width: CareHomeSpacing.sm),
                        CareHomeChip(
                          label: 'غير المقروءة',
                          selected: _showUnreadOnly,
                          variant: CareHomeChipVariant.filter,
                          onTap: () => setState(() => _showUnreadOnly = true),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: provider.fetchNotifications,
                      child: provider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : notifications.isEmpty
                              ? const _EmptyState()
                              : ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: CareHomeSpacing.lg,
                                      vertical: CareHomeSpacing.md),
                                  itemCount: notifications.length,
                                  itemBuilder: (context, index) {
                                    final notification = notifications[index];
                                    final isRead =
                                        notification['is_read'] == true;
                                    return CareHomeCard(
                                      margin: const EdgeInsets.only(
                                          bottom: CareHomeSpacing.sm),
                                      padding: const EdgeInsets.all(
                                          CareHomeSpacing.md),
                                      child: InkWell(
                                        onTap: () async {
                                          final id = int.tryParse(
                                              notification['id'].toString());
                                          if (id != null && !isRead) {
                                            await provider
                                                .markNotificationRead(id);
                                          }
                                          final route =
                                              notification['related_route']
                                                  ?.toString();
                                          if (context.mounted &&
                                              route != null &&
                                              route.isNotEmpty) {
                                            Navigator.of(context)
                                                .pushNamed(route);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            CareHomeIconBox(
                                              icon: isRead
                                                  ? Icons
                                                      .notifications_none_rounded
                                                  : Icons
                                                      .notifications_active_rounded,
                                              color: isRead
                                                  ? AppColors.textDarkMuted
                                                  : AppColors.brandOrange,
                                              backgroundColor:
                                                  AppColors.surfaceLight,
                                              size: 42,
                                            ),
                                            const SizedBox(
                                                width: CareHomeSpacing.md),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    notification['title']
                                                            ?.toString() ??
                                                        '',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: CareHomeTextStyles
                                                        .body
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    notification['message']
                                                            ?.toString() ??
                                                        '',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: CareHomeTextStyles
                                                        .muted,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 120),
        Icon(Icons.notifications_none_rounded,
            size: 52, color: AppColors.textDarkMuted),
        SizedBox(height: CareHomeSpacing.sm),
        Text('لا توجد بيانات حتى الآن',
            textAlign: TextAlign.center, style: CareHomeTextStyles.body),
      ],
    );
  }
}
