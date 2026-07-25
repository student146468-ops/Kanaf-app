import 'package:flutter/material.dart';

import '../../models/need_model.dart';
import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _activeFilter = 'الكل';
  bool _hasLoadedNeeds = false;

  static const Color _primaryOrange = Color(0xFFFF8C42);
  static const Color _screenBackground = Color(0xFFF5F5F5);
  static const Color _softUrgent = Color(0xFFE36F25);
  static const Color _softCompleted = Color(0xFF4F8A64);

  final List<String> _filters = const [
    'الكل',
    'عاجل',
    'قيد التنفيذ',
    'مكتمل',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoadedNeeds) return;
    _hasLoadedNeeds = true;
    AppProviderScope.of(context).fetchNeeds();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final results = _filteredResults;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _screenBackground,
        appBar: const DonorAppBar(
          title: 'قائمة الاحتياجات',
        ),
        body: SafeArea(
          top: false,
          child: DonorMobileFrame(
            child: Column(
              children: [
                _NeedsFilterBar(
                  filters: _filters,
                  activeFilter: _activeFilter,
                  onSelected: (value) => setState(() => _activeFilter = value),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    DonorSpacing.md,
                    20,
                    DonorSpacing.sm,
                  ),
                  child: _buildSearchField(),
                ),
                Expanded(
                  child: provider.isLoading && provider.needs.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: _primaryOrange,
                          ),
                        )
                      : results.isEmpty
                          ? DonorEmptyState(
                              icon: Icons.search_off_rounded,
                              title: 'لم نجد احتياجًا مطابقًا',
                              message:
                                  'جرّب كلمة أبسط أو اختر فلترًا آخر من القائمة.',
                              actionLabel: 'إعادة ضبط البحث',
                              onAction: _resetFilters,
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 24),
                              itemBuilder: (context, index) {
                                return _NeedListCard(need: results[index]);
                              },
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: DonorSpacing.lg),
                              itemCount: results.length,
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredResults {
    final needs = AppProviderScope.of(context).needs.map(_needToMap).toList();
    final query = _searchController.text.trim();
    return needs.where((need) {
      final status = need['status'].toString();
      final urgency = need['urgency'].toString();
      final progress = (need['progress'] as num).toDouble();
      final matchesFilter = switch (_activeFilter) {
        'عاجل' => urgency == 'عاجل',
        'قيد التنفيذ' => status == 'قيد التنفيذ',
        'مكتمل' => status.contains('مكتمل') || progress >= 1,
        _ => true,
      };
      final matchesQuery = query.isEmpty ||
          need['title'].toString().contains(query) ||
          need['orphanage'].toString().contains(query) ||
          need['category'].toString().contains(query);
      return matchesFilter && matchesQuery;
    }).toList();
  }

  Map<String, dynamic> _needToMap(NeedModel need) {
    final target = _quantityValue(need.requiredQuantity);
    final raised = need.fulfilledQuantity;
    final progress = target <= 0 ? 0.0 : raised / target;
    return {
      'orphanage': 'كنف',
      'title': need.title,
      'city': 'ليبيا',
      'category': _categoryLabel(need.category),
      'donationType': need.needType.isEmpty ? 'عام' : need.needType,
      'urgency': _priorityLabel(need.priority),
      'raised': _amountLabel(raised),
      'target': need.requiredQuantity.isEmpty
          ? _amountLabel(target)
          : need.requiredQuantity,
      'remaining': target <= 0
          ? 'غير محدد'
          : _amountLabel((target - raised).clamp(0, target)),
      'progress': progress.clamp(0.0, 1.0),
      'daysLeft': _daysLeftLabel(need.deadline),
      'status': need.statusLabel,
      'description': need.description,
      'image': _imageForCategory(need.category),
    };
  }

  double _quantityValue(String value) {
    final match = RegExp(r'\d+(\.\d+)?').firstMatch(value.replaceAll(',', ''));
    return double.tryParse(match?.group(0) ?? '') ?? 0;
  }

  String _amountLabel(num value) {
    final number = value.toDouble();
    if (number == number.roundToDouble()) return number.round().toString();
    return number.toStringAsFixed(2);
  }

  String _priorityLabel(String value) {
    if (value == 'urgent') return 'عاجل';
    if (value == 'low') return 'منخفض';
    return 'متوسط';
  }

  String _categoryLabel(String value) {
    switch (value) {
      case 'food':
        return 'غذائي';
      case 'clothes':
        return 'كسوة';
      case 'medical':
        return 'صحي';
      case 'education':
        return 'تعليمي';
      default:
        return value.isEmpty ? 'عام' : value;
    }
  }

  String _daysLeftLabel(DateTime? deadline) {
    if (deadline == null) return 'غير محدد';
    final days = deadline.difference(DateTime.now()).inDays;
    if (days <= 0) return 'اليوم';
    if (days == 1) return 'يوم واحد';
    return '$days يوم';
  }

  String _imageForCategory(String category) {
    if (category == 'food') return 'assets/images/c.png';
    if (category == 'clothes') return 'assets/images/a.png';
    return 'assets/images/b.png';
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _activeFilter = 'الكل';
    });
  }

  Widget _buildSearchField() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        textAlign: TextAlign.start,
        style: DonorTextStyles.body.copyWith(
          fontSize: 14.5,
          color: AppColors.textDarkPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'ابحث باسم الدار أو نوع الاحتياج',
          hintStyle: DonorTextStyles.muted.copyWith(
            color: AppColors.textDarkMuted,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: _primaryOrange,
            size: 21,
          ),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'مسح البحث',
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textDarkMuted,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: _primaryOrange, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class _NeedsFilterBar extends StatelessWidget {
  final List<String> filters;
  final String activeFilter;
  final ValueChanged<String> onSelected;

  const _NeedsFilterBar({
    required this.filters,
    required this.activeFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 6),
        itemBuilder: (context, index) {
          final label = filters[index];
          final selected = label == activeFilter;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelected(label),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 42,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: selected
                      ? _SearchFilterScreenState._primaryOrange
                      : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Text(
                  label,
                  style: DonorTextStyles.button.copyWith(
                    fontSize: 12.5,
                    color:
                        selected ? Colors.white : AppColors.textDarkSecondary,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: DonorSpacing.xs),
        itemCount: filters.length,
      ),
    );
  }
}

class _NeedListCard extends StatelessWidget {
  final Map<String, dynamic> need;

  const _NeedListCard({required this.need});

  @override
  Widget build(BuildContext context) {
    final progress = (need['progress'] as num).toDouble().clamp(0.0, 1.0);
    final percentage = (progress * 100).round();
    final status = need['status'] as String;
    final urgency = need['urgency'] as String;
    final badgeLabel = status.contains('مكتمل') ? 'مكتمل' : urgency;
    final badgeColor = _badgeColor(badgeLabel);

    return _SoftCard(
      onTap: () =>
          Navigator.pushNamed(context, '/need_details', arguments: need),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _NeedCardContent(
                  need: need,
                  badgeLabel: badgeLabel,
                  badgeColor: badgeColor,
                  progress: progress,
                  percentage: percentage,
                ),
              ),
              const SizedBox(width: 12),
              _NeedImage(imagePath: need['image'] as String),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/need_details',
              arguments: need,
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: _SearchFilterScreenState._primaryOrange,
              foregroundColor: Colors.white,
              textStyle: DonorTextStyles.button.copyWith(fontSize: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              elevation: 0,
            ),
            child: const Text('تبرع الآن'),
          ),
        ],
      ),
    );
  }

  Color _badgeColor(String label) {
    if (label.contains('مكتمل')) {
      return _SearchFilterScreenState._softCompleted;
    }
    if (label.contains('عاجل') || label.contains('قيد التنفيذ')) {
      return _SearchFilterScreenState._softUrgent;
    }
    return AppColors.textDarkSecondary;
  }
}

