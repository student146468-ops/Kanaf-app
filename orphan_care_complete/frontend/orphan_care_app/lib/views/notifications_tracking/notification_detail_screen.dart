import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../settings/shared_mobile_ui.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {
              'title': 'تحديث بخصوص الحملة',
              'body':
                  'لم يتم العثور على تفاصيل المحتوى. الرجاء العودة والمحاولة مجددًا.',
              'time': 'الآن',
              'type': 'track',
              'priority': 'متابعة',
            };
    final meta = _metaFor(args['type'] as String? ?? 'track');

    return KanafPage(
      title: 'تفاصيل الإشعار',
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            children: [
              KanafCard(
                child: Column(
                  children: [
                    KanafIconBox(
                      icon: meta.icon,
                      color: meta.color,
                      size: 64,
                      iconSize: 34,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      args['title'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDarkPrimary,
                        fontSize: 20,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        KanafBadge(label: meta.label, color: meta.color),
                        KanafBadge(
                          label: args['priority'] as String? ?? 'متابعة',
                          color: kanafStatusColor(
                            args['priority'] as String? ?? 'متابعة',
                          ),
                          icon: Icons.flag_outlined,
                        ),
                        KanafMetaChip(
                          icon: Icons.access_time_rounded,
                          label: args['time'] as String,
                        ),
                      ],
                    ),
                    const Divider(height: 28, color: AppColors.divider),
                    Text(
                      args['body'] as String,
                      textAlign: TextAlign.center,
                      style: kanafBodyStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (args['type'] == 'track' || args['type'] == 'donation')
                KanafPrimaryButton(
                  label: 'تتبع حالة الاحتياج',
                  icon: Icons.timeline_rounded,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/track_need_status');
                  },
                ),
            ],
          ),
        ),
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
