import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'volunteer_ui.dart';

const String _fallbackVolunteerName = 'ياسمين عادل';
const String _homeSubtitle = 'ساهم بوقتك ومهاراتك لصنع أثر حقيقي';
const String _opportunitiesTitle = 'فرص مناسبة لك';
const String _filterActionLabel = 'تصفية';
const String _homeTabLabel = 'الرئيسية';
const String _scheduleTabLabel = 'مواعيدي';
const String _profileTabLabel = 'حسابي';
const String _searchTooltip = 'البحث عن فرصة';
const String _notificationsTooltip = 'الإشعارات';
const String _chooseOpportunityText = 'اختر فرصة تطوع تناسب وقتك ومهاراتك';
const String _impactDescription =
    'تابع احتياجات دور الرعاية وابدأ مساهمة منظمة تصل لمن يحتاجها.';
const String _nearStatus = 'قريبة';

String _volunteerHoursLabel(int hours) => 'لديك $hours ساعة تطوعية موثقة';

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
      'seats': 'مقعدان',
      'status': 'متاحة',
      'location': 'دار الأمان لرعاية الأيتام',
      'summary': 'جلسات قصيرة تساعد الأطفال على فهم الحاسوب بثقة وبأسلوب بسيط.',
    },
    {
      'title': 'تنظيم يوم أنشطة للأطفال',
      'city': 'غريان',
      'skill': 'أنشطة ودعم نفسي',
      'date': 'الجمعة 5 يوليو',
      'seats': '5 مقاعد',
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
      'seats': '8 مقاعد',
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
      'seats': 'مقعدان',
      'status': 'متاحة',
      'location': 'دار الأمان لرعاية الأيتام',
      'summary': 'جلسات قصيرة تساعد الأطفال على فهم الحاسوب بثقة وبأسلوب بسيط.',
    },
    {
      'title': 'تنظيم يوم أنشطة للأطفال',
      'city': 'غريان',
      'skill': 'أنشطة ودعم نفسي',
      'date': 'الجمعة 5 يوليو',
      'seats': '5 مقاعد',
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
      'seats': '8 مقاعد',
      'status': 'متاحة',
      'location': 'مركز كنف المجتمعي',
      'summary': 'ترتيب المواد العينية وتجهيزها لتصل إلى دور الرعاية المحتاجة.',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final volunteer =
        provider.volunteers.isNotEmpty ? provider.volunteers.first : null;
    final displayName = volunteer?.name.isNotEmpty == true
        ? volunteer!.name
        : _fallbackVolunteerName;
    final hours = volunteer?.hoursWorked ?? 0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: VolunteerMobileFrame(
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      volunteerHorizontalPadding,
                      16,
                      volunteerHorizontalPadding,
                      10,
                    ),
                    child: _HomeHeader(
                      name: displayName,
                      onSearch: () =>
                          Navigator.of(context).pushNamed('/volunteer_search'),
                      onNotifications: () => Navigator.of(context).pushNamed(
                        '/volunteer_notifications',
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      volunteerHorizontalPadding,
                      0,
                      volunteerHorizontalPadding,
                      14,
                    ),
                    child: _ImpactCard(hours: hours),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      volunteerHorizontalPadding,
                      14,
                      volunteerHorizontalPadding,
                      10,
                    ),
                    child: VolunteerSectionTitle(
                      title: _opportunitiesTitle,
                      actionLabel: _filterActionLabel,
                      onAction: () =>
                          Navigator.of(context).pushNamed('/volunteer_search'),
                    ),
                  ),
                ),
                SliverList.separated(
                  itemCount: _opportunities.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: volunteerHorizontalPadding,
                      ),
                      child: _OpportunityCard(
                        opportunity: _displayOpportunities[index],
                        onTap: () => Navigator.of(context).pushNamed(
                          '/volunteer_opportunity_details',
                        ),
                      ),
                    );
                  },
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            height: 72,
            backgroundColor: Colors.white,
            indicatorColor: AppColors.brandOrangeLight,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
              if (index == 1) {
                Navigator.of(context).pushNamed('/my_schedule');
              } else if (index == 2) {
                Navigator.of(context).pushNamed('/volunteer_profile');
              }
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: _homeTabLabel,
              ),
              NavigationDestination(
                icon: Icon(Icons.event_note_outlined),
                selectedIcon: Icon(Icons.event_note_rounded),
                label: _scheduleTabLabel,
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: _profileTabLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final String name;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;

  const _HomeHeader({
    required this.name,
    required this.onSearch,
    required this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                _homeSubtitle,
                style: volunteerMutedStyle,
              ),
              const SizedBox(height: 4),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textDarkPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        VolunteerIconButton(
          icon: Icons.manage_search_rounded,
          tooltip: _searchTooltip,
          onTap: onSearch,
        ),
        const SizedBox(width: 8),
        VolunteerIconButton(
          icon: Icons.notifications_active_outlined,
          tooltip: _notificationsTooltip,
          onTap: onNotifications,
        ),
      ],
    );
  }
}

class _ImpactCard extends StatelessWidget {
  final int hours;

  const _ImpactCard({required this.hours});

  @override
  Widget build(BuildContext context) {
    final hasHours = hours > 0;
    return VolunteerCard(
      padding: const EdgeInsets.all(18),
      color: AppColors.brandOrangeLight,
      borderColor: Colors.white,
      child: Row(
        children: [
          const VolunteerIconBox(
            icon: Icons.volunteer_activism_rounded,
            color: AppColors.brandOrange,
            backgroundColor: Colors.white,
            size: 50,
            iconSize: 26,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasHours
                      ? _volunteerHoursLabel(hours)
                      : _chooseOpportunityText,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textDarkPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  _impactDescription,
                  style: volunteerBodyStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final Map<String, String> opportunity;
  final VoidCallback onTap;

  const _OpportunityCard({required this.opportunity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = opportunity['status']!;
    final statusColor = status == _nearStatus
        ? const Color(0xFF4A90E2)
        : AppColors.successGreen;

    return VolunteerCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VolunteerIconBox(
                icon: Icons.volunteer_activism_outlined,
                size: 42,
                iconSize: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  opportunity['title']!,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15.5,
                    height: 1.35,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
              ),
              VolunteerStatusBadge(
                label: status,
                color: statusColor,
                icon: status == _nearStatus
                    ? Icons.timer_outlined
                    : Icons.check_circle_outline_rounded,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(opportunity['summary']!, style: volunteerBodyStyle),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              VolunteerMetaChip(
                icon: Icons.location_on_outlined,
                label: opportunity['city']!,
                color: AppColors.brandOrange,
                prominent: true,
              ),
              VolunteerMetaChip(
                icon: Icons.calendar_month_outlined,
                label: opportunity['date']!,
                color: const Color(0xFF4A90E2),
                prominent: true,
              ),
              VolunteerMetaChip(
                icon: Icons.psychology_alt_outlined,
                label: opportunity['skill']!,
              ),
              VolunteerMetaChip(
                icon: Icons.event_seat_outlined,
                label: opportunity['seats']!,
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
