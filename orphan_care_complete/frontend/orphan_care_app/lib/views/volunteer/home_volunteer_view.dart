import 'dart:async';

import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import 'volunteer_ui.dart';

const String _opportunitiesTitle = 'فرص تطوع جديدة';
const String _filterActionLabel = 'عرض الكل';
const String _upcomingActivitiesTitle = 'الأنشطة القادمة';
const String _applyButtonLabel = 'تطوع الآن';

const Color _primaryOrange = Color(0xFFFF8C42);
const Color _textPrimary = Color(0xFF1E1E1E);
const Color _textSecondary = Color(0xFF6B7280);
const Color _softBorder = Color(0xFFEAEAEA);
const double _pagePadding = 24;

const List<String> _sliderImagePaths = [
  'assets/images/image1.png',
  'assets/images/image2.png',
  'assets/images/image3.png',
];

const List<String> _opportunityImagePaths = [
  'assets/images/image4.png',
  'assets/images/image5.png',
  'assets/images/image6.png',
];

class HomeVolunteerView extends StatefulWidget {
  const HomeVolunteerView({super.key});

  @override
  State<HomeVolunteerView> createState() => _HomeVolunteerViewState();
}

class _HomeVolunteerViewState extends State<HomeVolunteerView> {
  bool _hasLoadedOpportunities = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoadedOpportunities) return;
    _hasLoadedOpportunities = true;
    AppProviderScope.of(context).fetchVolunteerOpportunities();
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final opportunities =
        provider.volunteerOpportunities.map(_opportunityToCardData).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: VolunteerMobileFrame(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(volunteerAppBarHeight),
            child: VolunteerTopBar(
              title: 'الرئيسية',
              showBack: false,
            ),
          ),
          body: Stack(
            children: [
              SafeArea(
                top: false,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          _pagePadding,
                          16,
                          _pagePadding,
                          0,
                        ),
                        child: _VolunteerImageSlider(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          _pagePadding,
                          32,
                          _pagePadding,
                          16,
                        ),
                        child: _OpportunitiesSectionHeader(
                          title: _opportunitiesTitle,
                          actionLabel: _filterActionLabel,
                          onAction: () => Navigator.of(
                            context,
                          ).pushNamed('/volunteer_search'),
                        ),
                      ),
                    ),
                    if (provider.isLoading && opportunities.isEmpty)
                      const SliverToBoxAdapter(
                        child: _VolunteerStateMessage(
                          icon: Icons.hourglass_empty_rounded,
                          title: 'جار تحميل فرص التطوع',
                        ),
                      )
                    else if (provider.errorMessage != null &&
                        opportunities.isEmpty)
                      SliverToBoxAdapter(
                        child: _VolunteerStateMessage(
                          icon: Icons.cloud_off_rounded,
                          title: 'تعذر جلب فرص التطوع',
                          message: provider.errorMessage,
                          actionLabel: 'إعادة المحاولة',
                          onAction: () =>
                              provider.fetchVolunteerOpportunities(),
                        ),
                      )
                    else if (opportunities.isEmpty)
                      SliverToBoxAdapter(
                        child: _VolunteerStateMessage(
                          icon: Icons.volunteer_activism_outlined,
                          title: 'لا توجد فرص تطوع منشورة حاليًا',
                          message:
                              'ستظهر هنا الفرص الموجودة في قاعدة البيانات عند نشرها.',
                          actionLabel: 'تحديث',
                          onAction: () =>
                              provider.fetchVolunteerOpportunities(),
                        ),
                      )
                    else
                      SliverList.separated(
                        itemCount: opportunities.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          final opportunity = opportunities[index];
                          final imagePath = _opportunityImagePaths[
                              index % _opportunityImagePaths.length];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: _pagePadding,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _OpportunityCard(
                                  opportunity: opportunity,
                                  imagePath: imagePath,
                                  onTap: () => Navigator.of(context).pushNamed(
                                    '/volunteer_opportunity_details',
                                    arguments: {
                                      'opportunity': opportunity,
                                      'imagePath': imagePath,
                                    },
                                  ),
                                ),
                                if (index == 0) ...[
                                  const SizedBox(height: 24),
                                  const _InlineSectionTitle(
                                    title: _upcomingActivitiesTitle,
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 88)),
                  ],
                ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: VolunteerBottomNavBar(selectedIndex: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _opportunityToCardData(Map<String, dynamic> item) {
    final requiredVolunteers = _asInt(item['required_volunteers'], fallback: 1);
    final currentVolunteers = _asInt(item['current_volunteers']);
    final availableSeats = (requiredVolunteers - currentVolunteers).clamp(
      0,
      requiredVolunteers,
    );
    final startDate = _asDate(item['start_date']);
    final location = _text(item['location'], fallback: 'كنف');

    return {
      'id': item['id'],
      'title': _text(item['title'], fallback: 'فرصة تطوع'),
      'organization': location,
      'city': location,
      'skill': _statusLabel(_text(item['status'], fallback: 'open')),
      'date': _dateLabel(startDate),
      'time': _timeLabel(startDate),
      'duration': 'حسب تفاصيل الفرصة',
      'seats': '$availableSeats من $requiredVolunteers متاح',
      'status': _statusLabel(_text(item['status'], fallback: 'open')),
      'location': location,
      'summary': _text(
        item['description'],
        fallback: 'فرصة تطوعية منشورة من قاعدة البيانات.',
      ),
      'tasks': const [
        'الالتزام بتفاصيل الفرصة والتعليمات المنشورة.',
        'التواصل باحترام والعمل بروح الفريق.',
      ],
      'skillsList': const [
        'المسؤولية والالتزام بالموعد.',
        'مهارات تواصل مناسبة لطبيعة النشاط.',
      ],
    };
  }

  String _text(dynamic value, {required String fallback}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  int _asInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  DateTime? _asDate(dynamic value) {
    final text = value?.toString();
    if (text == null || text.isEmpty) return null;
    return DateTime.tryParse(text);
  }

  String _dateLabel(DateTime? value) {
    if (value == null) return 'غير محدد';
    return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  }

  String _timeLabel(DateTime? value) {
    if (value == null) return 'غير محدد';
    return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }

  String _statusLabel(String value) {
    if (value == 'closed') return 'مغلقة';
    if (value == 'completed') return 'مكتملة';
    return 'متاحة';
  }
}

class _VolunteerStateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _VolunteerStateMessage({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_pagePadding, 16, _pagePadding, 0),
      child: VolunteerCard(
        child: Column(
          children: [
            VolunteerIconBox(icon: icon),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: volunteerSectionTitleStyle.copyWith(fontSize: 17),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: volunteerBodyStyle,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              VolunteerPrimaryButton(
                label: actionLabel!,
                icon: Icons.refresh_rounded,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OpportunitiesSectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _OpportunitiesSectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Vazirmatn',
              color: _textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: _primaryOrange,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            textStyle: const TextStyle(
              fontFamily: 'Vazirmatn',
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          child: Text(actionLabel),
        ),
      ],
    );
  }
}

class _InlineSectionTitle extends StatelessWidget {
  final String title;

  const _InlineSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: 'Vazirmatn',
        color: _textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _VolunteerImageSlider extends StatefulWidget {
  const _VolunteerImageSlider();

  @override
  State<_VolunteerImageSlider> createState() => _VolunteerImageSliderState();
}

class _VolunteerImageSliderState extends State<_VolunteerImageSlider> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_pageController.hasClients) return;
      final nextPage = (_currentPage + 1) % _sliderImagePaths.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            height: 150,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _sliderImagePaths.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                return Image.asset(
                  _sliderImagePaths[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_sliderImagePaths.length, (index) {
            final selected = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: selected ? 18 : 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: selected
                    ? _primaryOrange
                    : _textSecondary.withOpacity(0.25),
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _OpportunityImage extends StatelessWidget {
  final String imagePath;

  const _OpportunityImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        imagePath,
        width: 136,
        height: 124,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final Map<String, dynamic> opportunity;
  final String imagePath;
  final VoidCallback onTap;

  const _OpportunityCard({
    required this.opportunity,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: _softBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      opportunity['title']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 20,
                        height: 1.25,
                        fontWeight: FontWeight.w900,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      opportunity['summary']!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Vazirmatn',
                        color: _textSecondary,
                        fontSize: 14.5,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _OpportunityMetaItem(
                          icon: Icons.location_on_outlined,
                          label: opportunity['city']!,
                        ),
                        _OpportunityMetaItem(
                          icon: Icons.calendar_month_outlined,
                          label: opportunity['date']!,
                        ),
                        _OpportunityMetaItem(
                          icon: Icons.event_seat_outlined,
                          label: opportunity['seats']!,
                        ),
                        _OpportunityMetaItem(
                          icon: Icons.psychology_alt_outlined,
                          label: opportunity['skill']!,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _ApplyButton(onTap: onTap),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _OpportunityImage(imagePath: imagePath),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApplyButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ApplyButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
        child: const Text(_applyButtonLabel),
      ),
    );
  }
}

class _OpportunityMetaItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _OpportunityMetaItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 190),
      child: SizedBox(
        height: 32,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: _textSecondary, size: 15),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Vazirmatn',
                  color: _textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
