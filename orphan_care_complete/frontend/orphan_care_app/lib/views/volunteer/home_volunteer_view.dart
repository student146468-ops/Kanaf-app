import 'dart:async';

import 'package:flutter/material.dart';

import 'volunteer_ui.dart';

const String _welcomeTitle = 'مرحبًا ياسمين';
const String _homeSubtitle = 'ساهمي بوقتك ومهاراتك لصنع أثر حقيقي';
const String _opportunitiesTitle = 'فرص تطوع جديدة';
const String _filterActionLabel = 'عرض الكل';
const String _upcomingActivitiesTitle = 'الأنشطة القادمة';
const String _applyButtonLabel = 'تطوع الآن';
const String _searchTooltip = 'البحث عن فرصة';
const String _notificationsTooltip = 'الإشعارات';

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
  int _currentIndex = 0;

  // TODO: Replace with AppProvider opportunities when the backend exposes them.
  static const List<Map<String, String>> _opportunities = [
    {
      'title': 'دعم تعليمي في أساسيات الحاسوب',
      'city': 'غريان',
      'skill': 'تعليم وتقنية',
      'date': 'الإثنين 1 يوليو',
      'seats': '10 متطوعين مطلوبين',
      'status': 'متاحة',
      'location': 'دار الأمان لرعاية الأيتام',
      'summary': 'جلسات قصيرة تساعد الأطفال على فهم الحاسوب بثقة وبأسلوب بسيط.',
    },
    {
      'title': 'تنظيم يوم أنشطة للأطفال',
      'city': 'غريان',
      'skill': 'أنشطة ودعم نفسي',
      'date': 'الجمعة 5 يوليو',
      'seats': '5 متطوعين مطلوبين',
      'status': 'قريبة',
      'location': 'قاعة الأنشطة بدار الرعاية',
      'summary':
          'مساندة الفريق في تنظيم ألعاب هادفة ومساحة ترفيه آمنة للأطفال.',
    },
    {
      'title': 'فرز التبرعات وتجهيز السلال',
      'city': 'طرابلس',
      'skill': 'تنظيم ومتابعة',
      'date': 'الأحد 7 يوليو',
      'seats': '15 متطوع مطلوب',
      'status': 'متاحة',
      'location': 'مركز كنف المجتمعي',
      'summary': 'ترتيب المواد العينية وتجهيزها لتصل إلى دور الرعاية المحتاجة.',
    },
  ];

  // TODO: Replace with AppProvider opportunities when the backend exposes them.
  static const List<Map<String, String>> _displayOpportunities = [
    {
      'title': 'دعم تعليمي في أساسيات الحاسوب',
      'city': 'غريان',
      'skill': 'تعليم وتقنية',
      'date': 'الإثنين 1 يوليو',
      'seats': '10 متطوعين مطلوبين',
      'status': 'متاحة',
      'location': 'دار الأمان لرعاية الأيتام',
      'summary': 'جلسات قصيرة تساعد الأطفال على فهم الحاسوب بثقة وبأسلوب بسيط.',
    },
    {
      'title': 'تنظيم يوم أنشطة للأطفال',
      'city': 'غريان',
      'skill': 'أنشطة ودعم نفسي',
      'date': 'الجمعة 5 يوليو',
      'seats': '5 متطوعين مطلوبين',
      'status': 'قريبة',
      'location': 'قاعة الأنشطة بدار الرعاية',
      'summary':
          'مساندة الفريق في تنظيم ألعاب هادفة ومساحة ترفيه آمنة للأطفال.',
    },
    {
      'title': 'فرز التبرعات وتجهيز السلال',
      'city': 'طرابلس',
      'skill': 'تنظيم ومتابعة',
      'date': 'الأحد 7 يوليو',
      'seats': '15 متطوع مطلوب',
      'status': 'متاحة',
      'location': 'مركز كنف المجتمعي',
      'summary': 'ترتيب المواد العينية وتجهيزها لتصل إلى دور الرعاية المحتاجة.',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: VolunteerMobileFrame(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      _pagePadding,
                      20,
                      _pagePadding,
                      0,
                    ),
                    child: _HomeHeader(
                      onSearch: () =>
                          Navigator.of(context).pushNamed('/volunteer_search'),
                      onNotifications: () => Navigator.of(context).pushNamed(
                        '/volunteer_notifications',
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      _pagePadding,
                      24,
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
                      onAction: () =>
                          Navigator.of(context).pushNamed('/volunteer_search'),
                    ),
                  ),
                ),
                SliverList.separated(
                  itemCount: _opportunities.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: _pagePadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _OpportunityCard(
                            opportunity: _displayOpportunities[index],
                            imagePath: _opportunityImagePaths[index],
                            onTap: () => Navigator.of(context).pushNamed(
                              '/volunteer_opportunity_details',
                              arguments: {
                                'opportunity': _displayOpportunities[index],
                                'imagePath': _opportunityImagePaths[index],
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
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
          bottomNavigationBar: VolunteerBottomNavBar(
            selectedIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() => _currentIndex = index);
              if (index == 1) {
                Navigator.of(context).pushNamed('/volunteer_notifications');
              } else if (index == 2) {
                Navigator.of(context).pushNamed('/my_schedule');
              } else if (index == 3) {
                Navigator.of(context).pushNamed('/volunteer_profile');
              }
            },
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback onNotifications;

  const _HomeHeader({
    required this.onSearch,
    required this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _welcomeTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: _textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _homeSubtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: _textSecondary,
                  fontSize: 13.5,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeaderIconButton(
              icon: Icons.search_rounded,
              tooltip: _searchTooltip,
              onTap: onSearch,
            ),
            const SizedBox(width: 10),
            _HeaderIconButton(
              icon: Icons.notifications_active_outlined,
              tooltip: _notificationsTooltip,
              onTap: onNotifications,
              active: true,
            ),
          ],
        ),
      ],
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
              fontFamily: 'Cairo',
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
              fontFamily: 'Tajawal',
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
        fontFamily: 'Cairo',
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

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool active;

  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: 38,
          height: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: _textPrimary, size: 27),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: active ? 16 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: _primaryOrange,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
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
  final Map<String, String> opportunity;
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
                        fontFamily: 'Cairo',
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
                        fontFamily: 'Tajawal',
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
            fontFamily: 'Tajawal',
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
                  fontFamily: 'Tajawal',
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
