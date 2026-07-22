import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class VisitHoursScreen extends StatefulWidget {
  const VisitHoursScreen({super.key});

  @override
  State<VisitHoursScreen> createState() => _VisitHoursScreenState();
}

class _VisitHoursScreenState extends State<VisitHoursScreen>
    with SingleTickerProviderStateMixin {
  static const Color _primaryOrange = AppColors.brandOrange;
  static const Color _background = Colors.white;
  static const Color _softGray = Color(0xFFF7F7F7);
  static const Color _borderGray = Color(0xFFEDEDED);
  static const Color _textBlack = Color(0xFF171717);
  static const Color _textGray = Color(0xFF686868);
  static const Color _statusGreen = Color(0xFF27AE60);
  static const double _mobileMaxWidth = 480;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppProviderScope.of(context).fetchVisitHours();
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
    final slots = provider.visitHours;

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
                    title: 'ساعات الزيارة',
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
                      onRefresh: provider.fetchVisitHours,
                      child: provider.isLoading
                          ? const _LoadingState()
                          : FadeTransition(
                              opacity: _fadeAnimation,
                              child: slots.isEmpty
                                  ? _EmptyState(onAdd: _showSlotSheet)
                                  : ListView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(
                                        parent: BouncingScrollPhysics(),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                        18,
                                        12,
                                        18,
                                        18,
                                      ),
                                      children: [
                                        const _HeroVisitCard(),
                                        const SizedBox(height: 16),
                                        _ScheduleCard(
                                          slots: slots,
                                          provider: provider,
                                        ),
                                        const SizedBox(height: 16),
                                        const _GuidelinesCard(),
                                      ],
                                    ),
                            ),
                    ),
                  ),
                  if (!provider.isLoading && slots.isNotEmpty)
                    _BottomEditButton(
                      loading: provider.isSaving,
                      onPressed: _showSlotSheet,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _menu() {
    return PopupMenuButton<_VisitMenuAction>(
      tooltip: 'القائمة',
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      position: PopupMenuPosition.under,
      onSelected: (action) {
        switch (action) {
          case _VisitMenuAction.needs:
            Navigator.of(context).pushNamed('/care_home_needs_list');
            break;
          case _VisitMenuAction.donations:
            Navigator.of(context).pushNamed('/care_home_incoming_donations');
            break;
          case _VisitMenuAction.volunteers:
            Navigator.of(context).pushNamed('/care_home_manage_volunteers');
            break;
          case _VisitMenuAction.reports:
            Navigator.of(context).pushNamed('/care_home_reports');
            break;
          case _VisitMenuAction.profile:
            Navigator.of(context).pushNamed('/care_home_profile');
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _VisitMenuAction.needs,
          child: Text('الاحتياجات'),
        ),
        PopupMenuItem(
          value: _VisitMenuAction.donations,
          child: Text('التبرعات'),
        ),
        PopupMenuItem(
          value: _VisitMenuAction.volunteers,
          child: Text('المتطوعون'),
        ),
        PopupMenuItem(
          value: _VisitMenuAction.reports,
          child: Text('التقارير'),
        ),
        PopupMenuItem(
          value: _VisitMenuAction.profile,
          child: Text('ملف الدار'),
        ),
      ],
      child: const _CircleIconButton(icon: Icons.more_horiz_rounded),
    );
  }

  Future<void> _showSlotSheet() async {
    final provider = AppProviderScope.of(context);
    final dayController = TextEditingController();
    final startController = TextEditingController();
    final endController = TextEditingController();
    final notesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                left: 18,
                right: 18,
                top: 6,
                bottom: MediaQuery.of(context).viewInsets.bottom + 18,
              ),
              child: _SoftCard(
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'تعديل ساعات الزيارة',
                        textAlign: TextAlign.center,
                        style: _VisitText.sheetTitle,
                      ),
                      const SizedBox(height: 16),
                      CareHomeInputField(
                        controller: dayController,
                        label: '',
                        hint: 'اليوم',
                        icon: Icons.today_rounded,
                        validator: _required,
                        fillColor: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      CareHomeInputField(
                        controller: startController,
                        label: '',
                        hint: 'وقت البداية HH:MM',
                        icon: Icons.schedule_rounded,
                        validator: _required,
                        fillColor: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      CareHomeInputField(
                        controller: endController,
                        label: '',
                        hint: 'وقت النهاية HH:MM',
                        icon: Icons.schedule_rounded,
                        validator: _required,
                        fillColor: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      CareHomeInputField(
                        controller: notesController,
                        label: '',
                        hint: 'ملاحظات',
                        icon: Icons.notes_rounded,
                        fillColor: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      _PrimaryVisitButton(
                        label: 'حفظ',
                        icon: Icons.check_rounded,
                        loading: provider.isSaving,
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          final ok = await provider.createVisitHour({
                            'day': dayController.text.trim(),
                            'start_time': startController.text.trim(),
                            'end_time': endController.text.trim(),
                            'notes': notesController.text.trim(),
                            'is_available': true,
                          });
                          if (context.mounted && ok) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'هذا الحقل مطلوب' : null;
}

class VisitHoursLegacyTopBar extends StatelessWidget {
  final Widget menu;
  final VoidCallback onNotifications;

  const VisitHoursLegacyTopBar({
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
              'ساعات الزيارة',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _VisitText.title,
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

class _HeroVisitCard extends StatelessWidget {
  const _HeroVisitCard();

  @override
  Widget build(BuildContext context) {
    return _AnimatedCard(
      index: 0,
      child: _SoftCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color:
                          _VisitHoursScreenState._primaryOrange.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: _VisitHoursScreenState._primaryOrange,
                      size: 21,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'مواعيد استقبال الزوار',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: _VisitText.cardTitle,
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'حدّد أوقات الزيارة الرسمية لتسهيل استقبال المتبرعين والمتطوعين والزوار.',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: _VisitText.body,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: AspectRatio(
                  aspectRatio: 0.82,
                  child: Image.asset(
                    'assets/images/image8.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: _VisitHoursScreenState._softGray,
                        child: const Icon(
                          Icons.meeting_room_rounded,
                          color: _VisitHoursScreenState._primaryOrange,
                          size: 34,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final List<Map<String, dynamic>> slots;
  final dynamic provider;

  const _ScheduleCard({
    required this.slots,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return _AnimatedCard(
      index: 1,
      child: _SoftCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('الأوقات المتاحة', style: _VisitText.sectionTitle),
            const SizedBox(height: 14),
            ...List.generate(slots.length, (index) {
              return _VisitDayRow(
                slot: slots[index],
                provider: provider,
                isLast: index == slots.length - 1,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _VisitDayRow extends StatelessWidget {
  final Map<String, dynamic> slot;
  final dynamic provider;
  final bool isLast;

  const _VisitDayRow({
    required this.slot,
    required this.provider,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final status = _visitStatus(slot);
    final statusColor = _visitStatusColor(status);
    final isClosed = status == 'مغلق';
    final id = int.tryParse(slot['id']?.toString() ?? '');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLast
                ? Colors.transparent
                : _VisitHoursScreenState._borderGray,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _slotDay(slot),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _VisitText.dayTitle,
                ),
                const SizedBox(height: 5),
                Text(
                  isClosed
                      ? 'مغلق'
                      : '${_formatTime(_slotStart(slot))} إلى ${_formatTime(_slotEnd(slot))}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _VisitText.time,
                ),
                if (_slotNotes(slot).isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _slotNotes(slot),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _VisitText.muted,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              onTap: id == null
                  ? null
                  : () {
                      provider.updateVisitHour(id, {
                        'is_available': isClosed,
                      });
                    },
              borderRadius: BorderRadius.circular(999),
              splashColor: _VisitHoursScreenState._primaryOrange.withAlpha(22),
              child: _StatusBadge(label: status, color: statusColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidelinesCard extends StatelessWidget {
  const _GuidelinesCard();

  @override
  Widget build(BuildContext context) {
    const items = [
      _GuidelineItemData(
        icon: Icons.access_time_rounded,
        text: 'الالتزام بالمواعيد المحددة.',
      ),
      _GuidelineItemData(
        icon: Icons.groups_rounded,
        text: 'التنسيق المسبق للزيارات الجماعية.',
      ),
      _GuidelineItemData(
        icon: Icons.volume_down_rounded,
        text: 'المحافظة على هدوء المكان.',
      ),
      _GuidelineItemData(
        icon: Icons.privacy_tip_rounded,
        text: 'احترام خصوصية الأطفال.',
      ),
    ];

    return _AnimatedCard(
      index: 2,
      child: _SoftCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('إرشادات الزيارة', style: _VisitText.sectionTitle),
            const SizedBox(height: 14),
            ...items.map((item) => _GuidelineItem(item: item)),
          ],
        ),
      ),
    );
  }
}

class _GuidelineItem extends StatelessWidget {
  final _GuidelineItemData item;

  const _GuidelineItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _VisitHoursScreenState._primaryOrange.withAlpha(18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              color: _VisitHoursScreenState._primaryOrange,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                item.text,
                style: _VisitText.body,
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomEditButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const _BottomEditButton({
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
        child: _PrimaryVisitButton(
          label: 'تعديل ساعات الزيارة',
          icon: Icons.edit_rounded,
          loading: loading,
          onPressed: onPressed,
        ),
      ),
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
      padding: const EdgeInsets.fromLTRB(18, 70, 18, 26),
      children: [
        _SoftCard(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 34),
          child: Column(
            children: [
              const _EmptyIllustration(),
              const SizedBox(height: 16),
              const Text(
                'لم يتم تحديد ساعات الزيارة بعد',
                textAlign: TextAlign.center,
                style: _VisitText.emptyTitle,
              ),
              const SizedBox(height: 8),
              const Text(
                'أضف الأوقات الرسمية ليستطيع الزوار التخطيط لزيارتهم بسهولة.',
                textAlign: TextAlign.center,
                style: _VisitText.body,
              ),
              const SizedBox(height: 18),
              _PrimaryVisitButton(
                label: 'إضافة ساعات الزيارة',
                icon: Icons.add_rounded,
                onPressed: onAdd,
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
      width: 116,
      height: 94,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 8,
            child: Container(
              width: 88,
              height: 56,
              decoration: BoxDecoration(
                color: _VisitHoursScreenState._primaryOrange.withAlpha(18),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: _VisitHoursScreenState._primaryOrange.withAlpha(34),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            child: Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: _VisitHoursScreenState._borderGray),
                boxShadow: _softShadow,
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                color: _VisitHoursScreenState._primaryOrange,
                size: 30,
              ),
            ),
          ),
          PositionedDirectional(
            end: 12,
            bottom: 12,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.schedule_rounded,
                color: _VisitHoursScreenState._primaryOrange,
                size: 17,
              ),
            ),
          ),
        ],
      ),
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
      duration: Duration(milliseconds: 260 + (index * 55)),
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

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      constraints: const BoxConstraints(minWidth: 60, maxWidth: 84),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(label == 'مغلق' ? 16 : 20),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(46)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _VisitText.badge.copyWith(color: color),
      ),
    );
  }
}

class _PrimaryVisitButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool loading;

  const _PrimaryVisitButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: loading ? null : onPressed,
        icon: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.1,
                ),
              )
            : Icon(icon, size: 19),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: _VisitHoursScreenState._primaryOrange,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              _VisitHoursScreenState._primaryOrange.withAlpha(150),
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: _VisitText.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
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
        splashColor: _VisitHoursScreenState._primaryOrange.withAlpha(22),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _VisitHoursScreenState._borderGray),
            boxShadow: _softShadow,
          ),
          child: Icon(
            icon,
            color: _VisitHoursScreenState._textBlack,
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

  const _SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _VisitHoursScreenState._borderGray),
        boxShadow: _softShadow,
      ),
      child: child,
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: _VisitHoursScreenState._primaryOrange,
        strokeWidth: 2.6,
      ),
    );
  }
}

class _GuidelineItemData {
  final IconData icon;
  final String text;

  const _GuidelineItemData({
    required this.icon,
    required this.text,
  });
}

enum _VisitMenuAction { needs, donations, volunteers, reports, profile }

const List<BoxShadow> _softShadow = [
  BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 20,
    offset: Offset(0, 9),
  ),
];

String _slotDay(Map<String, dynamic> slot) {
  final value = slot['day'];
  if (value == null || value.toString().trim().isEmpty) return 'اليوم';
  return value.toString().trim();
}

String _slotStart(Map<String, dynamic> slot) {
  final value = slot['start_time'];
  if (value == null || value.toString().trim().isEmpty) return '--:--';
  return value.toString().trim();
}

String _slotEnd(Map<String, dynamic> slot) {
  final value = slot['end_time'];
  if (value == null || value.toString().trim().isEmpty) return '--:--';
  return value.toString().trim();
}

String _slotNotes(Map<String, dynamic> slot) {
  final value = slot['notes'];
  if (value == null || value.toString().trim().isEmpty) return '';
  return value.toString().trim();
}

String _visitStatus(Map<String, dynamic> slot) {
  final rawStatus = slot['status']?.toString().trim();
  if (rawStatus == 'استثناء' || rawStatus == 'exception') return 'استثناء';
  if (slot['is_available'] == false) return 'مغلق';
  if (_slotNotes(slot).isNotEmpty) return 'استثناء';
  return 'مفتوح';
}

Color _visitStatusColor(String status) {
  if (status == 'مفتوح') return _VisitHoursScreenState._statusGreen;
  if (status == 'استثناء') return _VisitHoursScreenState._primaryOrange;
  return _VisitHoursScreenState._textGray;
}

String _formatTime(String value) {
  final normalized = value.trim();
  if (normalized == '--:--' || normalized.isEmpty) return normalized;
  final parts = normalized.split(':');
  if (parts.length < 2) return normalized;
  final hour = int.tryParse(parts[0]);
  final minute = parts[1].padLeft(2, '0');
  if (hour == null) return normalized;
  final suffix = hour >= 12 ? 'م' : 'ص';
  final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  return '${displayHour.toString().padLeft(2, '0')}:$minute $suffix';
}

class _VisitText {
  static const TextStyle title = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _VisitHoursScreenState._textBlack,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _VisitHoursScreenState._textBlack,
    fontSize: 16,
    height: 1.3,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _VisitHoursScreenState._textBlack,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle sheetTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _VisitHoursScreenState._textBlack,
    fontSize: 17,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle emptyTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _VisitHoursScreenState._textBlack,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle dayTitle = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _VisitHoursScreenState._textBlack,
    fontSize: 14.5,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle body = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _VisitHoursScreenState._textGray,
    fontSize: 13.5,
    height: 1.45,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle time = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _VisitHoursScreenState._textBlack,
    fontSize: 13,
    height: 1.35,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle muted = TextStyle(
    fontFamily: careHomeFontFamily,
    color: _VisitHoursScreenState._textGray,
    fontSize: 12,
    height: 1.35,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle button = TextStyle(
    fontFamily: careHomeFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  const _VisitText._();
}
