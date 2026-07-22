import 'package:flutter/material.dart';

import '../../models/donation_model.dart';
import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class IncomingDonationsScreen extends StatefulWidget {
  const IncomingDonationsScreen({super.key});

  @override
  State<IncomingDonationsScreen> createState() =>
      _IncomingDonationsScreenState();
}

class _IncomingDonationsScreenState extends State<IncomingDonationsScreen>
    with SingleTickerProviderStateMixin {
  static const Color _primaryOrange = AppColors.brandOrange;
  static const Color _background = Colors.white;
  static const Color _softGray = Color(0xFFF7F7F7);
  static const Color _borderGray = Color(0xFFEDEDED);
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
      AppProviderScope.of(context).fetchDonations();
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
    final allDonations = provider.donations;
    final donations = allDonations.where(_matchesFilters).toList();

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
                    title: 'التبرعات الواردة',
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
                      onRefresh: provider.fetchDonations,
                      child: provider.isLoading
                          ? const _LoadingState()
                          : provider.errorMessage != null
                              ? _ErrorState(
                                  message: provider.errorMessage!,
                                  onRetry: provider.fetchDonations,
                                )
                              : FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: ListView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics(),
                                    ),
                                    padding: const EdgeInsets.fromLTRB(
                                      20,
                                      12,
                                      20,
                                      24,
                                    ),
                                    children: [
                                      _SummaryCard(donations: allDonations),
                                      const SizedBox(height: 16),
                                      _SearchField(
                                        controller: _searchController,
                                      ),
                                      const SizedBox(height: 14),
                                      _FilterChips(
                                        selectedFilter: _selectedFilter,
                                        onChanged: (filter) {
                                          setState(
                                            () => _selectedFilter = filter,
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 18),
                                      if (donations.isEmpty)
                                        const _EmptyState()
                                      else
                                        ...List.generate(donations.length,
                                            (index) {
                                          final donation = donations[index];
                                          return _AnimatedDonationCard(
                                            index: index,
                                            child: _DonationCard(
                                              donation: donation,
                                              provider: provider,
                                              onDetails: () {
                                                _showDonationDetails(
                                                  donation,
                                                  provider,
                                                );
                                              },
                                              onConfirm: () {
                                                _confirmDonationReceived(
                                                  donation,
                                                  provider,
                                                );
                                              },
                                            ),
                                          );
                                        }),
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

  bool _matchesFilters(DonationModel donation) {
    final matchesSearch = _searchText.isEmpty ||
        donation.donorName.contains(_searchText) ||
        donation.itemType.contains(_searchText) ||
        (donation.category ?? '').contains(_searchText) ||
        _donationTypeLabel(donation).contains(_searchText);
    if (!matchesSearch) return false;

    if (_selectedFilter == 'مالية') return donation.amount != null;
    if (_selectedFilter == 'عينية') return donation.amount == null;
    if (_selectedFilter == 'قيد الاستلام') return !_isCompleted(donation);
    if (_selectedFilter == 'مكتملة') return _isCompleted(donation);
    return true;
  }

  Widget _menu() {
    return PopupMenuButton<_IncomingMenuAction>(
      tooltip: 'القائمة',
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      position: PopupMenuPosition.under,
      onSelected: (action) {
        switch (action) {
          case _IncomingMenuAction.needs:
            Navigator.of(context).pushNamed('/care_home_needs_list');
            break;
          case _IncomingMenuAction.volunteers:
            Navigator.of(context).pushNamed('/care_home_manage_volunteers');
            break;
          case _IncomingMenuAction.reports:
            Navigator.of(context).pushNamed('/care_home_reports');
            break;
          case _IncomingMenuAction.profile:
            Navigator.of(context).pushNamed('/care_home_profile');
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _IncomingMenuAction.needs,
          child: Text('الاحتياجات'),
        ),
        PopupMenuItem(
          value: _IncomingMenuAction.volunteers,
          child: Text('المتطوعون'),
        ),
        PopupMenuItem(
          value: _IncomingMenuAction.reports,
          child: Text('التقارير'),
        ),
        PopupMenuItem(
          value: _IncomingMenuAction.profile,
          child: Text('ملف الدار'),
        ),
      ],
      child: const _CircleIconButton(icon: Icons.more_horiz_rounded),
    );
  }

  Future<void> _confirmDonationReceived(
    DonationModel donation,
    dynamic provider,
  ) async {
    final success = await provider.confirmDonationReceived(donation.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'تم تأكيد الاستلام'
              : provider.errorMessage ?? 'تعذر تأكيد الاستلام',
          style: const TextStyle(
              fontFamily: careHomeFontFamily, color: Colors.white),
        ),
        backgroundColor: success ? _statusGreen : _statusRed,
      ),
    );
  }

  void _showDonationDetails(DonationModel donation, dynamic provider) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: _DonationDetailsSheet(
            donation: donation,
            provider: provider,
            onConfirm: () {
              Navigator.of(context).pop();
              _confirmDonationReceived(donation, provider);
            },
          ),
        );
      },
    );
  }
}

