import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _activeUrgencyFilter = 'الكل';
  String _activeCityFilter = 'الكل';
  String _activeDonationTypeFilter = 'الكل';
  String _activeProgressFilter = 'الكل';

  final List<String> _urgencies = const [
    'الكل',
    'عاجل',
    'متوسط',
    'مكتمل جزئيًا'
  ];
  final List<String> _cities = const ['الكل', 'غريان', 'طرابلس', 'مصراتة'];
  final List<String> _donationTypes = const ['الكل', 'مالي', 'عيني'];
  final List<String> _progressFilters = const [
    'الكل',
    'أقل من 50%',
    '50% فأكثر',
    'قريب من الاكتمال'
  ];
  final List<Map<String, dynamic>> _needs = const [
    {
      'orphanage': 'دار رعاية الأيتام - غريان',
      'title': 'مصاريف دراسية لخمسة طلاب',
      'city': 'غريان',
      'donationType': 'مالي',
      'urgency': 'عاجل',
      'raised': '3,250 د.ل',
      'target': '5,000 د.ل',
      'remaining': '1,750 د.ل',
      'progress': 0.65,
      'daysLeft': '3 أيام',
    },
    {
      'orphanage': 'جمعية كنف للأطفال',
      'title': 'سلات غذائية شهرية',
      'city': 'غريان',
      'donationType': 'عيني',
      'urgency': 'متوسط',
      'raised': '1,600 د.ل',
      'target': '4,000 د.ل',
      'remaining': '',
      'progress': 0.40,
      'daysLeft': '12 يوم',
    },
    {
      'orphanage': 'بيت الأمل للبنين',
      'title': 'كسوة وأحذية للأطفال',
      'city': 'غريان',
      'donationType': 'عيني',
      'urgency': 'مكتمل جزئيًا',
      'raised': '5,100 د.ل',
      'target': '6,000 د.ل',
      'remaining': '',
      'progress': 0.85,
      'daysLeft': '5 أيام',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredResults;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: donorMobileAppBar(title: 'البحث عن احتياج'),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  _buildSearchField(),
                  const SizedBox(height: 14),
                  _FilterSection(
                    title: 'المدينة',
                    children: _buildFilterChips(
                      values: _cities,
                      activeValue: _activeCityFilter,
                      onSelected: (value) =>
                          setState(() => _activeCityFilter = value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _FilterSection(
                    title: 'نوع التبرع',
                    children: _buildFilterChips(
                      values: _donationTypes,
                      activeValue: _activeDonationTypeFilter,
                      onSelected: (value) =>
                          setState(() => _activeDonationTypeFilter = value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _FilterSection(
                    title: 'مستوى الأولوية',
                    children: _buildFilterChips(
                      values: _urgencies,
                      activeValue: _activeUrgencyFilter,
                      onSelected: (value) =>
                          setState(() => _activeUrgencyFilter = value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _FilterSection(
                    title: 'نسبة الإنجاز',
                    children: _buildFilterChips(
                      values: _progressFilters,
                      activeValue: _activeProgressFilter,
                      onSelected: (value) =>
                          setState(() => _activeProgressFilter = value),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    results.isEmpty
                        ? 'لا توجد نتائج مطابقة'
                        : '${results.length} نتائج مناسبة',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDarkPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (results.isEmpty)
                    _EmptySearch(onReset: _resetFilters)
                  else
                    ...results.map(_buildResultCard),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredResults {
    final query = _searchController.text.trim();
    return _needs.where((need) {
      final matchesUrgency = _activeUrgencyFilter == 'الكل' ||
          need['urgency'] == _activeUrgencyFilter;
      final matchesCity =
          _activeCityFilter == 'الكل' || need['city'] == _activeCityFilter;
      final matchesDonationType = _activeDonationTypeFilter == 'الكل' ||
          need['donationType'] == _activeDonationTypeFilter;
      final matchesProgress = _matchesProgress(need['progress'] as double);
      final matchesQuery = query.isEmpty ||
          need['title'].toString().contains(query) ||
          need['orphanage'].toString().contains(query);
      return matchesUrgency &&
          matchesCity &&
          matchesDonationType &&
          matchesProgress &&
          matchesQuery;
    }).toList();
  }

  bool _matchesProgress(double progress) {
    switch (_activeProgressFilter) {
      case 'أقل من 50%':
        return progress < 0.5;
      case '50% فأكثر':
        return progress >= 0.5;
      case 'قريب من الاكتمال':
        return progress >= 0.8;
      default:
        return true;
    }
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _activeUrgencyFilter = 'الكل';
      _activeCityFilter = 'الكل';
      _activeDonationTypeFilter = 'الكل';
      _activeProgressFilter = 'الكل';
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(fontFamily: 'Tajawal', fontSize: 15),
      decoration: InputDecoration(
        hintText: 'ابحث باسم الدار أو نوع الاحتياج',
        hintStyle: const TextStyle(
            fontFamily: 'Tajawal', color: AppColors.textDarkMuted),
        prefixIcon: const Icon(Icons.manage_search_rounded,
            color: AppColors.brandOrange),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'مسح البحث',
                icon: const Icon(Icons.close_rounded,
                    color: AppColors.textDarkMuted),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.innerBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide:
              const BorderSide(color: AppColors.brandOrange, width: 1.4),
        ),
      ),
    );
  }

  List<Widget> _buildFilterChips({
    required List<String> values,
    required String activeValue,
    required ValueChanged<String> onSelected,
  }) {
    return values.map((value) {
      final selected = activeValue == value;
      return ChoiceChip(
        label: Text(value),
        selected: selected,
        showCheckmark: false,
        selectedColor: AppColors.brandOrange,
        backgroundColor: Colors.white,
        side: BorderSide(
            color: selected ? AppColors.brandOrange : AppColors.innerBorder),
        labelStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
          color: selected ? Colors.white : AppColors.textDarkSecondary,
        ),
        onSelected: (_) => onSelected(value),
      );
    }).toList();
  }

  Widget _buildResultCard(Map<String, dynamic> need) {
    final progress = (need['progress'] as num).toDouble().clamp(0.0, 1.0);
    final percentage = (progress * 100).round();
    final urgency = need['urgency'] as String;
    final donationType = need['donationType'] as String;
    final priorityColor = _priorityColor(urgency);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () =>
              Navigator.pushNamed(context, '/need_details', arguments: need),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.innerBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: donationType == 'مالي'
                            ? AppColors.brandOrangeLight
                            : AppColors.successGreenLight,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        donationType == 'مالي'
                            ? Icons.savings_rounded
                            : Icons.inventory_2_rounded,
                        color: donationType == 'مالي'
                            ? AppColors.brandOrange
                            : AppColors.successGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            need['title'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDarkPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            need['orphanage'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 13,
                              color: Color(0xFF526577),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_left_rounded,
                        color: AppColors.textDarkMuted),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _MiniBadge(
                      label: urgency,
                      color: priorityColor,
                      icon: urgency == 'عاجل'
                          ? Icons.priority_high_rounded
                          : Icons.flag_rounded,
                    ),
                    _MiniBadge(
                      label: '$percentage% مكتمل',
                      color: AppColors.skyBlueDark,
                      icon: Icons.insights_rounded,
                    ),
                    Text(
                      donationType == 'مالي'
                          ? 'متبقي ${need['remaining']}'
                          : 'متبقي ${need['daysLeft']}',
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF526577),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: AlwaysStoppedAnimation<Color>(priorityColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _priorityColor(String urgency) {
    if (urgency == 'عاجل') return AppColors.brandOrangeDark;
    if (urgency == 'مكتمل جزئيًا') return AppColors.skyBlueDark;
    return AppColors.successGreen;
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: AppColors.textDarkPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: children),
      ],
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.innerBorder),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded,
              size: 48, color: AppColors.textDarkMuted),
          const SizedBox(height: 10),
          const Text(
            'جرّب كلمة أبسط أو غيّر فلتر الاستعجال.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14,
              color: AppColors.textDarkSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh_rounded, size: 17),
            label: const Text('إعادة ضبط البحث'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.brandOrangeDark,
              textStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
