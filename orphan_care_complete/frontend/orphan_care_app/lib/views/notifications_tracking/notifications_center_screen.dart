import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../settings/shared_mobile_ui.dart';

class NotificationsCenterScreen extends StatefulWidget {
  const NotificationsCenterScreen({super.key});

  @override
  State<NotificationsCenterScreen> createState() =>
      _NotificationsCenterScreenState();
}

class _NotificationsCenterScreenState extends State<NotificationsCenterScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // TODO: Replace with AppProvider notification center data when available.
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'تم تأمين الكسوة الشتوية',
      'body':
          'اكتملت حملة الكسوة الشتوية لـ 25 طفلًا وبدأت دار الرعاية مرحلة التجهيز.',
      'time': 'منذ دقيقتين',
      'type': 'donation',
      'isRead': false,
      'priority': 'مكتمل',
    },
    {
      'id': '2',
      'title': 'موافقة على طلب التطوع',
      'body':
          'تم قبول انضمامك لفرصة الدعم التعليمي. يمكنك الآن متابعة جدولك الزمني.',
      'time': 'منذ ساعة',
      'type': 'volunteer',
      'isRead': false,
      'priority': 'مهم',
    },
    {
      'id': '3',
      'title': 'تحديث حالة الاحتياج',
      'body':
          'انتقلت شحنة الأغطية الدافئة إلى مرحلة الفرز والتغليف داخل دار الرعاية.',
      'time': 'منذ 5 ساعات',
      'type': 'track',
      'isRead': true,
      'priority': 'متابعة',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _markAllRead() {
    setState(() {
      for (final item in _notifications) {
        item['isRead'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return KanafPage(
      title: 'مركز الإشعارات',
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: KanafCircleButton(
            icon: Icons.done_all_rounded,
            onTap: _markAllRead,
            color: AppColors.brandOrange,
          ),
        ),
      ],
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
              child: KanafCard(
                padding: const EdgeInsets.all(6),
                color: AppColors.surfaceLight,
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  dividerColor: Colors.transparent,
                  labelColor: AppColors.brandOrange,
                  unselectedLabelColor: AppColors.textDarkSecondary,
                  labelStyle: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w900,
                    fontSize: 12.5,
                  ),
                  tabs: const [
                    Tab(text: 'الكل'),
                    Tab(text: 'التبرعات'),
                    Tab(text: 'التطوع'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _NotificationList(items: _notifications),
                  _NotificationList(
                    items: _notifications
                        .where((item) => item['type'] == 'donation')
                        .toList(),
                  ),
                  _NotificationList(
                    items: _notifications
                        .where((item) => item['type'] == 'volunteer')
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const _NotificationList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const KanafEmptyState(
        icon: Icons.notifications_none_rounded,
        title: 'لا توجد إشعارات',
        message:
            'ستظهر هنا تحديثات التبرعات والتطوع وحالة الاحتياجات عند توفرها.',
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _NotificationCard(item: items[index]);
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final meta = _metaFor(item['type'] as String);
    final isRead = item['isRead'] == true;

    return KanafCard(
      onTap: () => Navigator.of(context).pushNamed(
        '/notification_detail',
        arguments: item,
      ),
      color: isRead ? Colors.white : meta.color.withOpacity(0.065),
      borderColor:
          isRead ? AppColors.innerBorder : meta.color.withOpacity(0.28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KanafIconBox(icon: meta.icon, color: meta.color),
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
                const SizedBox(height: 5),
                Text(
                  item['body'] as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: kanafBodyStyle,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    KanafBadge(label: meta.label, color: meta.color),
                    KanafMetaChip(
                      icon: Icons.access_time_rounded,
                      label: item['time'] as String,
                    ),
                    KanafBadge(
                      label: item['priority'] as String,
                      color: kanafStatusColor(item['priority'] as String),
                      icon: Icons.flag_outlined,
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

  _NotificationMeta _metaFor(String type) {
    switch (type) {
      case 'donation':
        return const _NotificationMeta(
          label: 'تبرع',
          icon: Icons.inventory_2_outlined,
          color: AppColors.brandOrange,
        );
      case 'volunteer':
        return const _NotificationMeta(
          label: 'تطوع',
          icon: Icons.volunteer_activism_outlined,
          color: AppColors.successGreen,
        );
      default:
        return const _NotificationMeta(
          label: 'متابعة',
          icon: Icons.local_shipping_outlined,
          color: AppColors.skyBlueDark,
        );
    }
  }
}

class _NotificationMeta {
  final String label;
  final IconData icon;
  final Color color;

  const _NotificationMeta({
    required this.label,
    required this.icon,
    required this.color,
  });
}
