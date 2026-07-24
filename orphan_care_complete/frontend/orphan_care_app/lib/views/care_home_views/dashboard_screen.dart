import 'package:flutter/material.dart';

import '../../models/need_model.dart';
import '../../providers/app_provider_scope.dart';
import 'care_home_reference_widgets.dart';

class CareHomeDashboardScreen extends StatefulWidget {
  const CareHomeDashboardScreen({super.key});

  @override
  State<CareHomeDashboardScreen> createState() =>
      _CareHomeDashboardScreenState();
}

class _CareHomeDashboardScreenState extends State<CareHomeDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = AppProviderScope.of(context);
      provider.fetchDashboardStats();
      provider.fetchNeeds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final stats = provider.dashboardStats;
    final urgentNeeds = provider.needs.take(3).toList();

    return CareHomeRefScaffold(
      title: 'دار الأمان لرعاية الأيتام',
      showBack: false,
      bottomIndex: 0,
      body: RefreshIndicator(
        color: careHomeRefOrange,
        onRefresh: () async {
          await provider.fetchDashboardStats();
          await provider.fetchNeeds();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            Text('معا نصنع لهم مستقبلا أفضل', style: careHomeRefCaption),
            const SizedBox(height: 12),
            const CareHomeRefImage(
              assetPath: 'assets/images/image13.png',
              height: 142,
              icon: Icons.home_work_outlined,
            ),
            const SizedBox(height: 14),
            CareHomeRefCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Stat(value: stats['active_needs'] ?? '10', label: 'محتاجة'),
                  _Stat(
                      value: stats['volunteers'] ?? '8', label: 'قيد التنفيذ'),
                  _Stat(
                      value: stats['completed_needs'] ?? '14', label: 'مشروع'),
                ],
              ),
            ),
            CareHomeRefButton(
              label: 'استكشف الاحتياجات',
              onPressed: () =>
                  Navigator.of(context).pushNamed('/care_home_needs_list'),
            ),
            const SizedBox(height: 20),
            Text('احتياجات عاجلة', style: careHomeRefBodyStrong),
            const SizedBox(height: 10),
            if (provider.isLoading)
              const Padding(
                padding: EdgeInsets.all(28),
                child: Center(
                  child: CircularProgressIndicator(color: careHomeRefOrange),
                ),
              )
            else if (urgentNeeds.isEmpty)
              const CareHomeRefEmpty(title: 'لا توجد احتياجات حاليا')
            else
              ...urgentNeeds.map((need) => _NeedMiniCard(need: need)),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final dynamic value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          careHomeValue(value, '0'),
          style: careHomeRefTitle.copyWith(color: careHomeRefOrange),
        ),
        const SizedBox(height: 4),
        Text(label, style: careHomeRefCaption),
      ],
    );
  }
}

class _NeedMiniCard extends StatelessWidget {
  final NeedModel need;

  const _NeedMiniCard({required this.need});

  @override
  Widget build(BuildContext context) {
    final total = double.tryParse(need.requiredQuantity) ?? 0;
    final progress =
        total <= 0 ? 0.0 : (need.fulfilledQuantity / total).clamp(0.0, 1.0);

    return CareHomeRefCard(
      padding: const EdgeInsets.all(10),
      onTap: () => Navigator.of(context)
          .pushNamed('/care_home_need_details', arguments: need.id),
      child: Row(
        children: [
          CareHomeRefImage(
            width: 78,
            height: 78,
            imageUrl: need.imageUrl,
            assetPath: _assetForNeed(need.category),
            icon: Icons.inventory_2_outlined,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  need.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: careHomeRefBodyStrong,
                ),
                const SizedBox(height: 4),
                Text(_categoryLabel(need.category), style: careHomeRefCaption),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFE9F2ED),
                    color: const Color(0xFF2DA56A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(need.requiredQuantity, style: careHomeRefCaption),
        ],
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
