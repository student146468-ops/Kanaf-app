import 'package:flutter/material.dart';

import '../../models/need_model.dart';
import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class OrphanageProfileScreen extends StatefulWidget {
  const OrphanageProfileScreen({super.key});

  @override
  State<OrphanageProfileScreen> createState() => _OrphanageProfileScreenState();
}

class _OrphanageProfileScreenState extends State<OrphanageProfileScreen> {
  bool _hasLoadedData = false;

  static const Color _primaryOrange = Color(0xFFFF8C42);
  static const Color _screenBackground = Color(0xFFF5F5F5);
  static const Color _placeholderBackground = Color(0xFFF7F7F7);
  static const Color _cardBorder = Color(0xFFEAEAEA);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoadedData) return;
    _hasLoadedData = true;
    final provider = AppProviderScope.of(context);
    provider.fetchCareHomes();
    provider.fetchNeeds(notifyLoading: false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final orphanage = _orphanageFromBackend(provider.careHomes);
    final needs =
        provider.needs.map((need) => _needToMap(need, orphanage)).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _screenBackground,
        appBar: const DonorAppBar(
          title: 'ملف الدار',
        ),
        body: SafeArea(
          top: false,
          child: DonorMobileFrame(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 24),
              children: [
                const _OrphanageCoverImage(),
                Transform.translate(
                  offset: const Offset(0, -36),
                  child: Column(
                    children: [
                      _ProfileHeader(orphanage: orphanage),
                      const SizedBox(height: DonorSpacing.lg),
                      const _SpecialtyChips(),
                      const SizedBox(height: DonorSpacing.xl),
                      _AboutCard(text: orphanage['about']!),
                      const SizedBox(height: DonorSpacing.lg),
                      const _StatsRow(),
                      const SizedBox(height: DonorSpacing.lg),
                      _ActionButtons(
                        needs: needs,
                        orphanage: orphanage,
                      ),
                      const SizedBox(height: DonorSpacing.md),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, String> _orphanageFromBackend(List<Map<String, dynamic>> homes) {
    if (homes.isEmpty) {
      return const {
        'name': 'لا توجد دار مسجلة',
        'status': 'غير متوفر',
        'about': 'لا توجد بيانات دار رعاية متاحة من الخادم حاليًا.',
        'location': 'غير محدد',
        'phone': 'غير محدد',
      };
    }
    final home = homes.first;
    final description = home['description']?.toString().trim() ?? '';
    return {
      'name': home['name']?.toString() ?? '',
      'status': 'دار موثقة في كنف',
      'about': description.isNotEmpty
          ? description
          : home['address']?.toString() ?? '',
      'location': home['address']?.toString() ?? '',
      'phone': home['phone']?.toString() ?? '',
    };
  }

  Map<String, dynamic> _needToMap(
      NeedModel need, Map<String, String> orphanage) {
    final target = _quantityValue(need.requiredQuantity);
    final raised = need.fulfilledQuantity;
    final progress = target <= 0 ? 0.0 : raised / target;
    return {
      'orphanage': orphanage['name'] ?? '',
      'title': need.title,
      'raised': _amountLabel(raised),
      'target': need.requiredQuantity.isEmpty
          ? _amountLabel(target)
          : need.requiredQuantity,
      'remaining': target <= 0
          ? 'غير محدد'
          : _amountLabel((target - raised).clamp(0, target)),
      'progress': progress.clamp(0.0, 1.0),
      'daysLeft': 'غير محدد',
      'category': need.category,
      'urgency': need.priority == 'urgent' ? 'عاجل' : 'متوسط',
      'status': need.statusLabel,
      'description': need.description,
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
}

class _OrphanageCoverImage extends StatelessWidget {
  const _OrphanageCoverImage();

  @override
  Widget build(BuildContext context) {
    // TODO: Replace this placeholder with the final orphanage cover image asset.
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 178,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _OrphanageProfileScreenState._placeholderBackground,
          border: Border.all(color: _OrphanageProfileScreenState._cardBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_work_outlined,
              color: AppColors.textDarkMuted.withOpacity(0.45),
              size: 46,
            ),
            const SizedBox(height: DonorSpacing.xs),
            Text(
              'صورة دار الرعاية',
              style: DonorTextStyles.muted.copyWith(
                color: AppColors.textDarkMuted.withOpacity(0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.orphanage});

  final Map<String, String> orphanage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _OrphanageAvatar(),
        const SizedBox(height: DonorSpacing.md),
        Text(
          orphanage['name']!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: DonorTextStyles.title.copyWith(
            fontSize: 22,
            height: 1.35,
            color: AppColors.textDarkPrimary,
          ),
        ),
        const SizedBox(height: DonorSpacing.xs),
        Text(
          orphanage['location']!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: DonorTextStyles.muted.copyWith(
            color: AppColors.textDarkSecondary,
          ),
        ),
        const SizedBox(height: DonorSpacing.sm),
        const DonorStatusBadge(
          label: 'دار موثقة',
          color: _OrphanageProfileScreenState._primaryOrange,
          icon: Icons.verified_outlined,
        ),
      ],
    );
  }
}

class _OrphanageAvatar extends StatelessWidget {
  const _OrphanageAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: _OrphanageProfileScreenState._placeholderBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.apartment_rounded,
          color: AppColors.textDarkMuted.withOpacity(0.55),
          size: 34,
        ),
      ),
    );
  }
}

class _SpecialtyChips extends StatelessWidget {
  const _SpecialtyChips();

  @override
  Widget build(BuildContext context) {
    const chips = ['رعاية', 'تعليمي', 'صحي'];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: DonorSpacing.xs,
      runSpacing: DonorSpacing.xs,
      children: chips.map((label) {
        return DonorBadge(
          label: label,
          color: _OrphanageProfileScreenState._primaryOrange,
        );
      }).toList(),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DonorCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DonorSectionTitle('نبذة مختصرة'),
          const SizedBox(height: DonorSpacing.sm),
          Text(
            text,
            textAlign: TextAlign.start,
            style: DonorTextStyles.body.copyWith(
              fontSize: 14.5,
              height: 1.65,
              color: AppColors.textDarkSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _StatCard(value: '45', label: 'طفل')),
        SizedBox(width: DonorSpacing.sm),
        Expanded(child: _StatCard(value: '12', label: 'احتياج')),
        SizedBox(width: DonorSpacing.sm),
        Expanded(child: _StatCard(value: '88%', label: 'تغطية')),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DonorCard(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DonorTextStyles.title.copyWith(
              fontSize: 18,
              color: _OrphanageProfileScreenState._primaryOrange,
            ),
          ),
          const SizedBox(height: DonorSpacing.xxs),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DonorTextStyles.muted.copyWith(
              color: AppColors.textDarkSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.needs,
    required this.orphanage,
  });

  final List<Map<String, dynamic>> needs;
  final Map<String, String> orphanage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DonorPrimaryButton(
          label: 'عرض الاحتياجات',
          icon: Icons.list_alt_outlined,
          onTap: () => _showNeedsSheet(context),
        ),
        const SizedBox(height: DonorSpacing.sm),
        DonorSecondaryButton(
          label: 'تواصل',
          icon: Icons.call_outlined,
          color: AppColors.textDarkSecondary,
          onTap: () => _showContactSheet(context),
        ),
      ],
    );
  }

  void _showNeedsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: _NeedsBottomSheet(needs: needs),
        );
      },
    );
  }

  void _showContactSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: _ContactBottomSheet(orphanage: orphanage),
        );
      },
    );
  }
}

