import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class CareHomeDashboardScreen extends StatefulWidget {
  const CareHomeDashboardScreen({super.key});

  @override
  State<CareHomeDashboardScreen> createState() =>
      _CareHomeDashboardScreenState();
}

enum _DashboardMenuAction { volunteers, visitHours, reports, rating, profile }

class _CareHomeDashboardScreenState extends State<CareHomeDashboardScreen> {
  static const Color _primaryOrange = Color(0xFFFF8C42);
  static const Color _background = Colors.white;
  static const double _radius = 22;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppProviderScope.of(context).fetchDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final provider = AppProviderScope.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        body: Center(
          child: SizedBox(
            width: isWebOrDesktop ? 430 : double.infinity,
            height: double.infinity,
            child: SafeArea(
              child: Column(
                children: [
                  CareHomeAppBar(
                    title: 'دار الرعاية',
                    showBackButton: false,
                    leading: _CareHomeLogoButton(
                      onTap: () =>
                          Navigator.of(context).pushNamed('/care_home_profile'),
                    ),
                    actions: [
                      _menu(),
                      const SizedBox(width: 10),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CareHomeTopBarActionButton(
                            icon: Icons.notifications_none_rounded,
                            tooltip: 'الإشعارات',
                            onTap: () => Navigator.of(context)
                                .pushNamed('/care_home_notifications'),
                          ),
                          if (_hasNewNotifications(provider.dashboardStats))
                            PositionedDirectional(
                              top: 5,
                              end: 6,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: _CareHomeDashboardScreenState
                                      ._primaryOrange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      color: _primaryOrange,
                      onRefresh: provider.fetchDashboardStats,
                      child: provider.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: _primaryOrange,
                                strokeWidth: 2.6,
                              ),
                            )
                          : TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 360),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 12 * (1 - value)),
                                    child: child,
                                  ),
                                );
                              },
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics(),
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  10,
                                  20,
                                  22,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Hero(
                                      tag: 'care-home-dashboard-banner',
                                      child: _WelcomeBanner(),
                                    ),
                                    const SizedBox(height: 18),
                                    _ImportantInfoCard(
                                      stats: provider.dashboardStats,
                                      onNeeds: () => Navigator.of(context)
                                          .pushNamed('/care_home_needs_list'),
                                      onDonations: () =>
                                          Navigator.of(context).pushNamed(
                                        '/care_home_incoming_donations',
                                      ),
                                      onVolunteers: () =>
                                          Navigator.of(context).pushNamed(
                                        '/care_home_manage_volunteers',
                                      ),
                                    ),
                                    const SizedBox(height: 22),
                                    const _SectionTitle('إجراءات سريعة'),
                                    const SizedBox(height: 12),
                                    _QuickActionsGrid(
                                      actions: [
                                        _QuickActionData(
                                          label: 'إضافة احتياج',
                                          icon:
                                              Icons.add_circle_outline_rounded,
                                          onTap: () =>
                                              Navigator.of(context).pushNamed(
                                            '/care_home_add_need',
                                          ),
                                        ),
                                        _QuickActionData(
                                          label: 'الاحتياجات',
                                          icon: Icons.inventory_2_outlined,
                                          onTap: () =>
                                              Navigator.of(context).pushNamed(
                                            '/care_home_needs_list',
                                          ),
                                        ),
                                        _QuickActionData(
                                          label: 'الطلبات',
                                          icon: Icons.assignment_outlined,
                                          onTap: () =>
                                              Navigator.of(context).pushNamed(
                                            '/care_home_incoming_donations',
                                          ),
                                        ),
                                        _QuickActionData(
                                          label: 'المتطوعون',
                                          icon: Icons.groups_2_outlined,
                                          onTap: () =>
                                              Navigator.of(context).pushNamed(
                                            '/care_home_manage_volunteers',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 22),
                                    const _SectionTitle('آخر التحديثات'),
                                    const SizedBox(height: 12),
                                    _UpdatesSection(
                                      stats: provider.dashboardStats,
                                      onViewAll: () =>
                                          Navigator.of(context).pushNamed(
                                        '/care_home_notifications',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CareHomeBottomNavigation(
          currentIndex: 0,
          items: const [
            CareHomeBottomNavigationItem(
              icon: Icons.dashboard_outlined,
              selectedIcon: Icons.dashboard_rounded,
              label: 'الرئيسية',
            ),
            CareHomeBottomNavigationItem(
              icon: Icons.inventory_2_outlined,
              selectedIcon: Icons.inventory_2_rounded,
              label: 'الاحتياجات',
            ),
            CareHomeBottomNavigationItem(
              icon: Icons.assignment_outlined,
              selectedIcon: Icons.assignment_rounded,
              label: 'التبرعات',
            ),
            CareHomeBottomNavigationItem(
              icon: Icons.groups_2_outlined,
              selectedIcon: Icons.groups_2_rounded,
              label: 'المتطوعون',
            ),
            CareHomeBottomNavigationItem(
              icon: Icons.person_outline_rounded,
              selectedIcon: Icons.person_rounded,
              label: 'الملف',
            ),
          ],
          onTap: (index) {
            if (index == 1) {
              Navigator.of(context).pushNamed('/care_home_needs_list');
            } else if (index == 2) {
              Navigator.of(context).pushNamed('/care_home_incoming_donations');
            } else if (index == 3) {
              Navigator.of(context).pushNamed('/care_home_manage_volunteers');
            } else if (index == 4) {
              Navigator.of(context).pushNamed('/care_home_profile');
            }
          },
        ),
      ),
    );
  }

  bool _hasNewNotifications(Map<String, dynamic> stats) {
    final notifications = (stats['latest_notifications'] as List?) ?? const [];
    return notifications.isNotEmpty;
  }

  Widget _menu() {
    return PopupMenuButton<_DashboardMenuAction>(
      tooltip: 'القائمة',
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      position: PopupMenuPosition.under,
      onSelected: (action) {
        switch (action) {
          case _DashboardMenuAction.volunteers:
            Navigator.of(context).pushNamed('/care_home_manage_volunteers');
            break;
          case _DashboardMenuAction.visitHours:
            Navigator.of(context).pushNamed('/care_home_visit_hours');
            break;
          case _DashboardMenuAction.reports:
            Navigator.of(context).pushNamed('/care_home_reports');
            break;
          case _DashboardMenuAction.rating:
            Navigator.of(context).pushNamed('/care_home_rate_volunteers');
            break;
          case _DashboardMenuAction.profile:
            Navigator.of(context).pushNamed('/care_home_profile');
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _DashboardMenuAction.volunteers,
          child: Text('المتطوعون'),
        ),
        PopupMenuItem(
          value: _DashboardMenuAction.visitHours,
          child: Text('مواعيد الزيارة'),
        ),
        PopupMenuItem(
          value: _DashboardMenuAction.reports,
          child: Text('التقارير'),
        ),
        PopupMenuItem(
          value: _DashboardMenuAction.rating,
          child: Text('تقييم الأداء'),
        ),
        PopupMenuItem(
          value: _DashboardMenuAction.profile,
          child: Text('ملف الدار'),
        ),
      ],
      child: const _CircleIconButton(
        icon: Icons.more_horiz_rounded,
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.innerBorder.withOpacity(0.8)),
          ),
          child: Icon(
            icon,
            color: AppColors.textDarkPrimary,
            size: 21,
          ),
        ),
      ),
    );
  }
}

