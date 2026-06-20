import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, dynamic>> _notifications = const [
    {'title': 'وصلت أمانتكم بحفظ الله ✨', 'body': 'تسلمت دار أيتام غريان السلة التموينية التي تبرعت بها. بارك الله فيك وميزان حسناتك.', 'time': 'منذ ساعتين', 'isNew': true},
    {'title': 'اكتملت الحالة الإنسانية بنجاح! 🎉', 'body': 'بفضل الله ثم دعمكم الكريم، تم إغلاق وتغطية مصاريف دراسة الطلاب بالكامل.', 'time': 'منذ يوم واحد', 'isNew': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('الإشعارات الحية', style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDarkPrimary)),
        ),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final notif = _notifications[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: notif['isNew'] ? const Color(0xFFFFF9F5) : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: notif['isNew'] ? AppColors.brandOrange.withOpacity(0.2) : AppColors.innerBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: notif['isNew'] ? AppColors.brandOrange : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notif['title'], style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.textDarkPrimary)),
                        const SizedBox(height: 4),
                        Text(notif['body'], style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.textDarkSecondary, height: 1.5)),
                        const SizedBox(height: 8),
                        Text(notif['time'], style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textDarkMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
