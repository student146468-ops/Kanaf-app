import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class NotificationsCenterScreen extends StatefulWidget {
  const NotificationsCenterScreen({super.key});

  @override
  State<NotificationsCenterScreen> createState() => _NotificationsCenterScreenState();
}

class _NotificationsCenterScreenState extends State<NotificationsCenterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'تم تأمين الكسوة الشتوية! 🎉',
      'body': 'بفضل دعمكم الكريم، اكتملت حملة الكسوة الشتوية لـ 25 طفلاً بدار أيتام غريان وبدأ التجهيز.',
      'time': 'منذ دقيقتين',
      'type': 'donation',
      'isRead': false,
      'icon': '📦',
    },
    {
      'id': '2',
      'title': 'موافقة على طلب التطوع 🤝',
      'body': 'تم قبول انضمامك لفرصة "الدعم التعليمي للأطفال". يمكنك الآن تصفح جدولك الزمني.',
      'time': 'منذ ساعة',
      'type': 'volunteer',
      'isRead': false,
      'icon': '📝',
    },
    {
      'id': '3',
      'title': 'حالة الاحتياج تحدثت 🚀',
      'body': 'انتقلت شحنة الأغطية الدافئة إلى مرحلة "التوصيل والتسليم" الآن، تابع خطوة بخطوة.',
      'time': 'منذ 5 ساعات',
      'type': 'track',
      'isRead': true,
      'icon': '🚚',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'مركز الإشعارات',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.brandOrange,
            labelColor: AppColors.brandOrange,
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 14),
            tabs: const [
              Tab(text: 'الكل'),
              Tab(text: 'التبرعات'),
              Tab(text: 'التطوع'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildNotificationList('all'),
            _buildNotificationList('donation'),
            _buildNotificationList('volunteer'),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(String category) {
    final filtered = category == 'all' 
        ? _notifications 
        : _notifications.where((n) => n['type'] == category).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🔔', style: TextStyle(fontSize: 64, color: Colors.white.withOpacity(0.2))),
            const SizedBox(height: 16),
            const Text(
              'لا توجد إشعارات في هذا القسم حالياً',
              style: TextStyle(fontFamily: 'Cairo', color: Colors.white60, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/notification_detail', arguments: item);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(item['isRead'] ? 0.03 : 0.07),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: item['isRead'] ? Colors.white.withOpacity(0.08) : AppColors.brandOrange.withOpacity(0.3),
                width: 1.2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.brandOrangeDark.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.brandOrange.withOpacity(0.2), width: 1),
                        ),
                        child: Center(
                          child: Text(
                            item['icon'],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['title'],
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                if (!item['isRead'])
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(color: AppColors.brandOrange, shape: BoxShape.circle),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item['body'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontFamily: 'Cairo', color: Colors.white70, fontSize: 13, height: 1.4),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item['time'],
                              style: const TextStyle(fontFamily: 'Cairo', color: Colors.white38, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
