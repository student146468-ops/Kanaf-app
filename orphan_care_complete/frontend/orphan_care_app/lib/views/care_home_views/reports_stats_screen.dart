import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import 'care_home_reference_widgets.dart';

class ReportsStatsScreen extends StatefulWidget {
  const ReportsStatsScreen({super.key});

  @override
  State<ReportsStatsScreen> createState() => _ReportsStatsScreenState();
}

class _ReportsStatsScreenState extends State<ReportsStatsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppProviderScope.of(context).fetchReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProviderScope.of(context);
    final reports = provider.reports;

    return CareHomeRefScaffold(
      title: 'التقارير',
      body: RefreshIndicator(
        color: careHomeRefOrange,
        onRefresh: provider.fetchReports,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            CareHomeRefCard(
              child: Row(
                children: [
                  _Metric(
                    value: careHomeValue(reports['donations_total'], '0'),
                    label: 'التبرعات',
                  ),
                  _Metric(
                    value: careHomeValue(reports['completed_needs'], '0'),
                    label: 'المكتمل',
                  ),
                  _Metric(
                    value: careHomeValue(reports['volunteers_count'], '0'),
                    label: 'المتطوعون',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const CareHomeRefRowTile(
              icon: Icons.inventory_2_outlined,
              title: 'تقرير الاحتياجات',
              subtitle: 'متابعة المنشور والمكتمل وقيد التنفيذ',
            ),
            const CareHomeRefRowTile(
              icon: Icons.volunteer_activism_outlined,
              title: 'تقرير التبرعات',
              subtitle: 'ملخص التبرعات المالية والعينية',
            ),
            const CareHomeRefRowTile(
              icon: Icons.groups_2_outlined,
              title: 'تقرير المتطوعين',
              subtitle: 'عدد الطلبات وحالة كل مشاركة',
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String value;
  final String label;

  const _Metric({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: careHomeRefTitle.copyWith(color: careHomeRefOrange)),
          const SizedBox(height: 4),
          Text(label, style: careHomeRefCaption),
        ],
      ),
    );
  }
}