class IncomingDonationsLegacyTopBar extends StatelessWidget {
  final Widget menu;
  final VoidCallback onNotifications;

  const IncomingDonationsLegacyTopBar({
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
              'التبرعات الواردة',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _IncomingText.title,
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
  final List<DonationModel> donations;

  const _SummaryCard({required this.donations});

  @override
  Widget build(BuildContext context) {
    final completed = donations.where(_isCompleted).length;
    final pending = donations.length - completed;

    return _SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              icon: Icons.volunteer_activism_rounded,
              value: '${donations.length}',
              label: 'عدد التبرعات',
            ),
          ),
          const _VerticalDivider(),
          Expanded(
            child: _SummaryItem(
              icon: Icons.verified_rounded,
              value: '$completed',
              label: 'التبرعات المكتملة',
            ),
          ),
          const _VerticalDivider(),
          Expanded(
            child: _SummaryItem(
              icon: Icons.inventory_rounded,
              value: '$pending',
              label: 'قيد الاستلام',
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
            color: _IncomingDonationsScreenState._primaryOrange.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: _IncomingDonationsScreenState._primaryOrange,
            size: 19,
          ),
        ),
        const SizedBox(height: 8),
        Text(value, style: _IncomingText.number),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: _IncomingText.caption,
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
        border: Border.all(color: _IncomingDonationsScreenState._borderGray),
        boxShadow: _softShadow,
      ),
      child: TextField(
        controller: controller,
        cursorColor: _IncomingDonationsScreenState._primaryOrange,
        textInputAction: TextInputAction.search,
        style: _IncomingText.body.copyWith(color: AppColors.textDarkPrimary),
        decoration: const InputDecoration(
          hintText: 'ابحث عن متبرع أو نوع تبرع',
          hintStyle: _IncomingText.hint,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: _IncomingDonationsScreenState._primaryOrange,
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

  static const filters = ['الكل', 'مالية', 'عينية', 'قيد الاستلام', 'مكتملة'];

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
        splashColor: _IncomingDonationsScreenState._primaryOrange.withAlpha(22),
        child: AnimatedContainer(
          height: 40,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? _IncomingDonationsScreenState._primaryOrange
                : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? _IncomingDonationsScreenState._primaryOrange
                  : _IncomingDonationsScreenState._borderGray,
            ),
            boxShadow: selected ? _softShadow : const [],
          ),
          child: Text(
            label,
            style: _IncomingText.filter.copyWith(
              color: selected ? Colors.white : AppColors.textDarkPrimary,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedDonationCard extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedDonationCard({
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

class _DonationCard extends StatelessWidget {
  final DonationModel donation;
  final dynamic provider;
  final VoidCallback onDetails;
  final VoidCallback onConfirm;

  const _DonationCard({
    required this.donation,
    required this.provider,
    required this.onDetails,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final completed = _isCompleted(donation);
    final cancelled = _isCancelled(donation);
    final status = _statusLabel(donation);

    return _SoftCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              height: 122,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          donation.donorName.isEmpty
                              ? 'متبرع'
                              : donation.donorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _IncomingText.cardTitle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusBadge(
                          label: status, color: _statusColor(donation)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _donationTypeLabel(donation),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _IncomingText.body,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatDate(donation.donationDate ?? donation.createdAt),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _IncomingText.muted,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(donation.donationDate ?? donation.createdAt),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _IncomingText.muted,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      _DetailsButton(onTap: onDetails),
                      if (!completed && !cancelled) ...[
                        const SizedBox(width: 8),
                        _ConfirmButton(
                          loading: provider.isSaving,
                          onTap: onConfirm,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
          _DonationImage(donation: donation),
        ],
      ),
    );
  }
}

class _DonationImage extends StatelessWidget {
  final DonationModel donation;

  const _DonationImage({required this.donation});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        _imageForDonation(donation),
        width: 92,
        height: 122,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 92,
            height: 122,
            color: _IncomingDonationsScreenState._softGray,
            child: const Icon(
              Icons.inventory_2_rounded,
              color: _IncomingDonationsScreenState._primaryOrange,
              size: 30,
            ),
          );
        },
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(44)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _IncomingText.badge.copyWith(color: color),
      ),
    );
  }
}

class _DetailsButton extends StatelessWidget {
  final VoidCallback onTap;

  const _DetailsButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: _IncomingDonationsScreenState._primaryOrange,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        minimumSize: const Size(0, 34),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: _IncomingText.smallButton,
      ),
      child: const Text('عرض التفاصيل'),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;

  const _ConfirmButton({
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: OutlinedButton(
        onPressed: loading ? null : onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: _IncomingDonationsScreenState._primaryOrange,
          side: BorderSide(
            color: _IncomingDonationsScreenState._primaryOrange.withAlpha(80),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: _IncomingText.smallButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  color: _IncomingDonationsScreenState._primaryOrange,
                  strokeWidth: 2,
                ),
              )
            : const Text('تأكيد الاستلام'),
      ),
    );
  }
}

