import 'package:flutter/material.dart';

import 'volunteer_ui.dart';

const Color _historyOrange = Color(0xFFFF7A00);
const Color _historyText = Color(0xFF1E1E1E);
const Color _historyMuted = Color(0xFF6B7280);
const Color _historyBackground = Color(0xFFF8F8F8);
const Color _historyBorder = Color(0xFFEDEDED);

class MyVolunteerHistoryView extends StatefulWidget {
  const MyVolunteerHistoryView({super.key});

  @override
  State<MyVolunteerHistoryView> createState() => _MyVolunteerHistoryViewState();
}

class _MyVolunteerHistoryViewState extends State<MyVolunteerHistoryView> {
  String _selectedFilter = 'الكل';

  static const List<Map<String, String>> _history = [
    {
      'title': 'مساعدة في الوجبات المدرسية',
      'careHome': 'دار الأمان للأيتام',
      'location': 'طرابلس - حي الأندلس',
      'date': '20 مايو 2024',
      'hours': '3 ساعات',
      'children': '18 طفل',
      'status': 'مكتمل',
      'image': 'assets/images/image7.png',
    },
    {
      'title': 'توزيع وجبات غذائية',
      'careHome': 'دار الرحمة لرعاية الأيتام',
      'location': 'بنغازي - الفويهات',
      'date': '21 مايو 2024',
      'hours': '4 ساعات',
      'children': '25 طفل',
      'status': 'مكتمل',
      'image': 'assets/images/image8.png',
    },
    {
      'title': 'تنظيم فعالية ترفيهية',
      'careHome': 'دار الأمل للأطفال',
      'location': 'مصراتة - وسط المدينة',
      'date': '22 مايو 2024',
      'hours': '3 ساعات',
      'children': '32 طفل',
      'status': 'قيد التنفيذ',
      'image': 'assets/images/image9.png',
    },
    {
      'title': 'ورشة رسم للأطفال',
      'careHome': 'دار البسمة للأيتام',
      'location': 'طرابلس - جنزور',
      'date': '23 مايو 2024',
      'hours': '2 ساعات',
      'children': '14 طفل',
      'status': 'مكتمل',
      'image': 'assets/images/image10.png',
    },
  ];

  List<Map<String, String>> get _filteredHistory {
    if (_selectedFilter == 'الكل') return _history;
    return _history.where((item) => item['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: VolunteerMobileFrame(
        child: Scaffold(
          backgroundColor: _historyBackground,
          body: Column(
            children: [
              const _HistoryTopBar(),
              _HistoryFilters(
                selectedFilter: _selectedFilter,
                onSelected: (filter) {
                  setState(() => _selectedFilter = filter);
                },
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 112),
                  itemCount: _filteredHistory.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    return _HistoryCard(item: _filteredHistory[index]);
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: const _HistoryBottomBar(),
        ),
      ),
    );
  }
}

class _HistoryTopBar extends StatelessWidget {
  const _HistoryTopBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 56,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Center(
              child: Text(
                'سجل التطوع',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _historyText,
                ),
              ),
            ),
            PositionedDirectional(
              start: 16,
              child: IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  size: 32,
                  color: _historyText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryFilters extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  const _HistoryFilters({
    required this.selectedFilter,
    required this.onSelected,
  });

  static const List<String> _filters = ['الكل', 'مكتمل', 'قيد التنفيذ'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
      child: Row(
        children: [
          for (int i = 0; i < _filters.length; i++) ...[
            _HistoryFilterChip(
              label: _filters[i],
              selected: selectedFilter == _filters[i],
              onTap: () => onSelected(_filters[i]),
            ),
            if (i != _filters.length - 1) const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

class _HistoryFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _HistoryFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? _historyOrange : const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? _historyOrange : const Color(0xFFE8E8E8),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: selected ? Colors.white : _historyMuted,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Map<String, String> item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final status = item['status']!;
    final completed = status == 'مكتمل';
    final statusColor = completed ? const Color(0xFF22A06B) : _historyOrange;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _historyBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              item['image']!,
              width: 116,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 116,
                  height: 100,
                  color: const Color(0xFFFFF2E8),
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: _historyOrange,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item['title']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: _historyText,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(label: status, color: statusColor),
                  ],
                ),
                const SizedBox(height: 7),
                _HistoryDetail(
                  icon: Icons.home_work_outlined,
                  text: item['careHome']!,
                ),
                _HistoryDetail(
                  icon: Icons.location_on_outlined,
                  text: item['location']!,
                ),
                _HistoryDetail(
                  icon: Icons.calendar_today_outlined,
                  text: item['date']!,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 3,
                  children: [
                    _InlineDetail(
                      icon: Icons.access_time_rounded,
                      text: item['hours']!,
                    ),
                    _InlineDetail(
                      icon: Icons.child_care_rounded,
                      text: item['children']!,
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
}

class _HistoryDetail extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HistoryDetail({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Icon(icon, color: _historyMuted, size: 14),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                color: _historyMuted,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineDetail extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InlineDetail({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: _historyMuted, size: 14),
        const SizedBox(width: 4),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Tajawal',
            color: _historyMuted,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'Tajawal',
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _HistoryBottomBar extends StatelessWidget {
  const _HistoryBottomBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'الرئيسية',
                  selected: false,
                  onTap: () =>
                      Navigator.of(context).pushNamed('/volunteer_home'),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.notifications_none_rounded,
                  activeIcon: Icons.notifications_active_rounded,
                  label: 'الإشعارات',
                  selected: false,
                  showDot: true,
                  onTap: () => Navigator.of(context)
                      .pushNamed('/volunteer_notifications'),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.event_note_outlined,
                  activeIcon: Icons.event_note_rounded,
                  label: 'مواعيدي',
                  selected: true,
                  onTap: () => Navigator.of(context).pushNamed('/my_schedule'),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'حسابي',
                  selected: false,
                  onTap: () =>
                      Navigator.of(context).pushNamed('/volunteer_profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final bool showDot;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? _historyOrange : const Color(0xFF6B7280);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF2E8) : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 26,
              height: 24,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(selected ? activeIcon : icon, color: color, size: 23),
                  if (showDot)
                    Positioned(
                      top: -2,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: _historyOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
