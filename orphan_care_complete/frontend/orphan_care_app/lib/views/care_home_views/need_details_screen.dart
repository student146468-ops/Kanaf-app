import 'package:flutter/material.dart';

import '../../models/need_model.dart';
import '../../providers/app_provider_scope.dart';
import 'care_home_reference_widgets.dart';

class NeedDetailsScreen extends StatefulWidget {
  const NeedDetailsScreen({super.key});

  @override
  State<NeedDetailsScreen> createState() => _NeedDetailsScreenState();
}

class _NeedDetailsScreenState extends State<NeedDetailsScreen> {
  int? _loadedId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = int.tryParse(
      ModalRoute.of(context)?.settings.arguments?.toString() ?? '',
    );
    if (id != null && id != _loadedId) {
      _loadedId = id;
      AppProviderScope.of(context).fetchNeedDetails(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final need = provider.selectedNeed;

    return CareHomeRefScaffold(
      title: 'تفاصيل الاحتياج',
      bodyPadding: EdgeInsets.zero,
      bottomAction: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
        child: CareHomeRefButton(
          label: 'تعديل الاحتياج',
          icon: Icons.edit_outlined,
          onPressed: need == null
              ? null
              : () => Navigator.of(context)
                  .pushNamed('/care_home_edit_need', arguments: need.id),
        ),
      ),
      body: provider.isLoading || need == null
          ? const Center(
              child: CircularProgressIndicator(color: careHomeRefOrange),
            )
          : _DetailsBody(need: need),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  final NeedModel need;

  const _DetailsBody({required this.need});

  @override
  Widget build(BuildContext context) {
    final total = double.tryParse(need.requiredQuantity) ?? 0;
    final progress =
        total <= 0 ? 0.0 : (need.fulfilledQuantity / total).clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 92),
      physics: const BouncingScrollPhysics(),
      children: [
        Stack(
          children: [
            CareHomeRefImage(
              imageUrl: need.imageUrl,
              assetPath: _assetForNeed(need.category),
              height: 180,
              icon: Icons.inventory_2_outlined,
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: _Badge(text: _priorityLabel(need.priority)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(need.title, style: careHomeRefTitle),
        const SizedBox(height: 6),
        Text(_categoryLabel(need.category), style: careHomeRefCaption),
        const SizedBox(height: 14),
        Text(need.description, style: careHomeRefBody.copyWith(height: 1.8)),
        const SizedBox(height: 18),
        Text('نسبة الإنجاز', style: careHomeRefBodyStrong),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            color: careHomeRefOrange,
            backgroundColor: const Color(0xFFFFEFE8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${(progress * 100).toStringAsFixed(0)}%',
          style: careHomeRefBodyStrong.copyWith(color: careHomeRefOrange),
        ),
        const SizedBox(height: 12),
        CareHomeRefCard(
          child: Row(
            children: [
              Expanded(
                child: _Info(
                  icon: Icons.inventory_2_outlined,
                  label: 'المطلوب',
                  value: need.requiredQuantity,
                ),
              ),
              Expanded(
                child: _Info(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'المحقق',
                  value: need.fulfilledQuantity.toStringAsFixed(0),
                ),
              ),
              Expanded(
                child: _Info(
                  icon: Icons.flag_outlined,
                  label: 'الحالة',
                  value: _statusLabel(need.status),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _Info({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: careHomeRefText, size: 20),
        const SizedBox(height: 6),
        Text(label, style: careHomeRefCaption),
        const SizedBox(height: 4),
        Text(value, style: careHomeRefBodyStrong),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;

  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: careHomeRefOrange,
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          Text(text, style: careHomeRefCaption.copyWith(color: Colors.white)),
    );
  }
}

String _assetForNeed(String category) {
  switch (category) {
    case 'education':
      return 'assets/images/image2.png';
    case 'food':
      return 'assets/images/image11.png';
    case 'clothes':
      return 'assets/images/image10.png';
    default:
      return 'assets/images/image12.png';
  }
}

String _priorityLabel(String value) {
  switch (value) {
    case 'urgent':
      return 'عاجل';
    case 'low':
      return 'منخفض';
    default:
      return 'معتدل';
  }
}

String _statusLabel(String value) {
  switch (value) {
    case 'completed':
      return 'مكتمل';
    case 'archived':
      return 'مؤرشف';
    default:
      return 'قيد التنفيذ';
  }
}

String _categoryLabel(String value) {
  switch (value) {
    case 'education':
      return 'تعليم';
    case 'food':
      return 'غذاء';
    case 'clothes':
      return 'ملابس';
    case 'medical':
      return 'صحة';
    default:
      return value.isEmpty ? 'احتياج' : value;
  }
}
