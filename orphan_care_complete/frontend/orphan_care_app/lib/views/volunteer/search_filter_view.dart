import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'volunteer_ui.dart';

class SearchFilterView extends StatefulWidget {
  const SearchFilterView({super.key});

  @override
  State<SearchFilterView> createState() => _SearchFilterViewState();
}

class _SearchFilterViewState extends State<SearchFilterView> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'الكل';
  String _selectedCity = 'كل المدن';
  String _selectedDate = 'أي وقت';

  static const List<String> _categories = [
    'الكل',
    'تعليم وتقنية',
    'أنشطة أطفال',
    'تنظيم',
    'دعم نفسي',
  ];
  static const List<String> _cities = ['كل المدن', 'غريان', 'طرابلس', 'مصراتة'];
  static const List<String> _dates = ['أي وقت', 'هذا الأسبوع', 'هذا الشهر'];

  // TODO: Replace with AppProvider opportunities when available.
  static const List<Map<String, String>> _results = [
    {
      'title': 'دعم تعليمي في أساسيات الحاسوب',
      'city': 'غريان',
      'skill': 'تعليم وتقنية',
      'date': 'الإثنين 1 يوليو',
      'seats': 'مقعدان',
      'status': 'متاحة',
    },
    {
      'title': 'تنظيم يوم أنشطة للأطفال',
      'city': 'غريان',
      'skill': 'أنشطة أطفال',
      'date': 'الجمعة 5 يوليو',
      'seats': '5 مقاعد',
      'status': 'قريبة',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'الكل';
      _selectedCity = 'كل المدن';
      _selectedDate = 'أي وقت';
    });
  }

  void _applyFilters() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم تطبيق خيارات البحث وعرض ${_results.length} فرص تطوعية مناسبة.',
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.brandOrange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VolunteerAppScaffold(
      title: 'البحث عن فرص التطوع',
      showBack: false,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  volunteerHorizontalPadding,
                  10,
                  volunteerHorizontalPadding,
                  20,
                ),
                children: [
                  _SearchField(controller: _searchController),
                  const SizedBox(height: 16),
                  _FilterSummary(
                    count: _results.length,
                    onClear: _clearFilters,
                  ),
                  const SizedBox(height: 16),
                  _FilterSection(
                    title: 'مجال التطوع',
                    children: _categories
                        .map(
                          (item) => _ChoicePill(
                            label: item,
                            selected: _selectedCategory == item,
                            onTap: () =>
                                setState(() => _selectedCategory = item),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 18),
                  _FilterSection(
                    title: 'المدينة',
                    children: _cities
                        .map(
                          (item) => _ChoicePill(
                            label: item,
                            selected: _selectedCity == item,
                            onTap: () => setState(() => _selectedCity = item),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 18),
                  _FilterSection(
                    title: 'التاريخ',
                    children: _dates
                        .map(
                          (item) => _ChoicePill(
                            label: item,
                            selected: _selectedDate == item,
                            onTap: () => setState(() => _selectedDate = item),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 22),
                  const VolunteerSectionTitle(title: 'نتائج مقترحة'),
                  const SizedBox(height: 10),
                  ..._results.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ResultCard(item: item),
                    ),
                  ),
                ],
              ),
            ),
            _SearchFooter(
              onClear: _clearFilters,
              onApply: _applyFilters,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;

  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontFamily: 'Tajawal',
        color: AppColors.textDarkPrimary,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: 'اكتب مهارة أو مدينة أو اسم فرصة',
        hintStyle: volunteerMutedStyle,
        prefixIcon: const Icon(
          Icons.manage_search_rounded,
          color: AppColors.brandOrange,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        border: _border(AppColors.innerBorder),
        enabledBorder: _border(AppColors.innerBorder),
        focusedBorder: _border(AppColors.brandOrange),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color),
    );
  }
}

class _FilterSummary extends StatelessWidget {
  final int count;
  final VoidCallback onClear;

  const _FilterSummary({required this.count, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      color: AppColors.surfaceLight,
      child: Row(
        children: [
          const VolunteerIconBox(
            icon: Icons.filter_alt_outlined,
            size: 36,
            iconSize: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$count فرص تطوعية مطابقة للخيارات الحالية',
              style: const TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.textDarkPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          TextButton(
            onPressed: onClear,
            child: const Text(
              'مسح',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _FilterSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: volunteerSectionTitleStyle),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: children),
        ],
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoicePill({
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
        hoverColor: AppColors.brandOrangeLight.withOpacity(0.32),
        splashColor: AppColors.brandOrangeLight,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.brandOrange : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? AppColors.brandOrange : AppColors.innerBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(Icons.check_rounded, color: Colors.white, size: 15),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: selected ? Colors.white : AppColors.textDarkSecondary,
                  fontSize: 12.5,
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

class _ResultCard extends StatelessWidget {
  final Map<String, String> item;

  const _ResultCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final status = item['status']!;
    final statusColor =
        status == 'قريبة' ? const Color(0xFF4A90E2) : AppColors.successGreen;

    return VolunteerCard(
      onTap: () => Navigator.of(context).pushNamed(
        '/volunteer_opportunity_details',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const VolunteerIconBox(
                icon: Icons.handshake_outlined,
                size: 40,
                iconSize: 21,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item['title']!,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textDarkPrimary,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              VolunteerStatusBadge(
                label: status,
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              VolunteerMetaChip(
                icon: Icons.location_on_outlined,
                label: item['city']!,
                color: AppColors.brandOrange,
                prominent: true,
              ),
              VolunteerMetaChip(
                icon: Icons.calendar_month_outlined,
                label: item['date']!,
                color: const Color(0xFF4A90E2),
                prominent: true,
              ),
              VolunteerMetaChip(
                icon: Icons.psychology_alt_outlined,
                label: item['skill']!,
              ),
              VolunteerMetaChip(
                icon: Icons.event_seat_outlined,
                label: item['seats']!,
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

class _SearchFooter extends StatelessWidget {
  final VoidCallback onClear;
  final VoidCallback onApply;

  const _SearchFooter({required this.onClear, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.innerBorder)),
        ),
        child: Row(
          children: [
            Expanded(
              child: VolunteerSecondaryButton(
                label: 'إعادة ضبط',
                icon: Icons.restart_alt_rounded,
                onPressed: onClear,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: VolunteerPrimaryButton(
                label: 'عرض النتائج',
                icon: Icons.filter_alt_rounded,
                onPressed: onApply,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
