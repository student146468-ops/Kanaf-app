import 'package:flutter/material.dart';
import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

/// [ReportsStatsScreen] - الواجهة رقم 35: لوحة التقارير والتحليلات الذكية لدار الرعاية لعام 2026.
/// تعرض إحصائيات التبرعات المستلمة، ونسب تلبية الاحتياجات، ومستوى تفاعل المتطوعين برسوم بيانية وبطاقات واضحة واضحة.
class ReportsStatsScreen extends StatefulWidget {
  const ReportsStatsScreen({super.key});

  @override
  State<ReportsStatsScreen> createState() => _ReportsStatsScreenState();
}

class _ReportsStatsScreenState extends State<ReportsStatsScreen> {
  String _selectedPeriod = 'هذا الشهر'; // هذا الشهر، هذا العام، الكلي

  // بيانات دقيقة ومحاكاة قوية لـ "تطبيق كَنَفْ" لعرض لوحة إحصائية مقنعة.
  final Map<String, dynamic> _statsData = {
    'total_donations': '45,230 د.ل',
    'needs_fulfilled_rate': 88, // نسبة مئوية لطلب مخصص
    'active_volunteers': '34 متطوع',
    'children_sponsored': '112 طفل',
  };

  // توزيع نسب الاحتياجات الملبّاة لبناء رسم بياني شريطي منظم.
  final List<Map<String, dynamic>> _chartData = [
    {'label': 'غذائية', 'percentage': 0.95, 'color': const Color(0xFF10B981)},
    {'label': 'طبية', 'percentage': 0.82, 'color': const Color(0xFF3B82F6)},
    {'label': 'كسوة', 'percentage': 0.70, 'color': AppColors.brandOrange},
    {'label': 'تعليمية', 'percentage': 0.90, 'color': const Color(0xFF8B5CF6)},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final containerWidth = isWebOrDesktop ? 420.0 : double.infinity;
    final providerStats = AppProviderScope.of(context).dashboardStats;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: Container(
            width: containerWidth,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              boxShadow: isWebOrDesktop
                  ? [
                      BoxShadow(
                          color: AppColors.innerShadow,
                          blurRadius: 45,
                          spreadRadius: 8)
                    ]
                  : [],
            ),
            child: Stack(
              children: [
                // خلفية بيضاء هادئة لتعزيز الهوية البصرية الموحدة
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.white,
                          AppColors.scaffoldBackground,
                          AppColors.scaffoldBackground,
                        ],
                        stops: [0.0, 0.52, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                ),

                // محتوى الإحصائيات والتقارير المنظم باحترافية
                SafeArea(
                  child: Column(
                    children: [
                      _buildAppBar(),
                      _buildPeriodFilter(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMainGridCards(providerStats),
                              const SizedBox(height: 24),
                              _buildSectionTitle(
                                  'نسبة تلبية الاحتياجات حسب الفئة'),
                              const SizedBox(height: 14),
                              _buildNeonProgressBarChart(),
                              const SizedBox(height: 24),
                              _buildSectionTitle(
                                  'تحميل التقارير الرسمية المعتمدة'),
                              const SizedBox(height: 14),
                              _buildDownloadReportCard(
                                  'تقرير التبرعات الربع سنوي لعام 2026.pdf',
                                  'تم التحديث منذ يومين'),
                              _buildDownloadReportCard(
                                  'تقرير المستودع والاحتياجات اللوجستية.pdf',
                                  'تم التحديث اليوم'),
                              const SizedBox(height: 25),
                              _buildNavigateToDashboardButton(),
                              const SizedBox(height: 20),
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.innerBorder),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textDarkPrimary, size: 18),
            ),
          ),
          const Text(
            'التقارير والإحصائيات الحية',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDarkPrimary,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildPeriodFilter() {
    final periods = ['هذا الشهر', 'هذا العام', 'الكلي'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      child: Container(
        height: 42,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.surfaceLight),
        ),
        child: Row(
          children: periods.map((per) {
            final isSelected = _selectedPeriod == per;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedPeriod = per),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.innerBorder : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      per,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12.5,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected
                            ? AppColors.brandOrange
                            : AppColors.textDarkSecondary,
                      ),
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

  Widget _buildMainGridCards(Map<String, dynamic> providerStats) {
    final String totalDonations =
        providerStats['total_donations']?.toString() ??
            providerStats['monthly_support']?.toString() ??
            _statsData['total_donations'].toString();
    final String fulfilledRate =
        providerStats['needs_fulfilled_rate']?.toString() ??
            _statsData['needs_fulfilled_rate'].toString();
    final String volunteers = providerStats['volunteers']?.toString() ??
        providerStats['active_volunteers']?.toString() ??
        _statsData['active_volunteers'].toString();
    final String sponsoredChildren =
        providerStats['children_sponsored']?.toString() ??
            _statsData['children_sponsored'].toString();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: [
        _buildStatCard('إجمالي التبرعات', totalDonations,
            Icons.account_balance_wallet_rounded, AppColors.brandOrange),
        _buildStatCard('تلبية الاحتياجات', '$fulfilledRate%',
            Icons.analytics_rounded, const Color(0xFF10B981)),
        _buildStatCard('المتطوعين النشطين', volunteers,
            Icons.people_alt_rounded, const Color(0xFF3B82F6)),
        _buildStatCard('الأطفال المكفولين', sponsoredChildren,
            Icons.child_friendly_rounded, const Color(0xFF8B5CF6)),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return CareHomeCard(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 22),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.textDarkPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11.5,
              color: AppColors.textDarkSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeonProgressBarChart() {
    return CareHomeCard(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: _chartData.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDarkPrimary),
                    ),
                    Text(
                      '${(item['percentage'] * 100).toInt()}%',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: item['color']),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Stack(
                  children: [
                    Container(
                      height: 7,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    FractionallySizedBox(
                      widthFactor: item['percentage'],
                      child: Container(
                        height: 7,
                        decoration: BoxDecoration(
                          color: item['color'],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: item['color'].withOpacity(0.4),
                                blurRadius: 6,
                                spreadRadius: 1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDownloadReportCard(String reportName, String updateTime) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CareHomeCard(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded,
                  color: Colors.redAccent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reportName,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDarkPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    updateTime,
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10.5,
                        color: AppColors.textDarkSecondary.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.file_download_rounded,
                  color: AppColors.brandOrange, size: 22),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('جاري تحميل $reportName لفرع غريان...',
                        style: const TextStyle(fontFamily: 'Cairo')),
                    backgroundColor: const Color(0xFF10B981),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigateToDashboardButton() {
    return GestureDetector(
      onTap: () {
        // الربط المباشر مع واجهة الـ Dashboard الرئيسية لتسهيل التصفح اللوجستي الفوري
        Navigator.of(context).pushNamed('/care_home_dashboard');
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.innerBorder),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dashboard_customize_rounded,
                  color: AppColors.textDarkPrimary, size: 18),
              SizedBox(width: 8),
              Text(
                'العودة للوحة التحكم الرئيسية',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDarkPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: AppColors.textDarkPrimary,
      ),
    );
  }
}
