import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/need_model.dart';
import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class SupporterHomeScreen extends StatefulWidget {
  const SupporterHomeScreen({super.key});

  @override
  State<SupporterHomeScreen> createState() => _SupporterHomeScreenState();
}

class _SupporterHomeScreenState extends State<SupporterHomeScreen> {
  static const int _initialSliderPage = 3000;
  static const List<String> _sliderImages = [
    'assets/images/a.png',
    'assets/images/b.png',
    'assets/images/c.png',
  ];

  late final PageController _sliderController;
  Timer? _sliderTimer;
  int _currentSlide = _initialSliderPage;
  bool _hasLoadedNeeds = false;

  static const Color _homeBackground = Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    _sliderController = PageController(initialPage: _initialSliderPage);
    _sliderTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_sliderController.hasClients) return;
      _sliderController.animateToPage(
        _currentSlide + 1,
        duration: const Duration(milliseconds: 560),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoadedNeeds) return;
    _hasLoadedNeeds = true;
    AppProviderScope.of(context).fetchNeeds();
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _sliderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final needs = provider.needs.map(_needToCardData).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _homeBackground,
        appBar: const DonorAppBar(
          title: 'الرئيسية',
        ),
        body: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(color: _homeBackground),
              ),
            ),
            SafeArea(
              top: false,
              child: DonorMobileFrame(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                  children: [
                    _HeroSlider(
                      controller: _sliderController,
                      images: _sliderImages,
                      currentIndex: _currentSlide % _sliderImages.length,
                      onPageChanged: (page) {
                        setState(() => _currentSlide = page);
                      },
                    ),
                    const SizedBox(height: 22),
                    _NeedsSectionHeader(
                      onShowAll: () =>
                          Navigator.pushNamed(context, '/search_filter'),
                    ),
                    const SizedBox(height: 16),
                    if (provider.isLoading && needs.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.brandOrange,
                          ),
                        ),
                      )
                    else if (provider.errorMessage != null && needs.isEmpty)
                      DonorEmptyState(
                        icon: Icons.cloud_off_rounded,
                        title: 'تعذر جلب الاحتياجات',
                        message: provider.errorMessage!,
                        actionLabel: 'إعادة المحاولة',
                        onAction: () => provider.fetchNeeds(),
                      )
                    else if (needs.isEmpty)
                      DonorEmptyState(
                        icon: Icons.volunteer_activism_outlined,
                        title: 'لا توجد احتياجات منشورة حاليًا',
                        message:
                            'ستظهر هنا الاحتياجات الموجودة في قاعدة البيانات عند نشرها.',
                        actionLabel: 'تحديث',
                        onAction: () => provider.fetchNeeds(),
                      )
                    else
                      ...needs.map(
                        (need) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _UrgentNeedCard(need: need),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: DonorBottomNavigationBar(
          currentIndex: 0,
          onTap: (index) => donorNavigateByBottomIndex(context, index),
        ),
      ),
    );
  }

  Map<String, dynamic> _needToCardData(NeedModel need) {
    final targetValue = _quantityValue(need.requiredQuantity);
    final raisedValue = need.fulfilledQuantity;
    final progress = targetValue <= 0 ? 0.0 : raisedValue / targetValue;
    final remaining = targetValue <= 0
        ? need.requiredQuantity
        : _amountLabel((targetValue - raisedValue).clamp(0, targetValue));

    return {
      'id': need.id.toString(),
      'orphanage': 'كنف',
      'location': 'ليبيا',
      'category': _categoryLabel(need.category),
      'title': need.title,
      'progress': progress.clamp(0.0, 1.0),
      'raised': _amountLabel(raisedValue),
      'target': need.requiredQuantity.isEmpty
          ? _amountLabel(targetValue)
          : need.requiredQuantity,
      'remaining': remaining.isEmpty ? 'غير محدد' : remaining,
      'urgency': _priorityLabel(need.priority),
      'daysLeft': _daysLeftLabel(need.deadline),
      'status': need.statusLabel,
      'description': need.description,
      'image': _imageForCategory(need.category),
    };
  }

  double _quantityValue(String value) {
    final normalized = value.replaceAll(',', '');
    final match = RegExp(r'\d+(\.\d+)?').firstMatch(normalized);
    return double.tryParse(match?.group(0) ?? '') ?? 0;
  }

  String _amountLabel(num value) {
    final number = value.toDouble();
    if (number == 0) return '0';
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
    if (category == 'food') return 'assets/images/a.png';
    if (category == 'clothes') return 'assets/images/c.png';
    return 'assets/images/b.png';
  }
}