class _DonationDetailsSheet extends StatelessWidget {
  final DonationModel donation;
  final dynamic provider;
  final VoidCallback onConfirm;

  const _DonationDetailsSheet({
    required this.donation,
    required this.provider,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final completed = _isCompleted(donation);
    final cancelled = _isCancelled(donation);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _DonationImage(donation: donation),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        donation.donorName.isEmpty
                            ? 'متبرع'
                            : donation.donorName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: _IncomingText.cardTitle,
                      ),
                      const SizedBox(height: 8),
                      _StatusBadge(
                        label: _statusLabel(donation),
                        color: _statusColor(donation),
                      ),
                      const SizedBox(height: 8),
                      Text(_donationTypeLabel(donation),
                          style: _IncomingText.body),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _DetailRow(
              label: 'تاريخ الوصول',
              value: _formatDate(donation.donationDate ?? donation.createdAt),
            ),
            _DetailRow(
              label: 'وقت الوصول',
              value: _formatTime(donation.donationDate ?? donation.createdAt),
            ),
            _DetailRow(
              label: 'الوصف',
              value: (donation.description ?? '').isEmpty
                  ? 'لا يوجد وصف إضافي'
                  : donation.description!,
            ),
            if (!completed && !cancelled) ...[
              const SizedBox(height: 14),
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: provider.isSaving ? null : onConfirm,
                  icon: const Icon(Icons.check_circle_rounded, size: 19),
                  label: const Text('تأكيد الاستلام'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _IncomingDonationsScreenState._primaryOrange,
                    foregroundColor: Colors.white,
                    textStyle: _IncomingText.button,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(label, style: _IncomingText.muted),
          ),
          Expanded(
            child: Text(value, style: _IncomingText.body),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 34),
      child: Column(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: _IncomingDonationsScreenState._primaryOrange.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.volunteer_activism_rounded,
              color: _IncomingDonationsScreenState._primaryOrange,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد تبرعات واردة حالياً',
            textAlign: TextAlign.center,
            style: _IncomingText.emptyTitle,
          ),
          const SizedBox(height: 8),
          const Text(
            'سيتم عرض التبرعات الجديدة هنا بمجرد وصولها.',
            textAlign: TextAlign.center,
            style: _IncomingText.body,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

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
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 80),
        _SoftCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: _IncomingDonationsScreenState._statusRed.withAlpha(18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: _IncomingDonationsScreenState._statusRed,
                  size: 30,
                ),
              ),
              const SizedBox(height: 14),
              Text(message,
                  textAlign: TextAlign.center, style: _IncomingText.body),
              const SizedBox(height: 16),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _IncomingDonationsScreenState._primaryOrange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    textStyle: _IncomingText.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
        color: _IncomingDonationsScreenState._primaryOrange,
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
        splashColor: _IncomingDonationsScreenState._primaryOrange.withAlpha(22),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(color: _IncomingDonationsScreenState._borderGray),
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
        border: Border.all(color: _IncomingDonationsScreenState._borderGray),
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
      color: _IncomingDonationsScreenState._borderGray,
    );
  }
}

