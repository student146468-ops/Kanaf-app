import 'package:flutter/material.dart';

import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

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
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final provider = AppProviderScope.of(context);
    final reports = provider.reports;
    final needs = Map<String, dynamic>.from((reports['needs'] as Map?) ?? {});
    final donations =
        Map<String, dynamic>.from((reports['donations'] as Map?) ?? {});
    final volunteers =
        Map<String, dynamic>.from((reports['volunteers'] as Map?) ?? {});

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
                    title: 'التقارير والإحصائيات',
                    onBack: () => Navigator.of(context).pop(),
                    includeSafeArea: false,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: provider.fetchReports,
                      child: provider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: CareHomeSpacing.lg,
                                  vertical: CareHomeSpacing.md),
                              children: [
                                _metricGrid([
                                  _Metric(
                                      'إجمالي الاحتياجات',
                                      '${needs['total'] ?? 0}',
                                      Icons.inventory_2_outlined),
                                  _Metric(
                                      'الاحتياجات النشطة',
                                      '${needs['active'] ?? 0}',
                                      Icons.timelapse_rounded),
                                  _Metric(
                                      'الاحتياجات المكتملة',
                                      '${needs['completed'] ?? 0}',
                                      Icons.check_circle_outline_rounded),
                                  _Metric(
                                      'إجمالي التبرعات',
                                      '${donations['total'] ?? 0}',
                                      Icons.volunteer_activism_outlined),
                                  _Metric(
                                      'الدعم المالي',
                                      '${donations['total_amount'] ?? 0} د.ل',
                                      Icons.payments_rounded),
                                  _Metric(
                                      'طلبات التطوع',
                                      '${volunteers['requests'] ?? 0}',
                                      Icons.groups_2_outlined),
                                  _Metric(
                                      'ساعات التطوع',
                                      '${volunteers['hours'] ?? 0}',
                                      Icons.schedule_rounded),
                                ]),
                                const SizedBox(height: CareHomeSpacing.xl),
                                _breakdown('الاحتياجات حسب الحالة',
                                    needs['by_status']),
                                const SizedBox(height: CareHomeSpacing.lg),
                                _breakdown('الاحتياجات حسب الأولوية',
                                    needs['by_priority']),
                                const SizedBox(height: CareHomeSpacing.lg),
                                _breakdown('التبرعات حسب الحالة',
                                    donations['by_status']),
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

  Widget _metricGrid(List<_Metric> metrics) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: CareHomeSpacing.sm,
        mainAxisSpacing: CareHomeSpacing.sm,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return CareHomeCard(
          padding: const EdgeInsets.all(CareHomeSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(metric.icon,
                  color: AppColors.brandOrange, size: careHomeIconSize),
              const Spacer(),
              Text(metric.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CareHomeTextStyles.title.copyWith(fontSize: 20)),
              const SizedBox(height: 4),
              Text(metric.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CareHomeTextStyles.muted),
            ],
          ),
        );
      },
    );
  }

  Widget _breakdown(String title, dynamic rawItems) {
    final items = rawItems is List ? rawItems : const [];
    return CareHomeCard(
      padding: const EdgeInsets.all(CareHomeSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: CareHomeTextStyles.sectionTitle.copyWith(fontSize: 15)),
          const SizedBox(height: CareHomeSpacing.sm),
          if (items.isEmpty)
            const Text('لا توجد بيانات حتى الآن',
                style: CareHomeTextStyles.muted)
          else
            ...items.map((item) {
              final map = Map<String, dynamic>.from(item as Map);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(map.values.first.toString(),
                            style: CareHomeTextStyles.body)),
                    Text('${map['count'] ?? 0}',
                        style: CareHomeTextStyles.body
                            .copyWith(fontWeight: FontWeight.w900)),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _Metric {
  final String label;
  final String value;
  final IconData icon;

  const _Metric(this.label, this.value, this.icon);
}
