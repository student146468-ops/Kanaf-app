import 'package:flutter/material.dart';

import '../../models/need_model.dart';
import '../../providers/app_provider_scope.dart';
import 'care_home_light_widgets.dart';

class NeedsListScreen extends StatefulWidget {
  const NeedsListScreen({super.key});

  @override
  State<NeedsListScreen> createState() => _NeedsListScreenState();
}

class _NeedsListScreenState extends State<NeedsListScreen>
    with SingleTickerProviderStateMixin {
  static const Color _orange = Color(0xFFFF7A00);
  static const Color _white = Colors.white;
  static const Color _black = Color(0xFF171717);
  static const Color _darkGray = Color(0xFF686868);
  static const Color _lightGray = Color(0xFFF6F6F6);
  static const Color _borderGray = Color(0xFFEDEDED);
  static const double _mobileMaxWidth = 480;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  String _activeFilter = 'الكل';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppProviderScope.of(context).fetchNeeds();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final needs = provider.needs.where(_matchesFilter).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _white,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _mobileMaxWidth),
            child: SafeArea(
              child: Column(
                children: [
                  CareHomeAppBar(
                    title: 'الاحتياجات',
                    onBack: () => Navigator.of(context).pop(),
                    showShadow: false,
                  ),
                  _SegmentedFilter(
                    activeFilter: _activeFilter,
                    onSelected: (value) {
                      setState(() => _activeFilter = value);
                    },
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      color: _orange,
                      onRefresh: provider.fetchNeeds,
                      child: provider.isLoading
                          ? const _LoadingState()
                          : provider.errorMessage != null
                              ? _ErrorState(
                                  message: provider.errorMessage!,
                                  onRetry: provider.fetchNeeds,
                                )
                              : needs.isEmpty
                                  ? _EmptyState(
                                      onAdd: () async {
                                        await Navigator.of(context)
                                            .pushNamed('/care_home_add_need');
                                        if (mounted) provider.fetchNeeds();
                                      },
                                    )
                                  : FadeTransition(
                                      opacity: _fadeAnimation,
                                      child: AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 220),
                                        switchInCurve: Curves.easeOutCubic,
                                        switchOutCurve: Curves.easeInCubic,
                                        child: ListView.separated(
                                          key: ValueKey(
                                            'needs-$_activeFilter-${needs.length}',
                                          ),
                                          physics:
                                              const AlwaysScrollableScrollPhysics(
                                            parent: BouncingScrollPhysics(),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                            18,
                                            14,
                                            18,
                                            106,
                                          ),
                                          itemCount: needs.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 16),
                                          itemBuilder: (context, index) {
                                            final need = needs[index];
                                            return _NeedCard(
                                              need: need,
                                              index: index,
                                              onTap: () => Navigator.of(context)
                                                  .pushNamed(
                                                '/care_home_need_details',
                                                arguments: need.id,
                                              ),
                                            );
                                          },
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
          currentIndex: 1,
          items: const [
            CareHomeBottomNavigationItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
              label: 'الرئيسية',
            ),
            CareHomeBottomNavigationItem(
              icon: Icons.inventory_2_outlined,
              selectedIcon: Icons.inventory_2_rounded,
              label: 'الاحتياجات',
            ),
            CareHomeBottomNavigationItem(
              icon: Icons.volunteer_activism_outlined,
              selectedIcon: Icons.volunteer_activism_rounded,
              label: 'التبرعات',
            ),
            CareHomeBottomNavigationItem(
              icon: Icons.notifications_none_rounded,
              selectedIcon: Icons.notifications_rounded,
              label: 'التنبيهات',
            ),
            CareHomeBottomNavigationItem(
              icon: Icons.groups_2_outlined,
              selectedIcon: Icons.groups_2_rounded,
              label: 'المتطوعون',
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              Navigator.of(context).pushNamed('/care_home_dashboard');
            } else if (index == 2) {
              Navigator.of(context).pushNamed('/care_home_incoming_donations');
            } else if (index == 3) {
              Navigator.of(context).pushNamed('/care_home_notifications');
            } else if (index == 4) {
              Navigator.of(context).pushNamed('/care_home_manage_volunteers');
            }
          },
        ),
      ),
    );
  }

  bool _matchesFilter(NeedModel need) {
    if (_activeFilter == 'قيد التوصيل') return !_isDelivered(need);
    if (_activeFilter == 'التسليم') return _isDelivered(need);
    return true;
  }
}

class NeedsListLegacyAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const NeedsListLegacyAppBar({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 12,
            top: 11,
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onBack,
                customBorder: const CircleBorder(),
                splashColor: _NeedsListScreenState._orange.withAlpha(22),
                child: const SizedBox(
                  width: 42,
                  height: 42,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: _NeedsListScreenState._black,
                    size: 19,
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 72),
            child: Text(
              'الاحتياجات',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _NeedsText.pageTitle,
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedFilter extends StatelessWidget {
  final String activeFilter;
  final ValueChanged<String> onSelected;

  const _SegmentedFilter({
    required this.activeFilter,
    required this.onSelected,
  });

  static const List<String> _tabs = [
    'الكل',
    'قيد التوصيل',
    'التسليم',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 10),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _NeedsListScreenState._lightGray,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: _tabs.map((tab) {
            final selected = activeFilter == tab;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  child: InkWell(
                    onTap: () => onSelected(tab),
                    borderRadius: BorderRadius.circular(999),
                    splashColor: _NeedsListScreenState._orange.withAlpha(20),
                    child: AnimatedContainer(
                      height: 40,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? _NeedsListScreenState._orange
                            : _NeedsListScreenState._lightGray,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        style: _NeedsText.segment.copyWith(
                          color: selected
                              ? _NeedsListScreenState._white
                              : _NeedsListScreenState._darkGray,
                        ),
                        child: Text(
                          tab,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NeedCard extends StatelessWidget {
  final NeedModel need;
  final int index;
  final VoidCallback onTap;

  const _NeedCard({
    required this.need,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _AnimatedCard(
      index: index,
      child: _SoftCard(
        onTap: onTap,
        child: SizedBox(
          height: 112,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                Hero(
                  tag: 'care-home-need-${need.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: _NeedImage(need: need, index: index),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _needTitle(need),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _NeedsText.cardTitle,
                        ),
                        const SizedBox(height: 9),
                        Text(
                          _needQuantity(need),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _NeedsText.quantity,
                        ),
                        const SizedBox(height: 9),
                        Text(
                          _displayStatus(need),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _NeedsText.status,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NeedImage extends StatelessWidget {
  final NeedModel need;
  final int index;

  const _NeedImage({
    required this.need,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (need.imageUrl != null && need.imageUrl!.trim().isNotEmpty) {
      return Image.network(
        need.imageUrl!,
        width: 98,
        height: 98,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _AssetNeedImage(path: _assetPath),
      );
    }
    return _AssetNeedImage(path: _assetPath);
  }

  String get _assetPath {
    final text =
        '${need.title} ${need.category} ${need.needType}'.toLowerCase();
    if (text.contains('حليب') ||
        text.contains('milk') ||
        text.contains('baby')) {
      return 'assets/images/d.png';
    }
    if (text.contains('ملابس') ||
        text.contains('شتو') ||
        text.contains('clothes')) {
      return 'assets/images/c.png';
    }
    if (text.contains('حقيبة') ||
        text.contains('مدرس') ||
        text.contains('school') ||
        text.contains('education')) {
      return 'assets/images/b.png';
    }
    if (text.contains('غذ') || text.contains('سلة') || text.contains('food')) {
      return 'assets/images/a.png';
    }

    const fallbackAssets = [
      'assets/images/a.png',
      'assets/images/d.png',
      'assets/images/c.png',
      'assets/images/b.png',
    ];
    return fallbackAssets[index % fallbackAssets.length];
  }
}

class _AssetNeedImage extends StatelessWidget {
  final String path;

  const _AssetNeedImage({required this.path});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: 98,
      height: 98,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          width: 98,
          height: 98,
          color: _NeedsListScreenState._lightGray,
          child: const Icon(
            Icons.inventory_2_outlined,
            color: _NeedsListScreenState._darkGray,
            size: 28,
          ),
        );
      },
    );
  }
}

class _AnimatedCard extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedCard({
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 240 + (index.clamp(0, 6) * 45)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(18, 84, 18, 106),
      children: [
        _SoftCard(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
          child: Column(
            children: [
              const _EmptyIllustration(),
              const SizedBox(height: 16),
              const Text(
                'لا توجد احتياجات حالياً',
                textAlign: TextAlign.center,
                style: _NeedsText.emptyTitle,
              ),
              const SizedBox(height: 8),
              const Text(
                'ستظهر الاحتياجات الجديدة هنا عند إضافتها.',
                textAlign: TextAlign.center,
                style: _NeedsText.body,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('إضافة احتياج'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _NeedsListScreenState._orange,
                    foregroundColor: _NeedsListScreenState._white,
                    textStyle: _NeedsText.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyIllustration extends StatelessWidget {
  const _EmptyIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 8,
            child: Container(
              width: 84,
              height: 52,
              decoration: BoxDecoration(
                color: _NeedsListScreenState._orange.withAlpha(18),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: _NeedsListScreenState._orange.withAlpha(34),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _NeedsListScreenState._white,
                shape: BoxShape.circle,
                border: Border.all(color: _NeedsListScreenState._borderGray),
                boxShadow: _softShadow,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: _NeedsListScreenState._orange,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(18, 80, 18, 106),
      children: [
        _SoftCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: _NeedsListScreenState._orange,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: _NeedsText.body,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: onRetry,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _NeedsListScreenState._orange,
                    side: const BorderSide(
                      color: _NeedsListScreenState._orange,
                    ),
                    textStyle: _NeedsText.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text('إعادة المحاولة'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: _NeedsListScreenState._orange,
        strokeWidth: 2.6,
      ),
    );
  }
}

class NeedsListLegacyBottomNavigation extends StatelessWidget {
  const NeedsListLegacyBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _BottomNavItemData(
        icon: Icons.home_rounded,
        label: 'الرئيسية',
        onTap: () => Navigator.of(context).pushNamed('/care_home_dashboard'),
      ),
      _BottomNavItemData(
        icon: Icons.notifications_none_rounded,
        label: 'التنبيهات',
        onTap: () =>
            Navigator.of(context).pushNamed('/care_home_notifications'),
      ),
      _BottomNavItemData(
        icon: Icons.volunteer_activism_rounded,
        label: 'التبرعات',
        selected: true,
        onTap: () =>
            Navigator.of(context).pushNamed('/care_home_incoming_donations'),
      ),
      _BottomNavItemData(
        icon: Icons.people_alt_rounded,
        label: 'المتبرعون',
        onTap: () =>
            Navigator.of(context).pushNamed('/care_home_incoming_donations'),
      ),
      _BottomNavItemData(
        icon: Icons.groups_2_rounded,
        label: 'المتطوعون',
        onTap: () =>
            Navigator.of(context).pushNamed('/care_home_manage_volunteers'),
      ),
    ];

    return SafeArea(
      top: false,
      child: Container(
        height: 82,
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        decoration: const BoxDecoration(
          color: _NeedsListScreenState._white,
          boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 18,
              offset: Offset(0, -7),
            ),
          ],
        ),
        child: Row(
          children: items
              .map(
                (item) => Expanded(
                  child: _BottomNavItem(item: item),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final _BottomNavItemData item;

  const _BottomNavItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.selected
        ? _NeedsListScreenState._orange
        : _NeedsListScreenState._darkGray;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: _NeedsListScreenState._orange.withAlpha(18),
        child: SizedBox(
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: color, size: 22),
              const SizedBox(height: 5),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _NeedsText.nav.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItemData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  const _BottomNavItemData({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });
}

class _SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const _SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    final card = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: _NeedsListScreenState._white,
        borderRadius: radius,
        border: Border.all(color: _NeedsListScreenState._borderGray),
        boxShadow: _softShadow,
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        splashColor: _NeedsListScreenState._orange.withAlpha(22),
        child: card,
      ),
    );
  }
}

const List<BoxShadow> _softShadow = [
  BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 20,
    offset: Offset(0, 9),
  ),
];

bool _isDelivered(NeedModel need) {
  final status = need.status.trim().toLowerCase();
  return status == 'completed' ||
      status == 'delivered' ||
      status == 'تم التسليم' ||
      status == 'مكتملة';
}

String _displayStatus(NeedModel need) {
  return _isDelivered(need) ? 'تم التسليم' : 'قيد التوصيل';
}

String _needTitle(NeedModel need) {
  return need.title.trim().isEmpty ? 'احتياج جديد' : need.title.trim();
}

String _needQuantity(NeedModel need) {
  final quantity = need.requiredQuantity.trim();
  return quantity.isEmpty ? 'الكمية غير محددة' : quantity;
}

class _NeedsText {
  static const TextStyle pageTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _NeedsListScreenState._black,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle segment = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _NeedsListScreenState._black,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle quantity = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _NeedsListScreenState._black,
    fontSize: 14,
    height: 1.35,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle status = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _NeedsListScreenState._darkGray,
    fontSize: 13,
    height: 1.35,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _NeedsListScreenState._darkGray,
    fontSize: 13.5,
    height: 1.45,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle emptyTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _NeedsListScreenState._black,
    fontSize: 17,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle button = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle nav = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w700,
  );

  const _NeedsText._();
}
