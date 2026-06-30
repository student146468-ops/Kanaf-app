import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../settings/shared_mobile_ui.dart';

class SearchFilterResultsScreen extends StatefulWidget {
  const SearchFilterResultsScreen({super.key});

  @override
  State<SearchFilterResultsScreen> createState() =>
      _SearchFilterResultsScreenState();
}

class _SearchFilterResultsScreenState extends State<SearchFilterResultsScreen> {
  final TextEditingController _searchController =
      TextEditingController(text: 'كسوة شتوية');
  String _selectedType = 'الكل';
  String _selectedCity = 'غريان';

  final List<String> _types = const ['الكل', 'مالي', 'عيني', 'تطوع'];
  final List<String> _cities = const ['غريان', 'طرابلس', 'بنغازي'];

  // TODO: Replace with AppProvider donations/needs search results when available.
  final List<Map<String, dynamic>> _results = const [
    {
      'title': 'تأمين الكسوة الشتوية لـ 25 طفلًا',
      'orphanage': 'دار الأمان لرعاية الأيتام',
      'category': 'عيني',
      'progress': 0.34,
      'remaining': '2,300 د.ل',
      'daysLeft': '6 أيام',
      'priority': 'عاجل',
      'city': 'غريان',
    },
    {
      'title': 'حملة الأغطية الدافئة والمستلزمات',
      'orphanage': 'مؤسسة كنف الطفولة الإنسانية',
      'category': 'مالي',
      'progress': 0.75,
      'remaining': '800 د.ل',
      'daysLeft': 'يومان',
      'priority': 'قيد التنفيذ',
      'city': 'غريان',
    },
    {
      'title': 'جلسات دعم تعليمي أسبوعية',
      'orphanage': 'جمعية غريان الخيرية للأطفال',
      'category': 'تطوع',
      'progress': 0.2,
      'remaining': '4 مقاعد',
      'daysLeft': '9 أيام',
      'priority': 'جديد',
      'city': 'غريان',
    },
  ];

  List<Map<String, dynamic>> get _filteredResults {
    final query = _searchController.text.trim();
    return _results.where((result) {
      final matchesType =
          _selectedType == 'الكل' || result['category'] == _selectedType;
      final matchesCity = result['city'] == _selectedCity;
      final matchesQuery = query.isEmpty ||
          (result['title'] as String).contains(query) ||
          (result['orphanage'] as String).contains(query);
      return matchesType && matchesCity && matchesQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedType = 'الكل';
      _selectedCity = 'غريان';
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredResults;
    return KanafPage(
      title: 'نتائج البحث',
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: KanafCircleButton(
            icon: Icons.refresh_rounded,
            onTap: _clearFilters,
            color: AppColors.brandOrange,
          ),
        ),
      ],
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            kanafHorizontalPadding,
            8,
            kanafHorizontalPadding,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SearchField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              _FilterRow(
                values: _types,
                selectedValue: _selectedType,
                onSelected: (value) => setState(() => _selectedType = value),
              ),
              const SizedBox(height: 8),
              _FilterRow(
                values: _cities,
                selectedValue: _selectedCity,
                onSelected: (value) => setState(() => _selectedCity = value),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: Text('نتائج مطابقة', style: kanafSectionTitleStyle),
                  ),
                  KanafBadge(
                    label: '${results.length} نتيجة',
                    color: AppColors.brandOrange,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: results.isEmpty
                    ? KanafEmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'لا توجد نتائج مطابقة',
                        message:
                            'جرّب تغيير كلمات البحث أو مسح الفلاتر الحالية.',
                        actionLabel: 'مسح الفلاتر',
                        onAction: _clearFilters,
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _ResultCard(result: results[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(
        fontFamily: 'Tajawal',
        color: AppColors.textDarkPrimary,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: 'ابحث عن احتياج أو دار رعاية',
        hintStyle: kanafMutedStyle,
        prefixIcon: const Icon(
          Icons.manage_search_rounded,
          color: AppColors.brandOrange,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        filled: true,
        fillColor: Colors.white,
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

class _FilterRow extends StatelessWidget {
  final List<String> values;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const _FilterRow({
    required this.values,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final value = values[index];
          final selected = value == selectedValue;
          return ChoiceChip(
            label: Text(value),
            selected: selected,
            onSelected: (_) => onSelected(value),
            showCheckmark: false,
            labelStyle: TextStyle(
              fontFamily: 'Tajawal',
              color: selected ? Colors.white : AppColors.textDarkSecondary,
              fontWeight: FontWeight.w900,
              fontSize: 12.5,
            ),
            selectedColor: AppColors.brandOrange,
            backgroundColor: Colors.white,
            side: BorderSide(
              color: selected ? AppColors.brandOrange : AppColors.innerBorder,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          );
        },
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final Map<String, dynamic> result;

  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final progress = result['progress'] as double;
    final progressText = '${(progress * 100).round()}%';
    final status = result['priority'] as String;
    return KanafCard(
      onTap: () => Navigator.of(context).pushNamed('/need_details'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KanafIconBox(
                icon: _iconFor(result['category'] as String),
                color: kanafStatusColor(status),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result['title'] as String,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textDarkPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(result['orphanage'] as String, style: kanafBodyStyle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceLight,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.brandOrange),
              minHeight: 7,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              KanafBadge(
                label: status,
                color: kanafStatusColor(status),
                icon: Icons.flag_outlined,
              ),
              KanafMetaChip(
                icon: Icons.show_chart_rounded,
                label: progressText,
                color: AppColors.brandOrange,
              ),
              KanafMetaChip(
                icon: Icons.payments_outlined,
                label: result['remaining'] as String,
                color: AppColors.skyBlueDark,
              ),
              KanafMetaChip(
                icon: Icons.event_available_outlined,
                label: result['daysLeft'] as String,
                color: AppColors.successGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String category) {
    switch (category) {
      case 'مالي':
        return Icons.payments_outlined;
      case 'تطوع':
        return Icons.volunteer_activism_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }
}
