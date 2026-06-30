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
    'قريب من الاكتمال',
  ];

  // TODO: Replace mock search results with backend/AppProvider donor needs.
  final List<Map<String, dynamic>> _needs = const [
    {
      'orphanage': 'دار الأمان لرعاية الأيتام - غريان',
      'title': 'مصاريف دراسية لخمسة طلاب',
      'city': 'غريان',
      'category': 'مالي',
      'donationType': 'مالي',
      'urgency': 'عاجل',
      'raised': '3,250 د.ل',
      'target': '5,000 د.ل',
      'remaining': '1,750 د.ل',
      'progress': 0.65,
      'daysLeft': '3 أيام',
      'status': 'قيد التنفيذ',
      'description': 'دعم تعليمي مباشر يساعد الأطفال على مواصلة الدراسة.',
    },
    {
      'orphanage': 'جمعية كنف للأطفال',
      'title': 'سلات غذائية شهرية',
      'city': 'غريان',
      'category': 'غذائي',
      'donationType': 'عيني',
      'urgency': 'متوسط',
      'raised': '1,600 د.ل',
      'target': '4,000 د.ل',
      'remaining': '2,400 د.ل',
      'progress': 0.40,
      'daysLeft': '12 يوم',
      'status': 'جديد',
      'description': 'مواد غذائية أساسية لوجبات الأطفال اليومية.',
    },
    {
      'orphanage': 'بيت الأمل للبنين',
      'title': 'كسوة وأحذية للأطفال',
      'city': 'غريان',
      'category': 'كسوة',
      'donationType': 'عيني',
      'urgency': 'مكتمل جزئيًا',
      'raised': '5,100 د.ل',
      'target': '6,000 د.ل',
      'remaining': '900 د.ل',
      'progress': 0.85,
      'daysLeft': '5 أيام',
      'status': 'قيد التنفيذ',
      'description': 'ملابس وأحذية مناسبة تحفظ راحة الأطفال وكرامتهم.',
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
        appBar: donorMobileAppBar(
          title: 'البحث عن احتياج',
          leading: donorBackButton(context),
        ),
        body: Stack(
          children: [
            const Positioned.fill(child: DonorBackground()),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: donorMobileMaxWidth),
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
                        title: 'الأولوية',
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
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              results.isEmpty
                                  ? 'لا توجد نتائج مطابقة'
                                  : '${results.length} نتائج مناسبة',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textDarkPrimary,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _resetFilters,
                            icon: const Icon(Icons.refresh_rounded, size: 17),
                            label: const Text('مسح الفلاتر'),
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
                      const SizedBox(height: 8),
                      if (results.isEmpty)
                        DonorEmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'لم نجد احتياجًا مطابقًا',
                          message: 'جرّب كلمة أبسط أو امسح الفلاتر الحالية.',
                          actionLabel: 'إعادة ضبط البحث',
                          onAction: _resetFilters,
                        )
                      else
                        ...results.map(_buildResultCard),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
        prefixIcon:
            const Icon(Icons.search_rounded, color: AppColors.brandOrange),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
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
        suffixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.innerBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
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
    final priorityColor = donorStatusColor(urgency);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DonorCard(
        onTap: () =>
            Navigator.pushNamed(context, '/need_details', arguments: need),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DonorIconBox(
                  icon: donationType == 'مالي'
                      ? Icons.savings_outlined
                      : Icons.inventory_2_outlined,
                  color: donationType == 'مالي'
                      ? AppColors.brandOrange
                      : AppColors.successGreen,
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
                          fontWeight: FontWeight.w900,
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
                          color: AppColors.textDarkSecondary,
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
                DonorBadge(
                  label: urgency,
                  color: priorityColor,
                  icon: urgency == 'عاجل'
                      ? Icons.priority_high_rounded
                      : Icons.flag_outlined,
                ),
                DonorBadge(
                  label: '$percentage% مكتمل',
                  color: AppColors.skyBlueDark,
                  icon: Icons.insights_outlined,
                ),
                DonorBadge(
                  label: donationType == 'مالي'
                      ? 'متبقي ${need['remaining']}'
                      : 'متبقي ${need['daysLeft']}',
                  color: AppColors.textDarkSecondary,
                  icon: Icons.timer_outlined,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                backgroundColor: AppColors.surfaceLight,
                valueColor: AlwaysStoppedAnimation<Color>(priorityColor),
              ),
            ),
          ],
        ),
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
            fontWeight: FontWeight.w900,
            color: AppColors.textDarkPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: children),
      ],
    );
  }
}