class _HeroSlider extends StatelessWidget {
  final PageController controller;
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const _HeroSlider({
    required this.controller,
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 190,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.075),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: PageView.builder(
              controller: controller,
              physics: const BouncingScrollPhysics(),
              onPageChanged: onPageChanged,
              itemBuilder: (context, index) {
                final imagePath = images[index % images.length];
                return Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            images.length,
            (index) {
              final selected = currentIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: selected ? 18 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFFF8C42)
                      : const Color(0xFFD8D8D8),
                  borderRadius: BorderRadius.circular(99),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NeedsSectionHeader extends StatelessWidget {
  final VoidCallback onShowAll;

  const _NeedsSectionHeader({required this.onShowAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'احتياجات عاجلة يمكن دعمها الآن',
                style: DonorTextStyles.sectionTitle.copyWith(
                  fontSize: 17,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'تصفح الاحتياجات أو اختر تصنيفًا للتركيز على ما تريد دعمه.',
                style: DonorTextStyles.muted.copyWith(
                  fontSize: 12.8,
                  height: 1.4,
                  color: AppColors.textDarkSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _ShowAllButton(onTap: onShowAll),
      ],
    );
  }
}

class _ShowAllButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ShowAllButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 13),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.grid_view_rounded,
                color: Color(0xFFFF8C42),
                size: 17,
              ),
              const SizedBox(width: 6),
              Text(
                'عرض الكل',
                style: DonorTextStyles.button.copyWith(
                  fontSize: 12.5,
                  color: AppColors.textDarkPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UrgentNeedCard extends StatelessWidget {
  const _UrgentNeedCard({required this.need});

  final Map<String, dynamic> need;

  @override
  Widget build(BuildContext context) {
    final progress = (need['progress'] as num).toDouble().clamp(0.0, 1.0);
    final percentage = (progress * 100).round();
    final urgency = need['urgency'] as String;
    final imagePath = need['image'] as String;

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
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
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
                              style: DonorTextStyles.title.copyWith(
                                fontSize: 14.8,
                                height: 1.35,
                                color: AppColors.textDarkPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _UrgencyBadge(label: urgency),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        need['orphanage'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DonorTextStyles.muted.copyWith(
                          fontSize: 12.8,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDarkSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        need['location'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DonorTextStyles.muted.copyWith(
                          fontSize: 12.5,
                          color: AppColors.textDarkMuted,
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
                        textAlign: TextAlign.right,
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
                                  color: const Color(0xFFFF8C42),
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
                      Row(
                        children: [
                          Text(
                            'متبقي ${need['daysLeft']}',
                            style: DonorTextStyles.muted.copyWith(
                              fontSize: 12,
                              color: AppColors.textDarkSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  imagePath,
                  width: 104,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
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
              backgroundColor: const Color(0xFFFF8C42),
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

class _UrgencyBadge extends StatelessWidget {
  final String label;

  const _UrgencyBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final color = _badgeColor(label);

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

  Color _badgeColor(String value) {
    if (value.contains('عاجل')) return const Color(0xFFE36F25);
    if (value.contains('متوسط')) return const Color(0xFFC98B22);
    return const Color(0xFF3E9B62);
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
              color: Color(0xFFFF8C42),
            ),
          ),
        ),
      ),
    );
  }
}
