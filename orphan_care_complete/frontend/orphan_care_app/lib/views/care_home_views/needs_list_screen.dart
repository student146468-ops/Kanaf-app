import 'package:flutter/material.dart';

import '../../models/need_model.dart';
import '../../providers/app_provider_scope.dart';
import 'care_home_reference_widgets.dart';

class NeedsListScreen extends StatefulWidget {
  const NeedsListScreen({super.key});

  @override
  State<NeedsListScreen> createState() => _NeedsListScreenState();
}

class _NeedsListScreenState extends State<NeedsListScreen> {
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppProviderScope.of(context).fetchNeeds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final needs = provider.needs.where(_matchesFilter).toList();

    return CareHomeRefScaffold(
      title: 'قائمة الاحتياجات',
      bottomIndex: 1,
      actions: [
        IconButton(
          tooltip: 'إضافة احتياج',
          onPressed: () =>
              Navigator.of(context).pushNamed('/care_home_add_need'),
          icon: const Icon(Icons.add_rounded, color: careHomeRefText),
        ),
      ],
      body: RefreshIndicator(
        color: careHomeRefOrange,
        onRefresh: provider.fetchNeeds,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            Row(
              children: [
                CareHomeRefChip(
                  label: 'الكل',
                  selected: _filter == 'all',
                  onTap: () => setState(() => _filter = 'all'),
                ),
                const SizedBox(width: 8),
                CareHomeRefChip(
                  label: 'عاجل',
                  selected: _filter == 'urgent',
                  onTap: () => setState(() => _filter = 'urgent'),
                ),
                const SizedBox(width: 8),
                CareHomeRefChip(
                  label: 'قيد التنفيذ',
                  selected: _filter == 'active',
                  onTap: () => setState(() => _filter = 'active'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (provider.isLoading)
              const Padding(
                padding: EdgeInsets.all(28),
                child: Center(
                  child: CircularProgressIndicator(color: careHomeRefOrange),
                ),
              )
            else if (needs.isEmpty)
              const CareHomeRefEmpty(title: 'لا توجد احتياجات حاليا')
            else
              ...needs.map((need) => _NeedCard(need: need)),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  bool _matchesFilter(NeedModel need) {
    if (_filter == 'urgent') return need.priority == 'urgent';
    if (_filter == 'active') return need.status != 'completed';
    return true;
  }
}

class _NeedCard extends StatelessWidget {
  final NeedModel need;

  const _NeedCard({required this.need});

  @override
  Widget build(BuildContext context) {
    final total = double.tryParse(need.requiredQuantity) ?? 0;
    final progress =
        total <= 0 ? 0.0 : (need.fulfilledQuantity / total).clamp(0.0, 1.0);

    return CareHomeRefCard(
      onTap: () => Navigator.of(context)
          .pushNamed('/care_home_need_details', arguments: need.id),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        need.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: careHomeRefBodyStrong,
                      ),
                    ),
                    _Badge(text: _priorityLabel(need.priority)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(_categoryLabel(need.category), style: careHomeRefCaption),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFE9F2ED),
                    color: const Color(0xFF2DA56A),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '${need.fulfilledQuantity.toStringAsFixed(0)} من ${need.requiredQuantity}',
                  style: careHomeRefCaption,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CareHomeRefImage(
            width: 80,
            height: 80,
            imageUrl: need.imageUrl,
            assetPath: _assetForNeed(need.category),
            icon: Icons.inventory_2_outlined,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;

  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFE8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: careHomeRefCaption.copyWith(color: careHomeRefOrange),
      ),
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