class _CareHomeLogoButton extends StatelessWidget {
  const _CareHomeLogoButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                _CareHomeDashboardScreenState._primaryOrange.withOpacity(0.11),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.home_work_rounded,
            color: _CareHomeDashboardScreenState._primaryOrange,
            size: 23,
          ),
        ),
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner();

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 170,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 10, 12, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً بك',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _DashboardText.title.copyWith(fontSize: 21),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'إدارة احتياجات الدار ومتابعة التبرعات والمتطوعين بسهولة.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _DashboardText.body.copyWith(height: 1.55),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'اطلع على آخر الأنشطة والإحصائيات في مكان واحد.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _DashboardText.muted.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/d.png',
                    width: 148,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.white.withOpacity(0.16),
                            Colors.white.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImportantInfoCard extends StatelessWidget {
  const _ImportantInfoCard({
    required this.stats,
    required this.onNeeds,
    required this.onDonations,
    required this.onVolunteers,
  });

  final Map<String, dynamic> stats;
  final VoidCallback onNeeds;
  final VoidCallback onDonations;
  final VoidCallback onVolunteers;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('أهم المعلومات'),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                  label: 'الاحتياجات النشطة',
                  value: '${stats['active_needs'] ?? 0}',
                  icon: Icons.inventory_2_outlined,
                  onTap: onNeeds,
                ),
              ),
              const _VerticalDivider(),
              Expanded(
                child: _MetricItem(
                  label: 'التبرعات الواردة',
                  value: '${stats['incoming_donations'] ?? 0}',
                  icon: Icons.assignment_outlined,
                  onTap: onDonations,
                ),
              ),
              const _VerticalDivider(),
              Expanded(
                child: _MetricItem(
                  label: 'طلبات التطوع',
                  value: '${stats['pending_volunteer_requests'] ?? 0}',
                  icon: Icons.groups_2_outlined,
                  onTap: onVolunteers,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _CareHomeDashboardScreenState._primaryOrange
                    .withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: _CareHomeDashboardScreenState._primaryOrange,
                size: 21,
              ),
            ),
            const SizedBox(height: 8),
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: double.tryParse(value) ?? 0,
              ),
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutCubic,
              builder: (context, animatedValue, _) {
                return Text(
                  animatedValue.round().toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _DashboardText.number,
                );
              },
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: _DashboardText.muted.copyWith(fontSize: 11.3),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 72,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: AppColors.innerBorder.withOpacity(0.72),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({required this.actions});

  final List<_QuickActionData> actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final itemWidth = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: actions.map((action) {
            return SizedBox(
              width: itemWidth,
              child: _QuickActionCard(action: action),
            );
          }).toList(),
        );
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.action});

  final _QuickActionData action;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      onTap: action.onTap,
      borderRadius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: AspectRatio(
        aspectRatio: 1.28,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              action.icon,
              color: _CareHomeDashboardScreenState._primaryOrange,
              size: 34,
            ),
            const SizedBox(height: 10),
            Text(
              action.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: _DashboardText.title.copyWith(fontSize: 13.8),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpdatesSection extends StatelessWidget {
  const _UpdatesSection({
    required this.stats,
    required this.onViewAll,
  });

  final Map<String, dynamic> stats;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final hasDonation =
        ((stats['latest_donations'] as List?) ?? const []).isNotEmpty;
    final hasNeed = ((stats['latest_needs'] as List?) ?? const []).isNotEmpty;

    if (!hasDonation && !hasNeed) {
      return _SoftCard(
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _CareHomeDashboardScreenState._primaryOrange
                    .withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.update_rounded,
                color: _CareHomeDashboardScreenState._primaryOrange,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'لا توجد تحديثات بعد',
              style: _DashboardText.title.copyWith(fontSize: 15),
            ),
            const SizedBox(height: 6),
            const Text(
              'ستظهر هنا أحدث التبرعات والاحتياجات عند توفرها.',
              textAlign: TextAlign.center,
              style: _DashboardText.body,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (hasDonation)
          const _UpdateCard(
            imagePath: 'assets/images/e.png',
            fallbackIcon: Icons.volunteer_activism_outlined,
            title: 'تبرع جديد',
            description: 'وصل تبرع جديد عبارة عن مياه النبع.',
            time: 'منذ 15 دقيقة',
          ),
        if (hasDonation && hasNeed) const SizedBox(height: 12),
        if (hasNeed)
          const _UpdateCard(
            imagePath: 'assets/images/f.png',
            fallbackIcon: Icons.medical_services_outlined,
            title: 'احتياج جديد',
            description: 'تمت إضافة احتياج جديد لأجهزة طبية.',
            time: 'منذ 3 ساعات',
          ),
        const SizedBox(height: 12),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: onViewAll,
            icon: const Icon(Icons.arrow_back_rounded, size: 17),
            label: const Text('عرض جميع التحديثات'),
            style: TextButton.styleFrom(
              foregroundColor: _CareHomeDashboardScreenState._primaryOrange,
              textStyle: _DashboardText.button.copyWith(fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}

class _UpdateCard extends StatelessWidget {
  const _UpdateCard({
    required this.imagePath,
    required this.fallbackIcon,
    required this.title,
    required this.description,
    required this.time,
  });

  final String imagePath;
  final IconData fallbackIcon;
  final String title;
  final String description;
  final String time;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 92,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  imagePath,
                  width: 92,
                  height: 92,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 92,
                      height: 92,
                      alignment: Alignment.center,
                      color: _CareHomeDashboardScreenState._primaryOrange
                          .withOpacity(0.10),
                      child: Icon(
                        fallbackIcon,
                        color: _CareHomeDashboardScreenState._primaryOrange,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _CareHomeDashboardScreenState._primaryOrange
                              .withOpacity(0.10),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          fallbackIcon,
                          color: _CareHomeDashboardScreenState._primaryOrange,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  _DashboardText.title.copyWith(fontSize: 15),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  _DashboardText.body.copyWith(fontSize: 12.8),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              time,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  _DashboardText.muted.copyWith(fontSize: 11.8),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CareHomeDashboardLegacyBottomNavigation extends StatelessWidget {
  const CareHomeDashboardLegacyBottomNavigation({
    super.key,
    required this.onSelected,
  });

  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: NavigationBar(
        selectedIndex: 0,
        height: 72,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        indicatorColor:
            _CareHomeDashboardScreenState._primaryOrange.withOpacity(0.10),
        onDestinationSelected: onSelected,
        destinations: const [
          NavigationDestination(
            icon:
                Icon(Icons.dashboard_outlined, color: AppColors.textDarkMuted),
            selectedIcon: Icon(
              Icons.dashboard_rounded,
              color: _CareHomeDashboardScreenState._primaryOrange,
            ),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined,
                color: AppColors.textDarkMuted),
            selectedIcon: Icon(
              Icons.inventory_2_rounded,
              color: _CareHomeDashboardScreenState._primaryOrange,
            ),
            label: 'الاحتياجات',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.assignment_outlined,
              color: AppColors.textDarkMuted,
            ),
            selectedIcon: Icon(
              Icons.assignment_rounded,
              color: _CareHomeDashboardScreenState._primaryOrange,
            ),
            label: 'التبرعات',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_2_outlined, color: AppColors.textDarkMuted),
            selectedIcon: Icon(
              Icons.groups_2_rounded,
              color: _CareHomeDashboardScreenState._primaryOrange,
            ),
            label: 'المتطوعون',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded,
                color: AppColors.textDarkMuted),
            selectedIcon: Icon(
              Icons.person_rounded,
              color: _CareHomeDashboardScreenState._primaryOrange,
            ),
            label: 'الملف الشخصي',
          ),
        ],
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.borderRadius = _CareHomeDashboardScreenState._radius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final card = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        border: Border.all(color: AppColors.innerBorder.withOpacity(0.55)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        hoverColor:
            _CareHomeDashboardScreenState._primaryOrange.withOpacity(0.05),
        splashColor:
            _CareHomeDashboardScreenState._primaryOrange.withOpacity(0.10),
        borderRadius: radius,
        child: card,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: _DashboardText.title.copyWith(fontSize: 17),
    );
  }
}

class _QuickActionData {
  const _QuickActionData({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class _DashboardText {
  static const TextStyle title = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle body = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkSecondary,
    fontSize: 13.5,
    height: 1.5,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle muted = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkMuted,
    fontSize: 12.3,
    height: 1.4,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle number = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkPrimary,
    fontSize: 19,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle button = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w900,
  );

  const _DashboardText._();
}