String _donationTypeLabel(DonationModel donation) {
  if (donation.amount != null) {
    return 'تبرع مالي - ${donation.amount!.toStringAsFixed(0)} د.ل';
  }
  final item =
      donation.itemType.trim().isEmpty ? 'تبرع عيني' : donation.itemType;
  return 'تبرع عيني - $item';
}

bool _isCompleted(DonationModel donation) {
  final status = donation.status.trim().toLowerCase();
  return status == 'completed' ||
      status == 'received' ||
      status == 'مكتمل' ||
      status == 'تم الاستلام';
}

bool _isCancelled(DonationModel donation) {
  final status = donation.status.trim().toLowerCase();
  return status == 'cancelled' || status == 'canceled' || status == 'ملغي';
}

String _statusLabel(DonationModel donation) {
  if (_isCompleted(donation)) return 'مكتمل';
  if (_isCancelled(donation)) return 'ملغي';
  return 'قيد الاستلام';
}

Color _statusColor(DonationModel donation) {
  if (_isCompleted(donation)) return _IncomingDonationsScreenState._statusGreen;
  if (_isCancelled(donation)) return _IncomingDonationsScreenState._statusRed;
  return _IncomingDonationsScreenState._statusBlue;
}

String _formatDate(DateTime? date) {
  if (date == null) return 'غير محدد';
  return '${date.year}/${_twoDigits(date.month)}/${_twoDigits(date.day)}';
}

String _formatTime(DateTime? date) {
  if (date == null) return 'غير محدد';
  return '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _imageForDonation(DonationModel donation) {
  final text =
      '${donation.itemType} ${donation.category ?? ''} ${donation.description ?? ''}';
  if (text.contains('ماء') ||
      text.contains('مياه') ||
      text.toLowerCase().contains('water')) {
    return 'assets/images/image5.png';
  }
  if (text.contains('دواء') ||
      text.contains('أدوية') ||
      text.contains('طبي') ||
      text.toLowerCase().contains('medicine')) {
    return 'assets/images/image8.png';
  }
  if (text.contains('ملابس') ||
      text.contains('كسوة') ||
      text.contains('شتوية') ||
      text.toLowerCase().contains('clothes')) {
    return 'assets/images/a.png';
  }
  if (text.contains('مدرس') ||
      text.contains('تعليم') ||
      text.contains('حقيبة') ||
      text.toLowerCase().contains('school')) {
    return 'assets/images/image7.png';
  }
  if (text.contains('غذ') ||
      text.contains('سلة') ||
      text.contains('طعام') ||
      text.toLowerCase().contains('food')) {
    return 'assets/images/c.png';
  }
  return donation.amount != null
      ? 'assets/images/b.png'
      : 'assets/images/c.png';
}

enum _IncomingMenuAction { needs, volunteers, reports, profile }

const List<BoxShadow> _softShadow = [
  BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 18,
    offset: Offset(0, 8),
  ),
];

class _IncomingText {
  static const TextStyle title = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle number = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _IncomingDonationsScreenState._primaryOrange,
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle emptyTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle body = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkSecondary,
    fontSize: 13.5,
    height: 1.45,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle muted = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkMuted,
    fontSize: 12,
    height: 1.35,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkPrimary,
    fontSize: 11.8,
    height: 1.35,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle hint = TextStyle(
    fontFamily: careHomeFontFamily,
    color: AppColors.textDarkMuted,
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
    fontWeight: FontWeight.w900,
  );

  static const TextStyle smallButton = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 12.5,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle button = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w900,
  );

  const _IncomingText._();
}
