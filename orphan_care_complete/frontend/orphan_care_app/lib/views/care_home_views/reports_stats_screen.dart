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
  String _selectedPeriod = 'هذا الشهر';

  // TODO: Replace fallback report stats with AppProvider/backend reporting data.
  final Map<String, dynamic> _statsData = {
    'total_donations': '45,230 د.ل',
    'needs_fulfilled_rate': 88,
    'active_volunteers': '34 متطوع',
    'children_sponsored': '112 طفل',
  };

  final List<Map<String, dynamic>> _chartData = [
    {'label': 'غذائي', 'percentage': 0.95, 'color': const Color(0xFF10B981)},
    {'label': 'طبي', 'percentage': 0.82, 'color': const Color(0xFF3B82F6)},
    {'label': 'كسوة', 'percentage': 0.70, 'color': AppColors.brandOrange},
    {'label': 'تعليمي', 'percentage': 0.90, 'color': const Color(0xFF8B5CF6)},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final providerStats = AppProviderScope.of(context).dashboardStats;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: Container(
            width: isWebOrDesktop ? 430 : double.infinity,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              boxShadow: isWebOrDesktop
                  ? [
                      BoxShadow(
                        color: AppColors.innerShadow,
                        blurRadius: 24,
                        spreadRadius: 0,
                      )
                    ]
                  : [],
            ),
            child: Stack(
              children: [
                const Positioned.fill(child: _CareHomeBackground()),
                SafeArea(
                  child: Column(
                    children: [
                      _HeaderBar(
                        title: 'التقارير والإحصائيات',
                        onBack: () => Navigator.of(context).pop(),
                      ),
                      _PeriodFilter(
                        selected: _selectedPeriod,
                        onChanged: (value) =>
                            setState(() => _selectedPeriod = value),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _StatsGrid(
                                providerStats: providerStats,
                                fallback: _statsData,
                              ),
                              const SizedBox(height: 22),
                              const _SectionTitle('نسبة تلبية الاحتياجات'),
                              const SizedBox(height: 12),
                              _ProgressChart(items: _chartData),
                              const SizedBox(height: 22),
                              const _SectionTitle('التقارير المتاحة'),
                              const SizedBox(height: 12),
                              _ReportCard(
                                name: 'تقرير التبرعات الربع سنوي',
                                time: 'تم التحديث منذ يومين',
                                onTap: _showDownloadMessage,
                              ),
                              const SizedBox(height: 10),
                              _ReportCard(
                                name: 'تقرير الاحتياجات والمخزون',
                                time: 'تم التحديث اليوم',
                                onTap: _showDownloadMessage,
                              ),
                              const SizedBox(height: 18),
                              _SecondaryAction(
                                label: 'العودة للوحة الدار',
                                icon: Icons.dashboard_customize_outlined,
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/care_home_dashboard'),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  void _showDownloadMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'سيتم تفعيل تحميل التقارير عند ربط خدمة الملفات.',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }
}

class _CareHomeBackground extends StatelessWidget {
  const _CareHomeBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.white, AppColors.scaffoldBackground],
        ),
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _HeaderBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _CircleButton(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textDarkPrimary,
              ),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.innerBorder),
        ),
        child: Icon(icon, color: AppColors.textDarkPrimary, size: 19),
      ),
    );
  }
}

class _PeriodFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _PeriodFilter({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const periods = ['هذا الشهر', 'هذا العام', 'الكل'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
      child: Container(
        height: 42,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.innerBorder),
        ),
        child: Row(
          children: periods.map((period) {
            final isSelected = selected == period;
            return Expanded(
              child: InkWell(
                onTap: () => onChanged(period),
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    period,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? AppColors.brandOrange
                          : AppColors.textDarkSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final Map<String, dynamic> providerStats;
  final Map<String, dynamic> fallback;

  const _StatsGrid({required this.providerStats, required this.fallback});

  @override
  Widget build(BuildContext context) {
    final totalDonations = providerStats['total_donations']?.toString() ??
        providerStats['monthly_support']?.toString() ??
        fallback['total_donations'].toString();
    final fulfilledRate = providerStats['needs_fulfilled_rate']?.toString() ??
        fallback['needs_fulfilled_rate'].toString();
    final volunteers = providerStats['volunteers']?.toString() ??
        providerStats['active_volunteers']?.toString() ??
        fallback['active_volunteers'].toString();
    final children = providerStats['children_sponsored']?.toString() ??
        fallback['children_sponsored'].toString();

    final cards = [
      _StatData('إجمالي التبرعات', totalDonations,
          Icons.account_balance_wallet_outlined, AppColors.brandOrange),
      _StatData('تلبية الاحتياجات', '$fulfilledRate%', Icons.analytics_outlined,
          const Color(0xFF10B981)),
      _StatData('متطوعون نشطون', volunteers, Icons.groups_2_outlined,
          const Color(0xFF3B82F6)),
      _StatData('أطفال مكفولون', children, Icons.child_friendly_outlined,
          const Color(0xFF8B5CF6)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) => _StatCard(data: cards[index]),
    );
  }
}

class _StatData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatData(this.title, this.value, this.icon, this.color);
}

class _StatCard extends StatelessWidget {
  final _StatData data;

  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return CareHomeCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(data.icon, color: data.color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            data.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.textDarkPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
              color: AppColors.textDarkSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: AppColors.textDarkPrimary,
      ),
    );
  }
}

class _ProgressChart extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const _ProgressChart({required this.items});

  @override
  Widget build(BuildContext context) {
    return CareHomeCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: items.map((item) {
          final color = item['color'] as Color;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['label'],
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDarkPrimary,
                      ),
                    ),
                    Text(
                      '${(item['percentage'] * 100).toInt()}%',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: item['percentage'],
                    minHeight: 7,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String name;
  final String time;
  final VoidCallback onTap;

  const _ReportCard({
    required this.name,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CareHomeCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.description_outlined,
                color: AppColors.brandOrange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 11,
                    color: AppColors.textDarkSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.file_download_outlined,
                color: AppColors.brandOrange, size: 22),
          ),
        ],
      ),
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SecondaryAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.innerBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textDarkPrimary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textDarkPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