class _NeedCardContent extends StatelessWidget {
  final Map<String, dynamic> need;
  final String badgeLabel;
  final Color badgeColor;
  final double progress;
  final int percentage;

  const _NeedCardContent({
    required this.need,
    required this.badgeLabel,
    required this.badgeColor,
    required this.progress,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                need['title'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: DonorTextStyles.title.copyWith(
                  fontSize: 14.8,
                  height: 1.35,
                  color: AppColors.textDarkPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _NeedStatusBadge(label: badgeLabel, color: badgeColor),
          ],
        ),
        const SizedBox(height: 7),
        Text(
          need['orphanage'] as String,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: DonorTextStyles.muted.copyWith(
            color: AppColors.textDarkSecondary,
            fontSize: 12.8,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          need['city'] as String,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: DonorTextStyles.muted.copyWith(
            color: AppColors.textDarkMuted,
            fontSize: 12.5,
          ),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'المبلغ الإجمالي: ',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              TextSpan(text: need['target'] as String),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: DonorTextStyles.muted.copyWith(
            fontSize: 13,
            color: AppColors.textDarkSecondary,
          ),
        ),
        const SizedBox(height: 13),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'المبلغ المجمع ${need['raised']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DonorTextStyles.muted.copyWith(
                    fontSize: 12.8,
                    fontWeight: FontWeight.w900,
                    color: _SearchFilterScreenState._primaryOrange,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$percentage%',
                textDirection: TextDirection.ltr,
                style: DonorTextStyles.badge.copyWith(
                  fontSize: 12,
                  color: AppColors.textDarkPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _RtlProgressBar(value: progress),
        const SizedBox(height: 8),
        Text(
          'متبقي ${need['daysLeft']}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: DonorTextStyles.muted.copyWith(
            fontSize: 12,
            color: AppColors.textDarkSecondary,
          ),
        ),
      ],
    );
  }
}

class _SoftCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _SoftCard({
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: card,
      ),
    );
  }
}

class _NeedStatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _NeedStatusBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: DonorTextStyles.badge.copyWith(
          fontSize: 11,
          color: color,
        ),
      ),
    );
  }
}

class _RtlProgressBar extends StatelessWidget {
  final double value;

  const _RtlProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 8,
        color: const Color(0xFFECECEC),
        alignment: Alignment.centerRight,
        child: FractionallySizedBox(
          alignment: Alignment.centerRight,
          widthFactor: value,
          child: Container(
            decoration: const BoxDecoration(
              color: _SearchFilterScreenState._primaryOrange,
            ),
          ),
        ),
      ),
    );
  }
}

class _NeedImage extends StatelessWidget {
  final String imagePath;

  const _NeedImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.asset(
        imagePath,
        width: 104,
        height: 120,
        fit: BoxFit.cover,
      ),
    );
  }
}