class _NeedsBottomSheet extends StatelessWidget {
  const _NeedsBottomSheet({required this.needs});

  final List<Map<String, dynamic>> needs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetHandle(),
            const SizedBox(height: DonorSpacing.xl),
            const DonorSectionTitle('احتياجات الدار الحالية'),
            const SizedBox(height: DonorSpacing.md),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: needs.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: DonorSpacing.md),
                itemBuilder: (context, index) => _NeedTile(need: needs[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactBottomSheet extends StatelessWidget {
  const _ContactBottomSheet({required this.orphanage});

  final Map<String, String> orphanage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetHandle(),
            const SizedBox(height: DonorSpacing.xl),
            const DonorSectionTitle('التواصل والموقع'),
            const SizedBox(height: DonorSpacing.md),
            _ContactRow(
              icon: Icons.location_on_outlined,
              text: orphanage['location']!,
            ),
            const Divider(height: 24, color: AppColors.divider),
            _ContactRow(
              icon: Icons.phone_outlined,
              text: orphanage['phone']!,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.innerBorder,
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DonorIconBox(
          icon: icon,
          color: _OrphanageProfileScreenState._primaryOrange,
          size: 42,
        ),
        const SizedBox(width: DonorSpacing.md),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textDirection:
                text.contains('X') ? TextDirection.ltr : TextDirection.rtl,
            style: DonorTextStyles.body.copyWith(
              color: AppColors.textDarkSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _NeedTile extends StatelessWidget {
  const _NeedTile({required this.need});

  final Map<String, dynamic> need;

  @override
  Widget build(BuildContext context) {
    final progress = (need['progress'] as num).toDouble().clamp(0.0, 1.0);
    final percentage = (progress * 100).round();
    final urgency = need['urgency'] as String;

    return DonorCard(
      onTap: () =>
          Navigator.pushNamed(context, '/need_details', arguments: need),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DonorIconBox(
                icon: _categoryIcon(need['category'] as String),
                color: _OrphanageProfileScreenState._primaryOrange,
                size: 42,
              ),
              const SizedBox(width: DonorSpacing.md),
              Expanded(
                child: Text(
                  need['title'] as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: DonorTextStyles.sectionTitle.copyWith(
                    fontSize: 14.5,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(width: DonorSpacing.xs),
              const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.textDarkMuted,
              ),
            ],
          ),
          const SizedBox(height: DonorSpacing.md),
          Row(
            children: [
              DonorStatusBadge(
                label: urgency,
                color: urgency == 'عاجل'
                    ? _OrphanageProfileScreenState._primaryOrange
                    : AppColors.textDarkSecondary,
              ),
              const SizedBox(width: DonorSpacing.sm),
              Expanded(
                child: Text(
                  '${need['target']} • $percentage%',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: DonorTextStyles.muted.copyWith(
                    color: AppColors.textDarkSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
    if (category.contains('غذ')) return Icons.restaurant_outlined;
    if (category.contains('كس')) return Icons.checkroom_outlined;
    if (category.contains('صح')) return Icons.health_and_safety_outlined;
    return Icons.volunteer_activism_outlined;
  }
}
