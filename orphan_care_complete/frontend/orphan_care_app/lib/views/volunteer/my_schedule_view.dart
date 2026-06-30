import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'volunteer_ui.dart';

class MyScheduleView extends StatefulWidget {
  const MyScheduleView({super.key});

  @override
  State<MyScheduleView> createState() => _MyScheduleViewState();
}

class _MyScheduleViewState extends State<MyScheduleView> {
  int _selectedDayIndex = 1;

  static const List<Map<String, String>> _days = [
    {'day': 'الأحد', 'date': '30'},
    {'day': 'الإثنين', 'date': '01'},
    {'day': 'الثلاثاء', 'date': '02'},
    {'day': 'الأربعاء', 'date': '03'},
    {'day': 'الخميس', 'date': '04'},
  ];

  // TODO: Replace with AppProvider schedule data when available.
  static const List<Map<String, String>> _items = [
    {
      'time': '16:00 - 18:00',
      'title': 'جلسة أساسيات الحاسوب',
      'location': 'دار الأمان لرعاية الأيتام - غريان',
      'status': 'قادمة',
      'skill': 'تعليم وتقنية',
    },
    {
      'time': '18:15 - 19:15',
      'title': 'نشاط ألعاب ذهنية للأطفال',
      'location': 'قاعة الأنشطة',
      'status': 'مؤكدة',
      'skill': 'أنشطة',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return VolunteerAppScaffold(
      title: 'مواعيدي التطوعية',
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            SizedBox(
              height: 90,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: volunteerHorizontalPadding,
                  vertical: 8,
                ),
                itemCount: _days.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final selected = index == _selectedDayIndex;
                  return _DayPill(
                    item: _days[index],
                    selected: selected,
                    onTap: () => setState(() => _selectedDayIndex = index),
                  );
                },
              ),
            ),
            Expanded(
              child: _items.isEmpty
                  ? VolunteerEmptyState(
                      icon: Icons.event_busy_outlined,
                      title: 'لا توجد مواعيد لهذا اليوم',
                      message:
                          'بعد قبولك في فرصة تطوعية سيظهر موعدها هنا بوضوح.',
                      actionLabel: 'استكشاف الفرص',
                      onAction: () =>
                          Navigator.of(context).pushNamed('/volunteer_search'),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        volunteerHorizontalPadding,
                        8,
                        volunteerHorizontalPadding,
                        24,
                      ),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _ScheduleCard(item: _items[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayPill extends StatelessWidget {
  final Map<String, String> item;
  final bool selected;
  final VoidCallback onTap;

  const _DayPill({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: AppColors.brandOrangeLight.withOpacity(0.32),
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 70,
          decoration: BoxDecoration(
            color: selected ? AppColors.brandOrange : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? AppColors.brandOrange : AppColors.innerBorder,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.brandOrange.withOpacity(0.16),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item['day']!,
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  color: selected ? Colors.white : AppColors.textDarkMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item['date']!,
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  color: selected ? Colors.white : AppColors.textDarkPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final Map<String, String> item;

  const _ScheduleCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const VolunteerIconBox(
                icon: Icons.schedule_rounded,
                color: AppColors.brandOrange,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item['time']!,
                  style: const TextStyle(
                    fontFamily: 'Vazirmatn',
                    color: AppColors.brandOrange,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const VolunteerStatusBadge(
                label: 'قادمة',
                color: AppColors.successGreen,
                icon: Icons.check_circle_outline_rounded,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item['title']!,
            style: const TextStyle(
              fontFamily: 'Vazirmatn',
              color: AppColors.textDarkPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              VolunteerMetaChip(
                icon: Icons.psychology_alt_outlined,
                label: item['skill']!,
              ),
              VolunteerMetaChip(
                icon: Icons.location_on_outlined,
                label: item['location']!,
                color: AppColors.brandOrange,
                prominent: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
