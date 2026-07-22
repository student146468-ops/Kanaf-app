import 'package:flutter/material.dart';

import '../../models/need_model.dart';
import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class NeedDetailsScreen extends StatefulWidget {
  const NeedDetailsScreen({super.key});

  @override
  State<NeedDetailsScreen> createState() => _NeedDetailsScreenState();
}

class _NeedDetailsScreenState extends State<NeedDetailsScreen> {
  int? _needId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_needId != null) return;
    final rawId = ModalRoute.of(context)?.settings.arguments;
    _needId = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
    if (_needId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppProviderScope.of(context).fetchNeedDetails(_needId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final provider = AppProviderScope.of(context);
    final need = provider.selectedNeed;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: Container(
            width: isWebOrDesktop ? 430 : double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  CareHomeTopBar(
                    title: 'تفاصيل الاحتياج',
                    onBack: () => Navigator.of(context).pop(),
                    includeSafeArea: false,
                  ),
                  Expanded(
                    child: provider.isLoading || need == null
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: () => provider.fetchNeedDetails(need.id),
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: CareHomeSpacing.lg,
                                  vertical: CareHomeSpacing.md),
                              children: [
                                _hero(need),
                                const SizedBox(height: CareHomeSpacing.xl),
                                _section('بيانات الاحتياج'),
                                const SizedBox(height: CareHomeSpacing.sm),
                                _dataCard(need),
                                const SizedBox(height: CareHomeSpacing.xl),
                                _section('تفاصيل إضافية'),
                                const SizedBox(height: CareHomeSpacing.sm),
                                CareHomeCard(
                                  padding:
                                      const EdgeInsets.all(CareHomeSpacing.lg),
                                  child: Text(
                                    need.description.isEmpty
                                        ? 'لا توجد تفاصيل إضافية'
                                        : need.description,
                                    style: CareHomeTextStyles.body
                                        .copyWith(height: 1.6),
                                  ),
                                ),
                                const SizedBox(height: CareHomeSpacing.xl),
                                _actions(need, provider),
                              ],
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

  Widget _hero(NeedModel need) {
    return CareHomeCard(
      padding: const EdgeInsets.all(CareHomeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'care-home-need-${need.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(careHomeRadiusLarge),
              child: Container(
                width: double.infinity,
                height: 170,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(careHomeRadiusLarge),
                  border: Border.all(color: AppColors.innerBorder),
                ),
                child: need.imageUrl == null || need.imageUrl!.isEmpty
                    ? Icon(need.icon,
                        color: AppColors.textDarkMuted.withOpacity(0.45),
                        size: 42)
                    : Image.network(need.imageUrl!, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: CareHomeSpacing.md),
          CareHomeStatusBadge(
              label: need.priorityLabel,
              color: AppColors.brandOrange,
              icon: Icons.priority_high_rounded),
          const SizedBox(height: CareHomeSpacing.sm),
          Text(need.title,
              style: CareHomeTextStyles.title
                  .copyWith(fontSize: 21, fontWeight: FontWeight.w900)),
          const SizedBox(height: CareHomeSpacing.xs),
          Text(need.requiredQuantity,
              style: CareHomeTextStyles.body
                  .copyWith(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _dataCard(NeedModel need) {
    return CareHomeCard(
      padding: const EdgeInsets.all(CareHomeSpacing.lg),
      child: Column(
        children: [
          _row('التصنيف', need.category),
          const Divider(color: AppColors.divider),
          _row('الأولوية', need.priorityLabel),
          const Divider(color: AppColors.divider),
          _row('الحالة', need.statusLabel),
          const Divider(color: AppColors.divider),
          _row('الكمية المطلوبة', need.requiredQuantity),
          const Divider(color: AppColors.divider),
          _row('تاريخ النشر',
              need.createdAt == null ? '-' : _formatDate(need.createdAt!)),
        ],
      ),
    );
  }

  Widget _actions(NeedModel need, dynamic provider) {
    return Row(
      children: [
        Expanded(
          child: CareHomeSecondaryButton(
            label: 'تعديل البيانات',
            icon: Icons.edit_note_rounded,
            onPressed: () async {
              await Navigator.of(context)
                  .pushNamed('/care_home_edit_need', arguments: need.id);
              if (mounted) provider.fetchNeedDetails(need.id);
            },
            height: 52,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CareHomePrimaryButton(
            label: 'أرشفة',
            icon: Icons.archive_rounded,
            loading: provider.isSaving,
            onPressed: () async {
              final success = await provider.archiveNeed(need.id);
              if (!mounted) return;
              if (success) Navigator.of(context).pop(true);
            },
            height: 52,
          ),
        ),
      ],
    );
  }

  Widget _section(String title) {
    return Text(title,
        style: CareHomeTextStyles.sectionTitle.copyWith(fontSize: 15));
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label,
              style: CareHomeTextStyles.body
                  .copyWith(fontWeight: FontWeight.w800)),
          const Spacer(),
          Flexible(
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  CareHomeTextStyles.body.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
