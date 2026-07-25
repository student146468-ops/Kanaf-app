import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
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
  bool _hasLoadedApplications = false;

  List<Map<String, String>> get _filteredHistory {
    final history = AppProviderScope.of(context)
        .volunteerApplications
        .map(_applicationToHistoryItem)
        .toList();
    if (_selectedFilter == 'الكل') return history;
    return history.where((item) => item['status'] == _selectedFilter).toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoadedApplications) return;
    _hasLoadedApplications = true;
    AppProviderScope.of(context).fetchVolunteerApplications();
  }

  Map<String, String> _applicationToHistoryItem(Map<String, dynamic> item) {
    return {
      'title': item['opportunity_title']?.toString() ?? '',
      'careHome': item['opportunity_location']?.toString() ?? '',
      'location': item['opportunity_location']?.toString() ?? '',
      'date': _dateLabel(item['created_at']),
      'hours': '',
      'children': '',
      'status': _statusLabel(item['status']?.toString() ?? ''),
      'image': 'assets/images/image7.png',
    };
  }

  String _dateLabel(dynamic value) {
    final date = DateTime.tryParse(value?.toString() ?? '');
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _statusLabel(String value) {
    if (value == 'approved') return 'قيد التنفيذ';
    if (value == 'rejected') return 'مرفوض';
    return 'قيد المراجعة';
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
    return const VolunteerTopBar(title: 'سجل التطوع');
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
              fontFamily: 'Vazirmatn',
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
                          fontFamily: 'Vazirmatn',
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
                fontFamily: 'Vazirmatn',
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
            fontFamily: 'Vazirmatn',
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
          fontFamily: 'Vazirmatn',
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
    return const VolunteerBottomNavBar(selectedIndex: 2);
  }
}
