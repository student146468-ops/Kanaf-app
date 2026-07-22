import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class ManageVolunteersScreen extends StatefulWidget {
  const ManageVolunteersScreen({super.key});

  @override
  State<ManageVolunteersScreen> createState() => _ManageVolunteersScreenState();
}

class _ManageVolunteersScreenState extends State<ManageVolunteersScreen>
    with SingleTickerProviderStateMixin {
  static const Color _primaryOrange = AppColors.brandOrange;
  static const Color _background = Colors.white;
  static const Color _softGray = Color(0xFFF7F7F7);
  static const Color _borderGray = Color(0xFFEDEDED);
  static const Color _textBlack = Color(0xFF171717);
  static const Color _textGray = Color(0xFF686868);
  static const Color _statusBlue = Color(0xFF2F80ED);
  static const Color _statusGreen = Color(0xFF27AE60);
  static const Color _statusRed = Color(0xFFE5484D);
  static const double _mobileMaxWidth = 480;

  final _searchController = TextEditingController();
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  String _selectedFilter = 'الكل';
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    _searchController.addListener(() {
      setState(() => _searchText = _searchController.text.trim());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppProviderScope.of(context).fetchVolunteerRequests();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final requests = provider.volunteerRequests;
    final filteredRequests = requests.where(_matchesFilters).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _mobileMaxWidth),
            child: SafeArea(
              child: Column(
                children: [
                  CareHomeAppBar(
                    title: 'إدارة المتطوعين',
                    actions: [
                      _menu(),
                      const SizedBox(width: 10),
                      CareHomeTopBarActionButton(
                        icon: Icons.notifications_none_rounded,
                        tooltip: 'الإشعارات',
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/care_home_notifications',
                          );
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      color: _primaryOrange,
                      onRefresh: provider.fetchVolunteerRequests,
                      child: provider.isLoading
                          ? const _LoadingState()
                          : FadeTransition(
                              opacity: _fadeAnimation,
                              child: ListView(
                                physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics(),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(18, 12, 18, 26),
                                children: [
                                  _SummaryCard(requests: requests),
                                  const SizedBox(height: 16),
                                  _SearchField(controller: _searchController),
                                  const SizedBox(height: 14),
                                  _FilterChips(
                                    selectedFilter: _selectedFilter,
                                    onChanged: (filter) {
                                      setState(() => _selectedFilter = filter);
                                    },
                                  ),
                                  const SizedBox(height: 18),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 240),
                                    switchInCurve: Curves.easeOutCubic,
                                    switchOutCurve: Curves.easeInCubic,
                                    child: filteredRequests.isEmpty
                                        ? const _EmptyState(
                                            key: ValueKey('empty-volunteers'),
                                          )
                                        : Column(
                                            key: ValueKey(
                                              'volunteers-$_selectedFilter-${filteredRequests.length}-$_searchText',
                                            ),
                                            children: List.generate(
                                              filteredRequests.length,
                                              (index) {
                                                final request =
                                                    filteredRequests[index];
                                                return _AnimatedVolunteerCard(
                                                  index: index,
                                                  child: _VolunteerCard(
                                                    request: request,
                                                    index: index,
                                                    provider: provider,
                                                    onTap: () {
                                                      _showVolunteerDetails(
                                                        request,
                                                        index,
                                                        provider,
                                                      );
                                                    },
                                                    onAccept: () {
                                                      _acceptVolunteer(
                                                        request,
                                                        provider,
                                                      );
                                                    },
                                                    onReject: () {
                                                      _rejectVolunteer(
                                                        request,
                                                        provider,
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _matchesFilters(Map<String, dynamic> request) {
    final status = _statusLabel(request);
    final matchesFilter = _selectedFilter == 'الكل' ||
        (_selectedFilter == 'بانتظار المراجعة' &&
            status == 'بانتظار المراجعة') ||
        (_selectedFilter == 'مقبول' && status == 'مقبول') ||
        (_selectedFilter == 'مرفوض' && status == 'مرفوض') ||
        (_selectedFilter == 'نشط' && status == 'نشط');
    if (!matchesFilter) return false;

    if (_searchText.isEmpty) return true;
    final haystack = [
      _volunteerName(request),
      _volunteerSkill(request),
      _value(request, const ['skills', 'title', 'specialty']),
    ].join(' ');
    return haystack.contains(_searchText);
  }

  Widget _menu() {
    return PopupMenuButton<_VolunteerMenuAction>(
      tooltip: 'القائمة',
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      position: PopupMenuPosition.under,
      onSelected: (action) {
        switch (action) {
          case _VolunteerMenuAction.needs:
            Navigator.of(context).pushNamed('/care_home_needs_list');
            break;
          case _VolunteerMenuAction.donations:
            Navigator.of(context).pushNamed('/care_home_incoming_donations');
            break;
          case _VolunteerMenuAction.reports:
            Navigator.of(context).pushNamed('/care_home_reports');
            break;
          case _VolunteerMenuAction.profile:
            Navigator.of(context).pushNamed('/care_home_profile');
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _VolunteerMenuAction.needs,
          child: Text('الاحتياجات'),
        ),
        PopupMenuItem(
          value: _VolunteerMenuAction.donations,
          child: Text('التبرعات'),
        ),
        PopupMenuItem(
          value: _VolunteerMenuAction.reports,
          child: Text('التقارير'),
        ),
        PopupMenuItem(
          value: _VolunteerMenuAction.profile,
          child: Text('ملف الدار'),
        ),
      ],
      child: const _CircleIconButton(icon: Icons.more_horiz_rounded),
    );
  }

  Future<void> _acceptVolunteer(
    Map<String, dynamic> request,
    dynamic provider,
  ) async {
    final id = int.tryParse(request['id']?.toString() ?? '');
    if (id == null) return;
    await provider.acceptVolunteerRequest(id);
  }

  Future<void> _rejectVolunteer(
    Map<String, dynamic> request,
    dynamic provider,
  ) async {
    final id = int.tryParse(request['id']?.toString() ?? '');
    if (id == null) return;
    await provider.rejectVolunteerRequest(id);
  }

  void _showVolunteerDetails(
    Map<String, dynamic> request,
    int index,
    dynamic provider,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: _VolunteerDetailsSheet(
            request: request,
            index: index,
            provider: provider,
          ),
        );
      },
    );
  }
}

class ManageVolunteersLegacyTopBar extends StatelessWidget {
  final Widget menu;
  final VoidCallback onNotifications;

  const ManageVolunteersLegacyTopBar({
    super.key,
    required this.menu,
    required this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: 0,
            child: _CircleIconButton(
              icon: Icons.chevron_right_rounded,
              iconSize: 30,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 112),
            child: Text(
              'إدارة المتطوعين',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _VolunteersText.title,
            ),
          ),
          PositionedDirectional(
            end: 0,
            top: 0,
            bottom: 0,
            child: Row(
              children: [
                menu,
                const SizedBox(width: 8),
                _CircleIconButton(
                  icon: Icons.notifications_none_rounded,
                  onTap: onNotifications,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final List<Map<String, dynamic>> requests;

  const _SummaryCard({required this.requests});

  @override
  Widget build(BuildContext context) {
    final pending = requests
        .where((item) => _statusLabel(item) == 'بانتظار المراجعة')
        .length;
    final active = requests.where((item) => _statusLabel(item) == 'نشط').length;

    return _SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              icon: Icons.groups_2_rounded,
              value: '${requests.length}',
              label: 'إجمالي المتطوعين',
            ),
          ),
          const _VerticalDivider(),
          Expanded(
            child: _SummaryItem(
              icon: Icons.pending_actions_rounded,
              value: '$pending',
              label: 'الطلبات الجديدة',
            ),
          ),
          const _VerticalDivider(),
          Expanded(
            child: _SummaryItem(
              icon: Icons.verified_user_rounded,
              value: '$active',
              label: 'المتطوعون النشطون',
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _ManageVolunteersScreenState._primaryOrange.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: _ManageVolunteersScreenState._primaryOrange,
            size: 19,
          ),
        ),
        const SizedBox(height: 8),
        Text(value, style: _VolunteersText.number),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: _VolunteersText.caption,
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;

  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _ManageVolunteersScreenState._borderGray),
        boxShadow: _softShadow,
      ),
      child: TextField(
        controller: controller,
        cursorColor: _ManageVolunteersScreenState._primaryOrange,
        textInputAction: TextInputAction.search,
        style: _VolunteersText.body.copyWith(color: AppColors.textDarkPrimary),
        decoration: const InputDecoration(
          hintText: 'ابحث باسم المتطوع أو المهارة',
          hintStyle: _VolunteersText.hint,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: _ManageVolunteersScreenState._primaryOrange,
            size: 21,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onChanged;

  const _FilterChips({
    required this.selectedFilter,
    required this.onChanged,
  });

  static const filters = [
    'الكل',
    'بانتظار المراجعة',
    'مقبول',
    'مرفوض',
    'نشط',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((filter) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: _FilterChipButton(
              label: filter,
              selected: selectedFilter == filter,
              onTap: () => onChanged(filter),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        splashColor: _ManageVolunteersScreenState._primaryOrange.withAlpha(22),
        child: AnimatedContainer(
          height: 40,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? _ManageVolunteersScreenState._primaryOrange
                : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? _ManageVolunteersScreenState._primaryOrange
                  : _ManageVolunteersScreenState._borderGray,
            ),
            boxShadow: selected ? _softShadow : const [],
          ),
          child: Text(
            label,
            style: _VolunteersText.filter.copyWith(
              color: selected ? Colors.white : AppColors.textDarkPrimary,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedVolunteerCard extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedVolunteerCard({
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 260 + (index.clamp(0, 6) * 45)),
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
      child: child,
    );
  }
}

class _VolunteerCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final int index;
  final dynamic provider;
  final VoidCallback onTap;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _VolunteerCard({
    required this.request,
    required this.index,
    required this.provider,
    required this.onTap,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final status = _statusLabel(request);
    final pending = status == 'بانتظار المراجعة';

    return _SoftCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          splashColor:
              _ManageVolunteersScreenState._primaryOrange.withAlpha(22),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  _volunteerName(request),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: _VolunteersText.cardTitle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _StatusBadge(
                                label: status,
                                color: _statusColor(status),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _volunteerSkill(request),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _VolunteersText.skill,
                          ),
                          const SizedBox(height: 10),
                          _InfoLine(
                            icon: Icons.schedule_rounded,
                            text: _volunteerHours(request),
                          ),
                          const SizedBox(height: 6),
                          _InfoLine(
                            icon: Icons.history_rounded,
                            text: _lastActivity(request),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    _VolunteerAvatar(request: request, index: index, size: 72),
                  ],
                ),
                if (pending) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _PrimaryActionButton(
                          label: 'قبول',
                          loading: provider.isSaving,
                          onTap: onAccept,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SecondaryActionButton(
                          label: 'رفض',
                          onTap: provider.isSaving ? null : onReject,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: _ManageVolunteersScreenState._textGray,
          size: 15,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _VolunteersText.muted,
          ),
        ),
      ],
    );
  }
}

class _VolunteerAvatar extends StatelessWidget {
  final Map<String, dynamic> request;
  final int index;
  final double size;

  const _VolunteerAvatar({
    required this.request,
    required this.index,
    this.size = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'care-home-volunteer-${request['id'] ?? index}',
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: _softShadow,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: ClipOval(
          child: _avatarImage(request, index, size),
        ),
      ),
    );
  }

  Widget _avatarImage(Map<String, dynamic> request, int index, double size) {
    final url = _value(request, const ['image_url', 'avatar', 'photo']);
    if (url.startsWith('http')) {
      return Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _AvatarFallback(size: size),
      );
    }
    return Image.asset(
      _avatarAsset(index),
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _AvatarFallback(size: size),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  final double size;

  const _AvatarFallback({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: _ManageVolunteersScreenState._softGray,
      child: const Icon(
        Icons.person_rounded,
        color: _ManageVolunteersScreenState._primaryOrange,
        size: 30,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 104),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(label == 'بانتظار المراجعة' ? 18 : 20),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(44)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _VolunteersText.badge.copyWith(color: color),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onTap;

  const _PrimaryActionButton({
    required this.label,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _ManageVolunteersScreenState._primaryOrange,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              _ManageVolunteersScreenState._primaryOrange.withAlpha(150),
          elevation: 0,
          textStyle: _VolunteersText.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(label),
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _SecondaryActionButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: _ManageVolunteersScreenState._primaryOrange,
          side: BorderSide(
            color: _ManageVolunteersScreenState._primaryOrange.withAlpha(90),
          ),
          elevation: 0,
          textStyle: _VolunteersText.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _VolunteerDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> request;
  final int index;
  final dynamic provider;

  const _VolunteerDetailsSheet({
    required this.request,
    required this.index,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final id = int.tryParse(request['id']?.toString() ?? '');
    final status = _statusLabel(request);
    final canRate = status == 'نشط' && request['rating'] == null && id != null;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            18,
            0,
            18,
            18 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _SoftCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _VolunteerAvatar(request: request, index: index, size: 82),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _volunteerName(request),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: _VolunteersText.sheetTitle,
                          ),
                          const SizedBox(height: 7),
                          Text(
                            _volunteerSkill(request),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: _VolunteersText.skill,
                          ),
                          const SizedBox(height: 9),
                          _StatusBadge(
                              label: status, color: _statusColor(status)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _DetailRow(
                  icon: Icons.phone_rounded,
                  label: 'رقم الهاتف',
                  value: _phone(request),
                ),
                _DetailRow(
                  icon: Icons.email_rounded,
                  label: 'البريد الإلكتروني',
                  value: _email(request),
                ),
                _DetailRow(
                  icon: Icons.timer_rounded,
                  label: 'الساعات التطوعية',
                  value: _volunteerHours(request),
                ),
                _DetailRow(
                  icon: Icons.history_rounded,
                  label: 'آخر نشاط',
                  value: _lastActivity(request),
                ),
                _DetailRow(
                  icon: Icons.notes_rounded,
                  label: 'نبذة قصيرة',
                  value: _bio(request),
                ),
                if (canRate) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: provider.isSaving
                          ? null
                          : () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed(
                                '/care_home_rate_volunteers',
                                arguments: request,
                              );
                            },
                      icon: const Icon(Icons.star_rounded, size: 19),
                      label: const Text('تقييم المتطوع'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _ManageVolunteersScreenState._primaryOrange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        textStyle: _VolunteersText.button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: _ManageVolunteersScreenState._softGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _ManageVolunteersScreenState._borderGray),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: _ManageVolunteersScreenState._primaryOrange,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: _VolunteersText.detailLabel),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: _VolunteersText.body,
                    softWrap: true,
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SoftCard(
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 34),
      child: Column(
        children: [
          _EmptyIllustration(),
          SizedBox(height: 16),
          Text(
            'لا توجد طلبات تطوع حالياً',
            textAlign: TextAlign.center,
            style: _VolunteersText.emptyTitle,
          ),
          SizedBox(height: 8),
          Text(
            'سيتم عرض الطلبات الجديدة هنا عند وصولها.',
            textAlign: TextAlign.center,
            style: _VolunteersText.body,
          ),
        ],
      ),
    );
  }
}

class _EmptyIllustration extends StatelessWidget {
  const _EmptyIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      height: 92,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 8,
            child: Container(
              width: 86,
              height: 54,
              decoration: BoxDecoration(
                color:
                    _ManageVolunteersScreenState._primaryOrange.withAlpha(18),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color:
                      _ManageVolunteersScreenState._primaryOrange.withAlpha(34),
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
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _ManageVolunteersScreenState._borderGray,
                ),
                boxShadow: _softShadow,
              ),
              child: const Icon(
                Icons.volunteer_activism_rounded,
                color: _ManageVolunteersScreenState._primaryOrange,
                size: 31,
              ),
            ),
          ),
          PositionedDirectional(
            end: 12,
            bottom: 12,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: _ManageVolunteersScreenState._primaryOrange,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: _ManageVolunteersScreenState._primaryOrange,
        strokeWidth: 2.6,
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double iconSize;

  const _CircleIconButton({
    required this.icon,
    this.onTap,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        splashColor: _ManageVolunteersScreenState._primaryOrange.withAlpha(22),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _ManageVolunteersScreenState._borderGray),
            boxShadow: _softShadow,
          ),
          child: Icon(
            icon,
            color: AppColors.textDarkPrimary,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const _SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _ManageVolunteersScreenState._borderGray),
        boxShadow: _softShadow,
      ),
      child: child,
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 58,
      color: _ManageVolunteersScreenState._borderGray,
    );
  }
}

String _volunteerName(Map<String, dynamic> request) {
  return _value(
      request,
      const [
        'volunteer_name',
        'name',
        'full_name',
        'user_name',
      ],
      fallback: 'متطوع');
}

String _volunteerSkill(Map<String, dynamic> request) {
  return _value(
      request,
      const [
        'specialty',
        'skill',
        'skills',
        'title',
      ],
      fallback: 'أنشطة أطفال');
}

String _volunteerHours(Map<String, dynamic> request) {
  final value = _value(request, const [
    'hours_worked',
    'hours',
    'volunteer_hours',
  ]);
  if (value.isEmpty) return '0 ساعات تطوع';
  return value.contains('ساعة') || value.contains('ساعات')
      ? value
      : '$value ساعات تطوع';
}

String _lastActivity(Map<String, dynamic> request) {
  final value = _value(request, const [
    'last_activity',
    'updated_at',
    'created_at',
    'date',
  ]);
  if (value.isEmpty) return 'آخر نشاط غير محدد';
  return 'آخر نشاط: ${_shortDate(value)}';
}

String _phone(Map<String, dynamic> request) {
  return _value(request, const ['phone', 'phone_number', 'mobile'],
      fallback: 'غير متوفر');
}

String _email(Map<String, dynamic> request) {
  return _value(request, const ['email', 'mail'], fallback: 'غير متوفر');
}

String _bio(Map<String, dynamic> request) {
  return _value(request, const ['bio', 'description', 'notes', 'about'],
      fallback: 'لا توجد نبذة إضافية.');
}

String _statusLabel(Map<String, dynamic> request) {
  final status = _value(request, const ['status']).trim().toLowerCase();
  if (status == 'pending' ||
      status == 'قيد المراجعة' ||
      status == 'بانتظار المراجعة') {
    return 'بانتظار المراجعة';
  }
  if (status == 'accepted' || status == 'مقبول') return 'مقبول';
  if (status == 'rejected' || status == 'مرفوض') return 'مرفوض';
  if (status == 'completed' ||
      status == 'active' ||
      status == 'نشط' ||
      status == 'مكتمل') {
    return 'نشط';
  }
  return status.isEmpty ? 'بانتظار المراجعة' : status;
}

Color _statusColor(String label) {
  if (label == 'مقبول') return _ManageVolunteersScreenState._statusGreen;
  if (label == 'مرفوض') return _ManageVolunteersScreenState._statusRed;
  if (label == 'نشط') return _ManageVolunteersScreenState._statusBlue;
  return _ManageVolunteersScreenState._primaryOrange;
}

String _value(
  Map<String, dynamic> request,
  List<String> keys, {
  String fallback = '',
}) {
  for (final key in keys) {
    final value = request[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString().trim();
    }
  }
  return fallback;
}

String _shortDate(String value) {
  if (value.length >= 10 && value[4] == '-') {
    return value.substring(0, 10).replaceAll('-', '/');
  }
  return value;
}

String _avatarAsset(int index) {
  const assets = [
    'assets/images/image2.png',
    'assets/images/image4.png',
    'assets/images/image5.png',
    'assets/images/image6.png',
    'assets/images/image7.png',
  ];
  return assets[index % assets.length];
}

enum _VolunteerMenuAction { needs, donations, reports, profile }

const List<BoxShadow> _softShadow = [
  BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 20,
    offset: Offset(0, 9),
  ),
];

class _VolunteersText {
  static const TextStyle title = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _ManageVolunteersScreenState._textBlack,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle number = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _ManageVolunteersScreenState._primaryOrange,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _ManageVolunteersScreenState._textBlack,
    fontSize: 15.5,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle sheetTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _ManageVolunteersScreenState._textBlack,
    fontSize: 17,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle emptyTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _ManageVolunteersScreenState._textBlack,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle body = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _ManageVolunteersScreenState._textGray,
    fontSize: 13.5,
    height: 1.45,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle skill = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _ManageVolunteersScreenState._textBlack,
    fontSize: 13.5,
    height: 1.35,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle muted = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _ManageVolunteersScreenState._textGray,
    fontSize: 12,
    height: 1.35,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _ManageVolunteersScreenState._textBlack,
    fontSize: 11.8,
    height: 1.35,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle hint = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _ManageVolunteersScreenState._textGray,
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle filter = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 13,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle detailLabel = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _ManageVolunteersScreenState._textGray,
    fontSize: 11.5,
    height: 1.25,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle button = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 13.5,
    fontWeight: FontWeight.w700,
  );

  const _VolunteersText._();
}
