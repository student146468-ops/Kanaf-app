import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'volunteer_ui.dart';

class MyVolunteerHistoryView extends StatelessWidget {
  const MyVolunteerHistoryView({super.key});

  // TODO: Replace with AppProvider volunteer history when available.
  static const List<Map<String, String>> _history = [
    {
      'title': 'دورة أساسيات الحاسوب للأطفال',
      'location': 'دار الأمان لرعاية الأيتام - غريان',
      'date': 'أبريل 2026',
      'hours': '18 ساعة',
      'impact': '12 طفلًا مستفيدًا',
    },
    {
      'title': 'تنظيم سلال الدعم العيني',
      'location': 'مركز كنف المجتمعي',
      'date': 'فبراير 2026',
      'hours': '10 ساعات',
      'impact': '30 سلة مجهزة',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final totalHours = _history.fold<int>(0, (sum, item) {
      return sum + (int.tryParse(item['hours']!.split(' ').first) ?? 0);
    });

    return VolunteerAppScaffold(
      title: 'سجل التطوع',
      body: SafeArea(
        top: false,
        child: _history.isEmpty
            ? VolunteerEmptyState(
                icon: Icons.history_toggle_off_rounded,
                title: 'ابدأ أول تجربة تطوعية لك',
                message: 'سيظهر سجل مساهماتك هنا بعد قبولك في أول فرصة.',
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
                itemCount: _history.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _SummaryCard(
                      hours: totalHours,
                      opportunities: _history.length,
                    );
                  }
                  return _HistoryCard(item: _history[index - 1]);
                },
              ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int hours;
  final int opportunities;

  const _SummaryCard({required this.hours, required this.opportunities});

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      color: AppColors.brandOrangeLight,
      borderColor: Colors.white,
      child: Row(
        children: [
          const VolunteerIconBox(
            icon: Icons.auto_graph_rounded,
            backgroundColor: Colors.white,
            size: 50,
            iconSize: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$hours ساعة تطوعية',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textDarkPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '$opportunities فرص مكتملة صنعت أثرًا ملموسًا',
                  style: volunteerBodyStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Map<String, String> item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const VolunteerIconBox(
                icon: Icons.task_alt_rounded,
                color: AppColors.successGreen,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item['title']!,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textDarkPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(item['location']!, style: volunteerBodyStyle),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              VolunteerMetaChip(
                icon: Icons.calendar_month_outlined,
                label: item['date']!,
                color: const Color(0xFF4A90E2),
                prominent: true,
              ),
              VolunteerMetaChip(
                icon: Icons.schedule_rounded,
                label: item['hours']!,
                color: AppColors.brandOrange,
                prominent: true,
              ),
              VolunteerMetaChip(
                icon: Icons.favorite_rounded,
                label: item['impact']!,
                color: AppColors.successGreen,
                prominent: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
